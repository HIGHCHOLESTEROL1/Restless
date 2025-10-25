//
//  Templates.swift
//  Restless
//
//  Created by Brian Wang-chen on 10/17/25.
//

import SwiftUI

// default templated workouts 3 per
let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
]

// default struct for each template, name, exercises, etc
struct Template: View {
    let title: String
    
    var body: some View {
        Text(title.uppercased())
            .font(.Default)
            .fontWeight(.bold)
        Image(systemName: "play.fill")
            .background(Color.blue)
            .foregroundStyle(Color.white.gradient)
            .padding()
            .clipShape(Circle())
    }
}

struct TemplateView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            VStack(alignment: .leading, spacing: Spacing.s) {
                // lazyVGrid, supports dynamic data, live updates from FireBase
                Text("Beginner Workout")
                    .font(.Title2)
                    .fontWeight(.bold)
                // non custom templates (standard 3 that will always exist)
                LazyVGrid(columns: columns) {
                    // temporary for now just for UI design
                    Template(title: "Push Day")
                    Template(title: "Pull Day")
                    Template(title: "Leg Day")
                } .frame(maxWidth: .infinity)
            } .padding()
            
            VStack(alignment: .leading, spacing: Spacing.s) {
                Text("Your Templates")
                    .font(.Title2)
                    .fontWeight(.bold)
                // non custom templates
                ScrollView() {
                    LazyVGrid(columns: columns) {
                        // temporary for now just for UI design
                        Template(title: "Upper Day")
                        Template(title: "Lower Day")
                        Template(title: "Cardio Day")
                        Template(title: "U chest focused")
                        Template(title: "U back focused")
                        Template(title: "Arms & shoulders")
                        Template(title: "Chest Bi")
                        Template(title: "Back tri")
                    } .frame(maxWidth: .infinity)
                }
            } .padding()
        }
    }
}

#Preview {
    TemplateView()
}
