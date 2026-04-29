//
//  Templates.swift
//  Restless
//
//  Created by Brian Wang-chen on 10/17/25.
//

import SwiftUI

// default templated workouts 2 per
let columns = [
    GridItem(.flexible()),
    GridItem(.flexible())
]

struct WorkoutTemplateData: Identifiable {
    let id = UUID()
    let title: String
    let exercises: [String]
}

let beginnerWorkoutTemplates: [WorkoutTemplateData] = [
    WorkoutTemplateData(
        title: "Push Day",
        exercises: [
            "Barbell Bench Press",
            "Incline Dumbbell Press",
            "Seated Shoulder Press",
            "Cable Chest Fly",
            "Lateral Raise",
            "Tricep Pushdown",
            "Overhead Tricep Extension"
        ]
    ),
    WorkoutTemplateData(
        title: "Pull Day",
        exercises: [
            "Lat Pulldown",
            "Seated Cable Row",
            "Chest Supported Row",
            "Single Arm Dumbbell Row",
            "Face Pull",
            "EZ Bar Curl",
            "Hammer Curl"
        ]
    ),
    WorkoutTemplateData(
        title: "Leg Day",
        exercises: [
            "Barbell Back Squat",
            "Romanian Deadlift",
            "Leg Press",
            "Walking Lunges",
            "Leg Extension",
            "Hamstring Curl",
            "Standing Calf Raise"
        ]
    )
]

// default struct for each template, name, exercises, etc
struct Template: View {
    let title: String
    let numExercises: Int
    var onTap: (() -> Void)?
    
    var body: some View {
        HStack {
            // templated name
            VStack(alignment: .leading) {
                Text(title.uppercased())
                    .font(.Default)
                    .fontWeight(.bold)
                Text("\(numExercises) exercises")
                    .font(.Default)
            }
            Spacer()
            // play circle icon
            Image(systemName: "play.fill")
                .padding(5)
                .background(Color.blue)
                .foregroundStyle(Color.white.gradient)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        // add opacity to each template square so distinguishable from background
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(1))
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2))
        
        // functionality when user clicks on to a template
        .onTapGesture {
            onTap?()
        }
    }
}

struct TemplateView: View {
    var onBeginnerWorkoutSelected: ((WorkoutTemplateData) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            VStack(alignment: .leading, spacing: Spacing.s) {
                // lazyVGrid, supports dynamic data, live updates from FireBase
                Text("Beginner Workout")
                    .font(.Title2)
                    .fontWeight(.bold)
                // non custom templates (standard 3 that will always exist)
                LazyVGrid(columns: columns) {
                    ForEach(beginnerWorkoutTemplates) { template in
                        Template(title: template.title, numExercises: template.exercises.count) {
                            onBeginnerWorkoutSelected?(template)
                        }
                    }
                } .frame(maxWidth: .infinity)
                
                Text("Your Templates")
                    .font(.Title2)
                    .fontWeight(.bold)
                // non custom templates
                LazyVGrid(columns: columns) {
                    // temporary for now just for UI design
                    Template(title: "Upper Day", numExercises: 7)
                    Template(title: "Lower Day", numExercises: 7)
                    Template(title: "Cardio Day", numExercises: 7)
                    Template(title: "U chest focused", numExercises: 7)
                    Template(title: "U back focused", numExercises: 7)
                    Template(title: "Arms & shoulders", numExercises: 7)
                    Template(title: "Chest Bi", numExercises: 7)
                    Template(title: "Back tri", numExercises: 7)
                } .frame(maxWidth: .infinity)
            } .padding()
        } .padding()
    }
}

#Preview {
    TemplateView()
}
