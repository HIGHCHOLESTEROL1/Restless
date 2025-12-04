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
        Button("test all muscles") {
            service_allMuscles()
        }
        Button("test exercise by muscle group") {
            service_getExercise_byMuscle(muscleGroup: "upper back")
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
func service_allMuscles() {
    // creates the mutable url request
    let components = URLComponents(string: "https://www.exercisedb.dev/api/v1/muscles")
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
        } else {
            let httpResponse = response as? HTTPURLResponse
        }
        if let data = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
            } catch {
                print("JSON parsing error:", error)
            }
        }
    })
    dataTask.resume()
}

// fetches all exercises related to a chosen muscle groups
func service_getExercise_byMuscle(muscleGroup: String) {
    // handle spacing for more complex muscle groups
    let baseURL = "https://www.exercisedb.dev/api/v1/muscles/"
    guard let encodedGroup = muscleGroup.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
        let url = URL(string: baseURL + encodedGroup + "/exercises") else {
        print("Invalid URL")
        return
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
      } else {
        let httpResponse = response as? HTTPURLResponse
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
        } else {
            let httpResponse = response as? HTTPURLResponse
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
        } else {
            let httpResponse = response as? HTTPURLResponse
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
