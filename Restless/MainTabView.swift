//
//  MainTabView.swift
//  Restless
//
//  Created by Brian Wang-chen on 12/4/25.
//
import SwiftUI

// tabular view struct for navigation
struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            ExercisePage()
                .tabItem {
                    Label("Exercises", systemImage: "dumbbell")
                }
            HistoryPage()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
        }
    }
}
