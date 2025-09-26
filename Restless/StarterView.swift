//
//  ContentView.swift
//  Restless
//
//  Created by Brian Wang-chen on 9/23/25.
//

import SwiftUI

let backgroundGradient = LinearGradient(
    colors: [Color.blue, Color.purple],
    startPoint: .top, endPoint: .bottom
    )

// initial starting screen (3 secs)
struct StarterView: View{
    var body: some View {
        ZStack{ // layered z-axis UI
            backgroundGradient
                .ignoresSafeArea()
            VStack{
                Image("StartMedia")// by icons8
                Text("Restless")
                    .font(.title)
                    .bold(true)
                    .foregroundStyle(Color.white.gradient)
            }
        }
    }
}

#Preview {
    StarterView()
}
