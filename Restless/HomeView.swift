//
//  HomeView.swift
//  Restless
//
//  Created by Brian Wang-chen on 9/26/25.
//

import SwiftUI

// action to start workout
func startWorkout(){
    print("start workout pressed") // testing purposes
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
struct HomeView: View{
    var body: some View {
        ZStack{ // layered z-axis UI
            homeBackgroundGradient
                .ignoresSafeArea()
            VStack{
                Image("StartMedia")
                lightHomeBackgroundGradient
                    .ignoresSafeArea()
            }
            VStack (alignment: .leading, spacing: 20) {
                Text("Welcome, Brian!")
                    .font(.title)
                    .fontWeight(.bold)
                
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
                // templates
                HStack(spacing: 50) {
                    Text("Your Templates")
                        .font(.title2)
                        .fontWeight(.bold)
                    // add templates button
                    HStack() {
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
        }
    }
}
#Preview {
    HomeView()
}
