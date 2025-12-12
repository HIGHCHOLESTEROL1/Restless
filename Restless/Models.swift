//
//  Models.swift
//  Restless
//
//  Created by Brian Wang-chen on 9/30/25.
//

import SwiftUI

// default fonts
extension Font {
    static let Title = Font.system(.title, design: .serif)
    static let Title2 = Font.system(.title2, design: .serif)
    static let Default = Font.system(size: 14, design: .serif)
}

// default starter background
let backgroundGradient = LinearGradient(
    colors: [Color.blue, Color.accent, Color.purple],
    startPoint: .top, endPoint: .bottom
    )

// default home background (dark)
let homeBackgroundGradient = LinearGradient(
    colors: [Color.gray, Color.black],
    startPoint: .top, endPoint: .bottom
    )

// default home background (light)
let lightHomeBackgroundGradient = LinearGradient(
    colors: [Color.gray, Color.white],
    startPoint: .top, endPoint: .bottom
    )

// default spacing
enum Spacing {
    static let s: CGFloat = 16
    static let m: CGFloat = 20
    static let l: CGFloat = 50
    static let xl: CGFloat = 100
}

// classes for muscle groups
struct Muscle: Codable {
    let name: String
}
struct MuscleGroups: Codable {
    let data: [Muscle]
}

// class for exercises
struct Exercise: Codable {
    let exerciseID: String
    let name: String
    let gifUrl: URL
    let targetMuscles: Array<String>
    let bodyParts: Array<String>
    let equipments: Array<String>
    let secondaryMuscles: Array<String>
    let instructions: Array<String>
}
struct Exercises: Codable {
    let data: [Exercise]
}

// class for a food
struct Food {
    let name: String
    let calories: Float
    let servingSize_g: Float
    let num_fat_g: Float
    let num_sat_fat_g: Float
    let num_protein_g: Float
    let num_sodium_mg: Float
    let num_potassium_mg: Float
    let num_cholestrol_mg: Float
    let num_carbs_g: Float
    let num_fiber_g: Float
    let num_sugar_g: Float
}

struct template {
    let numExercise: Int
    let exercises: Array<Exercise>
}
