//
//  StarterView.swift
//  Restless
//
//  Created by Brian Wang-chen on 9/23/25.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        // starter view
        ZStack{ // layered z-axis UI
            backgroundGradient
                .ignoresSafeArea()
            VStack{
                Image("AppLogo")
                Text("Restless") // title
                    .font(.Title)
                    .bold(true)
                    .foregroundStyle(Color.white.gradient)
            }
        }
    }
}

// initial starting screen (3 secs)
struct StarterView: View{
    @State var starterFinished: Bool = false // starter state
    @EnvironmentObject private var authManager: AuthManager

    var body: some View {
        Group{
            if starterFinished {
                authContent
                    .transition(.move(edge: .trailing))
            } else {
                StartView().transition(.move(edge: .leading))
            }
        }
        // once starter state has been displayed, toggle to true
        .onAppear {
            Task {
                try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
                    withAnimation(.easeInOut(duration: 0.5)) { // animation
                        starterFinished = true
                }
            }
        }
    }

    @ViewBuilder
    private var authContent: some View {
        if authManager.isRestoringSession {
            ProgressView("Loading account...")
        } else if authManager.isAuthenticated {
            MainTabView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    StarterView().environmentObject(AuthManager.shared)
}
