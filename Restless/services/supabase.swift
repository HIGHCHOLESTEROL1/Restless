//
//  supabase.swift
//  Restless
//
//  Created by Brian Wang-chen on 4/14/26.
//

import Foundation
import Supabase
import SwiftUI

enum SupabaseConfig {
    static let url = URL(string: "https://waqnnkktexqfxpalctbw.supabase.co")!
    static let publishableKey = "sb_publishable_oQZ1rvjhts0YifAQpH6PQw_ZcJj-5dv"
}

let supabase = SupabaseClient(
    supabaseURL: SupabaseConfig.url,
    supabaseKey: SupabaseConfig.publishableKey
)

// test supabase connection, random test data
struct TestUser: Identifiable, Decodable {
    let id: Int
    let createdWhen: Date
    let email: String
    let username: String

    private enum CodingKeys: String, CodingKey {
        case id
        case createdWhen = "created_when"
        case email
        case username
    }
}

enum SupabaseService {
    // Keep the test query limited to non-sensitive columns so the app never
    // normalizes reading password-style fields into client code.
    static func fetchTestUsers() async throws -> [TestUser] {
        try await supabase
            .from("TEST")
            .select("id, created_when, email, username")
            .execute()
            .value
    }
}

// temporary view to test data pull
struct SupabaseTestView: View {
    @State private var users: [TestUser] = []
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            List(users) { user in
                VStack(alignment: .leading) {
                    Text(user.username)
                    Text(user.email).font(.caption).foregroundStyle(.secondary)
                }
            }
            .overlay {
                if let errorMessage {
                    Text(errorMessage)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            .task {
                do {
                    users = try await SupabaseService.fetchTestUsers()
                    print("Fetched users:", users.count)
                } catch {
                    errorMessage = String(describing: error)
                    print("Supabase error:", error)
                }
            }
        }
    }
}

#Preview {
    SupabaseTestView()
}
