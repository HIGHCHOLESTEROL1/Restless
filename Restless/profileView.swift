//
//  profileView.swift
//  Restless
//
//  Created by Brian Wang-chen on 4/24/26.
//

// base home view

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var authManager: AuthManager

    private var displayName: String {
        guard let email = authManager.currentUserEmail,
              let localPart = email.split(separator: "@").first,
              !localPart.isEmpty else {
            return "User"
        }

        return String(localPart)
    }

    var body: some View {
        ZStack {
            // for now showcase user username and email
            VStack(spacing: Spacing.m) {
                VStack(spacing: Spacing.s) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 72))
                        .foregroundStyle(.blue)
                    
                    Text("Welcome, \(displayName)")
                        .font(.Title)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)

                    Text(authManager.currentUserEmail ?? "No email available")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, Spacing.m)
            }
        }
        // sign out button
        .toolbar { // sign out button
            ToolbarItem(placement: .bottomBar) {
                Button("Sign Out") {
                    Task {
                        try? await authManager.signOut()
                    }
                }
                .foregroundStyle(Color.white.gradient)
                .fontWeight(.bold)
                .background(Color.blue)
                .cornerRadius(10) // rounded corners
            }
        }
    }
    // redirect back to login page onced logged out
    @ViewBuilder
    private var profileShift: some View {
        if !authManager.isAuthenticated {
            LoginView()
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthManager.shared)
}
