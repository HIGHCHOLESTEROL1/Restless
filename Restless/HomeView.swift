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
            // Initial section containing welcome mssg
            VStack (spacing: Spacing.m) {
                Text("Welcome, Brian!")
                    .font(.Title)
                    .fontWeight(.bold)
                // second section containing start workout button and template buttons
                VStack(spacing: Spacing.l) {
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
                    // templates section
                    VStack(alignment: .leading, spacing: Spacing.m) {
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
                }
                // templates
                TemplateView()
            }
        }
    }
}
#Preview {
    HomeView()
}
