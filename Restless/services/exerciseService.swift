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
    let total: Int
    let hasNextPage: Bool
    let hasPreviousPage: Bool
    let previousCursor: String? // handle nulls in case none
    let nextCursor: String?
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
    let meta: Metadata
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
        Button("test exercise by advanced filtering") {
            Task {
                do {
                    let fetched_exercises = try await service_advanced_getExercises(searchTerm: "press", muscleGroup: "delts", bodyGroup: "shoulders", equipment: ["dumbbell"])
                    for exercise in fetched_exercises {
                        print(exercise.name)
                    }
                } catch {
                    print("Error fetching exercises: \(error)")
                }
            }
        }
    }
}

// fetches all muscle groups
func service_allMuscles() async throws -> [Muscle] {
    let url = URL(string: "https://oss.exercisedb.dev/api/v1/muscles")!
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

// fetch all exercises by muscleGroup
func service_getExercises_muscle(muscleGroup: String) async throws -> [Exercise] {
    let baseURL = "https://oss.exercisedb.dev/api/v1/exercises/muscles"
    guard var components = URLComponents(string: baseURL) else {
        throw URLError(.badURL)
    }
    
    // repeatdely make urls for page after page
    func makeURL(after: String?) -> URL? {
        components.queryItems = [
            URLQueryItem(name: "limit", value: "25"),
            // query parameter, the filters added
            URLQueryItem(name: "targetMuscles", value: muscleGroup.isEmpty ? nil : muscleGroup),
            URLQueryItem(name: "after", value: after ?? ""),
            URLQueryItem(name: "before", value: "")
        ]
        return components.url
    }

    guard var url = makeURL(after: nil) else {
        throw URLError(.badURL)
    }

    // initial response
    var allExercises : [Exercise] = []
    do {
        // some responses can return multiple pages of data
        // Will iterate through each page until page is NULL fetching evry exercise
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
            guard exercisesData.success else {
                break
            }
            
            allExercises.append(contentsOf: exercisesData.data)
            if exercisesData.meta.hasNextPage {
                // get to next page
                if let nextPath = exercisesData.meta.nextCursor {
                    guard let nextURL = makeURL(after: nextPath) else { break }
                    url = nextURL
                    // Small delay to avoid rate limiting
                    try await Task.sleep(nanoseconds: 100_000_000)
                } else {
                    break
                }
            }
            else{
                // empty return
                return allExercises
            }
        }
        return allExercises
    } catch {
        print("Decoding error:", error)
        return []
    }
}


// advanced filtering search
func service_advanced_getExercises(searchTerm: String, muscleGroup: String, bodyGroup: String,
                                   equipment: Array<String>) async throws -> [Exercise] {
    let baseURL = "https://oss.exercisedb.dev/api/v1/exercises"
    guard var components = URLComponents(string: baseURL) else {
        throw URLError(.badURL)
    }
    let equipmentValue = equipment.isEmpty ? nil : equipment.joined(separator: ",")
    // repeatdely make urls for page after page
    func makeURL(after: String?) -> URL? {
        components.queryItems = [
            URLQueryItem(name: "limit", value: "25"),
            // query parameter, the filters added
            URLQueryItem(name: "name", value: searchTerm.isEmpty ? nil : searchTerm),
            URLQueryItem(name: "targetMuscles", value: muscleGroup.isEmpty ? nil : muscleGroup),
            URLQueryItem(name: "bodyParts", value: bodyGroup.isEmpty ? nil : bodyGroup),
            URLQueryItem(name: "equipments", value: equipmentValue),
            URLQueryItem(name: "after", value: ""),
            URLQueryItem(name: "before", value: "")
        ]
        return components.url
    }

    guard var url = makeURL(after: nil) else {
        throw URLError(.badURL)
    }
    
    // initial response
    var allExercises : [Exercise] = []
    do {
        // some responses can return multiple pages of data
        // Will iterate through each page until page is NULL fetching evry exercise
        var pgCount = 0
        let maxPage = 2
        while true{
            if pgCount > maxPage {
                break
            }
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
            guard exercisesData.success else {
                break
            }

            allExercises.append(contentsOf: exercisesData.data)

            if exercisesData.meta.hasNextPage {
                pgCount += 1
                // get to next page
                if let nextPath = exercisesData.meta.nextCursor {
                    let httpsPath = nextPath.replacingOccurrences(of: "http://", with: "https://") // force https cause for some reason API changes it
                    guard let nextURL = makeURL(after: nextPath) else { break }
                    url = nextURL
                    // Small delay to avoid rate limiting
                    try await Task.sleep(nanoseconds: 500_000_000)
                } else {
                    break
                }
            }
            else{
                return allExercises
            }
        }
        return allExercises
    } catch {
        print("Decoding error:", error)
        return []
    }
}

#Preview {
    exerciseView()
}
