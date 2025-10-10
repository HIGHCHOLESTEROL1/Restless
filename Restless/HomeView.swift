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
            VStack (alignment: .leading) {
                Text("Welcome, Brian!")
                    .font(.title)
                    .fontWeight(.bold)
                
                // button to start a untemplated workout
                Button(action: startWorkout)
                {
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

                // templates to display
                Text("Your Templates")
                    .font(.title2)
                    .fontWeight(.bold)
            }
        }
    }
}
#Preview {
    HomeView()
}
