//
//  HomeView.swift
//  Restless
//
//  Created by Brian Wang-chen on 9/26/25.
//

import SwiftUI

// action to start workout
func startWorkout(){
    print("start workout pressed") // testing purposeså
    exerciseService()
}

// action to create new workout template
func createNewTemplate(){
    print("create new template button pressed")
}

// action to edit a existent template
func editTemplate(){
    print("edit templates button pressed")
}

// base home view
struct HomeView: View {
    var body: some View {
        ZStack {
            backgroundGradient.ignoresSafeArea()
            Image("AppLogo")
        }
        .frame(maxHeight: Spacing.xl)
        ScrollView {
            VStack (spacing: Spacing.m) {
                Text("Welcome, Brian!")
                    .font(.Title)
                    .fontWeight(.bold)
                // second section containing start workout button and template buttons
                // button to start a untemplated workout
                Button(action: startWorkout) {
                    // decor for the button
                    HStack{
                        Label("START A NEW WORKOUT", systemImage: "play.circle")
                            .foregroundStyle(Color.white.gradient)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.accent)
                            .cornerRadius(10) // rounded corners
                    }
                }
            }
            // template title and template adding/editing section
            VStack (alignment: .leading, spacing: Spacing.m) {
                HStack(spacing: Spacing.xl) {
                    Text("Templates")
                        .font(.Title2)
                        .fontWeight(.bold)
                    // edit template section
                    HStack() {
                        // add templates button
                        Button(action: createNewTemplate) {
                            Image(systemName: "plus")
                                .padding()
                                .fontWeight(.bold)
                                .foregroundStyle(Color.white)
                                .background(Color.gray)
                                .clipShape(Circle())
                        }
                        // edit templates button
                        Button(action: editTemplate) {
                            Image(systemName: "pencil")
                                .padding()
                                .fontWeight(.bold)
                                .foregroundStyle(Color.white)
                                .background(Color.gray)
                                .clipShape(Circle())
                        }
                    }
                }
            }
            // templates
            TemplateView()
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
