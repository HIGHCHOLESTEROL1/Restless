//
//  authManager.swift
//  Restless
//
//  Created by Brian Wang-chen on 4/21/26.
//

import Foundation
import Supabase

class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
    let client = SupabaseClient(
        supabaseURL: SupabaseConfig.url,
        supabaseKey: SupabaseConfig.publishableKey
    )
    
    func signInWithApple(idToken: String, nonce: String) async throws{
        let session = try await client.auth.signInWithIdToken(credentials: .init(provider: .apple, idToken: idToken, nonce: nonce))
    }
}
