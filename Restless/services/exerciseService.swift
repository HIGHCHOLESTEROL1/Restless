//
//  exerciseService.swift
//  Restless
//
//  Created by Brian Wang-chen on 11/7/25.
//

import Foundation
import SwiftUI

struct exerciseView: View {
    var body: some View {
        Button("test api") {
            exerciseService()
        }
    }
}


func exerciseService() {
    // creates the mutable url request
    let request = NSMutableURLRequest(
        url: NSURL(string: "https://www.exercisedb.dev/api/v1/muscles")! as URL,
        cachePolicy: .useProtocolCachePolicy,
        timeoutInterval: 10.0
    )
    // set http method and create network sess
    request.httpMethod = "GET"
    let session = URLSession.shared
    
    // create task
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        
        if (error != nil) {
            print(error as Any)
        } else {
            let httpResponse = response as? HTTPURLResponse
            print(httpResponse)
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
