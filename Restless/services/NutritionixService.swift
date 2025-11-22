//
//  NutritionixService.swift
//  Restless
//
//  Created by Brian Wang-chen on 11/4/25.
//

import Foundation

// pull nutritional info
func NutrionixService_nutrition() {
    // guards for grabbign env variables
    guard let apiKey = envGrab(key: "NUTRITIONIX_API_KEY") else {
        print("Nutritionix API key not found")
        return
    }
    guard let id = envGrab(key: "NUTRITIONIX_AP_ID") else {
        print("Nutritionix ID not found")
        return
    }
    
    let url = URL("https://platform.fatsecret.com/rest/foods/search/v1")
}
