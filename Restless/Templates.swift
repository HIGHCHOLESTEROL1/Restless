//
//  Templates.swift
//  Restless
//
//  Created by Brian Wang-chen on 10/17/25.
//

import SwiftUI

// default templated workouts
let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
]

// default struct for each template, name, exercises, etc
struct Template: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.Default)
    }
}

struct TemplateView: View {
    var body: some View {
        // lazyVGrid, supports dynamic data, live updates from FireBase
        Text("Beginner Workout")
            .font(.Default)
            .fontWeight(.bold)
        // non custom templates (standard 3 that will always exist)
        LazyVGrid(columns: columns) {
            // temporary for now just for UI design
            Template(title: "Push Day")
            Template(title: "Pull Day")
            Template(title: "Leg Day")
        } .padding()
        Text("Your Templates")
            .font(.Default)
            .fontWeight(.bold)
        // non custom templates
        LazyVGrid(columns: columns) {
            // temporary for now just for UI design
            Template(title: "Upper Day")
            Template(title: "Lower Day")
            Template(title: "Arms & Shoulders")
            Template(title: "Upper Back Focused")
            Template(title: "Cardio Day")
        } .padding()
    }
}

#Preview {
    TemplateView()
}
