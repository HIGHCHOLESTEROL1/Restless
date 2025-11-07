//
//  ApiNinjaService.swift
//  Restless
//
//  Created by Brian Wang-chen on 10/31/25.
//
// handles the API calls for API Ninja: Exercise, Nutrition info

import Foundation

// grab env variables, api keys
func envGrab(key: String) -> String? {
    if let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
       let dict = NSDictionary(contentsOfFile: path),
       let value = dict[key] as? String {
        return value
    }
    return nil
}

// pull exercise info
func NinjaService_exercises(muscleGroup: String, completion: @escaping (String?) -> Void) {
    // construct URL properly
    guard let url = URL(string: "https://api.api-ninjas.com/v1/exercises?muscle=" + muscleGroup) else {
        completion(nil)
        return
    }
    guard let apiKey = envGrab(key: "NINJA_API_KEY") else {
        print("API key missing")
        completion(nil)
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Request error: \(error.localizedDescription)")
            completion(nil)
            return
        }

        guard let data = data else {
            print("No data returned")
            completion(nil)
            return
        }

        // Convert to string for debugging
        let result = String(data: data, encoding: .utf8)
        completion(result)
    }

    task.resume()
}
