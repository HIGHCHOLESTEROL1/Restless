//
//  RestlessApp.swift
//  Restless
//
//  Created by Brian Wang-chen on 9/23/25.
//

import SwiftUI

@main
struct RestlessApp: App {
    @StateObject private var authManager = AuthManager.shared

    var body: some Scene {
        WindowGroup {
            StarterView()
                .environmentObject(authManager)
        }
    }
}
