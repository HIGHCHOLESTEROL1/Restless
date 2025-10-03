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
                Image("StartMedia")// by icons8
                Text("Restless") // title
                    .font(.title)
                    .bold(true)
                    .foregroundStyle(Color.white.gradient)
            }
        }
    }
}

// initial starting screen (3 secs)
struct StarterView: View{
    @State var starterFinished: Bool = false // starter state
    var body: some View {
        Group{
            if starterFinished {
                HomeView().transition(.move(edge: .trailing))
            } else {
                StartView().transition(.move(edge: .leading))
            }
        }
        // once starter state has been displayed, toggle to true
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                // animation
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                    starterFinished.toggle()
                }
            }
        }
    }
}

#Preview {
    StarterView()
}
