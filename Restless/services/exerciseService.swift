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


struct exerciseView: View {
    var body: some View {
        // testing functions to ensurre working API
        Button("test all muscles") {
            Task {
                do {
                    let muscles = try await service_allMuscles()
                    print(muscles)
                } catch {
                    print("Error fetching exercises: \(error)")
                }
            }
        }
        Button("test exercise by muscle group") {
            Task {
                do {
                    let fetched_exercises = try await service_getExercises_muscle(muscleGroup: "chest")
                    for exercise in fetched_exercises {
                        print(exercise)
                    }
                } catch {
                    print("Error fetching exercises: \(error)")
                }
            }
        }
        Button("test exercises by muscle Group, json formatting"){
            service_getExercises_byMuscle(muscleGroup: "shin")
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
func service_allMuscles() async throws -> [String] {
    let url = URL(string: "https://www.exercisedb.dev/api/v1/muscles")!
    let (data, _) = try await URLSession.shared.data(from: url)
    let decoded = try JSONDecoder().decode(MuscleGroups.self, from: data)
    // name of all muscle groups
    return decoded.data.map { $0.name }
}

func service_getExercises_muscle(muscleGroup: String) async throws -> [Exercise] {
    let baseURL = "https://www.exercisedb.dev/api/v1/muscles/"
    guard let encodedGroup = muscleGroup.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
        let url = URL(string: baseURL + encodedGroup + "/exercises") else {
        print("Invalid URL")
        return [] // return empty exercise list if API failss
    }
    let (data, _) = try await URLSession.shared.data(from: url)
    let decoder = JSONDecoder()
    do {
        let exercises = try decoder.decode([Exercise].self, from: data)
        // array of Exercises
        print("Found \(exercises.count) exercises")
        return exercises
    } catch {
        print("Decoding error: \(error)")
    }
    // if api returns nothing (possible) due to api having some inconsistencies
    return []
}

// fetches all exercises related to a chosen muscle groups
func service_getExercises_byMuscle(muscleGroup: String) { //async throws -> [Exercise] {
    // handle spacing for more complex muscle groups
    let baseURL = "https://www.exercisedb.dev/api/v1/muscles/"
    guard let encodedGroup = muscleGroup.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
        let url = URL(string: baseURL + encodedGroup + "/exercises") else {
        print("Invalid URL")
        return // return empty exercise list if API fails
    }
    let request = NSMutableURLRequest(
        url: url,
        cachePolicy: .useProtocolCachePolicy,
        timeoutInterval: 10.0)
    // create url request link and set rest method
    request.httpMethod = "GET"

    let session = URLSession.shared
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
