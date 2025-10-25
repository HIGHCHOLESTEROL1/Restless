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
    static let Default = Font.system(size: 17, design: .serif)
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
    colors: [Color.white, Color.gray],
    startPoint: .top, endPoint: .bottom
    )

// default spacing
enum Spacing {
    static let s: CGFloat = 16
    static let m: CGFloat = 20
    static let l: CGFloat = 50
    static let xl: CGFloat = 100
}
