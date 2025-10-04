//
//  HomeView.swift
//  Restless
//
//  Created by Brian Wang-chen on 9/26/25.
//

import SwiftUI


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
            Text("Start Workout")
                .font(.title2)
                .fontWeight(.bold)
        }
    }
}

#Preview {
    HomeView()
}
