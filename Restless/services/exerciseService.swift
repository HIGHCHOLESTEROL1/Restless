//
//  exerciseService.swift
//  Restless
//
//  Created by Brian Wang-chen on 11/7/25.
//

import Foundation
import SwiftUI

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        var set = CharacterSet.urlQueryAllowed
        set.remove(charactersIn: "&=?") // keep comma!", not removed
        return set
    }()
}

// api meta data
struct Metadata: Decodable {
    let totalPages: Int
    let totalExercises: Int
    let currentPage: Int
    let previousPage: String? // handle nulls in case none
    let nextPage: String?
}

// classes for muscle groups
struct MuscleResponse: Codable {
    let success: Bool
    let data: [Muscle]
}
struct Muscle: Codable {
    let name: String
}

// class for exercises
struct ExerciseResponse: Decodable {
    let success: Bool
    let metadata: Metadata
    let data: [Exercise]
}

struct Exercise: Decodable {
    let exerciseId: String
    let name: String
    let gifUrl: URL
    let targetMuscles: [String]
    let bodyParts: [String]
    let equipments: [String]
    let secondaryMuscles: [String]
    let instructions: [String]
}

struct exerciseView: View {
    var body: some View {
        // testing functions to ensurre working API
        Button("test all muscles") {
            Task {
                do {
                    let muscles = try await service_allMuscles()
                    for muscle in muscles {
                        print(muscle.name)
                    }
                } catch {
                    print("Error fetching exercises: \(error)")
                }
            }
        }
        Button("test exercise by muscle group") {
            Task {
                do {
                    let fetched_exercises = try await service_getExercises_muscle(muscleGroup: "abs")
                    for exercise in fetched_exercises {
                        print(exercise.name)
                    }
                } catch {
                    print("Error fetching exercises: \(error)")
                }
            }
        }
        Button("test search by exercise") {
            service_getExercises_bySearch(searchTerm: "chest press")
        }
        let muscleList = ["chest", "triceps"]
        let equipmentList = ["dumbbell", "barbell"]
        Button("test advanced filtering exercises") {
            service_advanced_getExercises(searchTerm: "chest workout", muscleGroup: muscleList, equipment: equipmentList)
        }
    }
}

// fetches all muscle groups
func service_allMuscles() async throws -> [Muscle] {
    let url = URL(string: "https://www.exercisedb.dev/api/v1/muscles")!
    let (data, _) = try await URLSession.shared.data(from: url)
    do {
        let musclesData = try JSONDecoder().decode(MuscleResponse.self, from: data)
        if musclesData.success { // api success
            print("Found \(musclesData.data.count) muscle groups")
            // name of all muscle groups
            return musclesData.data
        }
        print("API failure: fetch all muscles")
        return []
    // handle JSONDecoder error
    } catch {
        print("Decoding error: fetch all muscles")
        return []
    }
}

func service_getExercises_muscle(muscleGroup: String) async throws -> [Exercise] {
    let baseURL = "https://www.exercisedb.dev/api/v1/muscles/"
    guard let encodedGroup = muscleGroup.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          var url = URL(string: baseURL + encodedGroup + "/exercises" + "?limit=25")
    else {
        return []
    }
    // initial response
    var allExercises : [Exercise] = []
    do {
        // some responses can return multiple pages of data
        // Will iterate through each page until page is NULL fetching evry exercise
        var i = 0
        while true{
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse else {
                break
            }
            if httpResponse.statusCode == 429 { // API limited calls
                print("Rate limited. Ending")
                break // prevent pagination when API calls are limited
            }
            guard httpResponse.statusCode == 200 else { // only run on 200 success code
                print("Bad status:", httpResponse.statusCode)
                break
            }
            let exercisesData = try JSONDecoder().decode(ExerciseResponse.self, from: data)
            if exercisesData.success {
                allExercises.append(contentsOf: exercisesData.data)
                // get to next page
                if let nextPath = exercisesData.metadata.nextPage {
                    let httpsPath = nextPath.replacingOccurrences(of: "http://", with: "https://") // force https cause for some reason API changes it
                    guard let nextURL = URL(string: httpsPath + "?limit=25") else { break }
                    url = nextURL
                    // Small delay to avoid rate limiting
                    try await Task.sleep(nanoseconds: 100_000_000)
                } else {
                    break
                }
            }
            else{
                print("API failure: fetch exercise[muscle]")
                return []
            }
        }
        return allExercises
    } catch {
        print("Decoding error:", error)
        return []
    }
}


// advanced filtering for searching for exercises
func service_getExercises_bySearch(searchTerm: String) {
    // creates the mutable url request
    var components = URLComponents(string: "https://www.exercisedb.dev/api/v1/exercises")
    // set query parameters
    components?.queryItems = [
        URLQueryItem(name: "search", value: searchTerm),
        URLQueryItem(name: "sortBy", value: "targetMuscles")
    ]
    guard let url = components?.url else {
        print("Invalid url")
        return
    }
    // set http method and create network sess
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    let session = URLSession.shared
    
    // create task
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        
        if (error != nil) {
            print(error as Any)
        }
        if let data = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print("JSON parsing error:", error)
            }
        }
    })
    dataTask.resume()
}

// advanced filtering search
func service_advanced_getExercises(searchTerm: String, muscleGroup: Array<String>, equipment: Array<String>) {
    // creates the mutable url request
    var components = URLComponents(string: "https://www.exercisedb.dev/api/v1/exercises/filter")
    // set query parameters
    components?.queryItems = [
        URLQueryItem(name: "search", value: searchTerm),
        URLQueryItem(name: "muscles", value: muscleGroup.joined(separator: ",")),
        URLQueryItem(name: "equipment", value: equipment.joined(separator: ",")),
        URLQueryItem(name: "sortBy", value: "targetMuscles")
    ]
    guard let url = components?.url else {
        print("Invalid url")
        return
    }
    // set http method and create network sess
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    let session = URLSession.shared
    
    // create task
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        
        if (error != nil) {
            print(error as Any)
        }
        if let data = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print("JSON parsing error:", error)
            }
        }
    })
    dataTask.resume()
}

#Preview {
    exerciseView()
}
