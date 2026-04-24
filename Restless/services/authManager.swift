//
//  authManager.swift
//  Restless
//
//  Created by Brian Wang-chen on 4/21/26.
//

import Foundation
import Supabase

@MainActor
final class AuthManager: ObservableObject {
    static let shared = AuthManager()

    @Published private(set) var session: Session?
    @Published private(set) var isRestoringSession = true

    let client: SupabaseClient
    private var authStateTask: Task<Void, Never>?

    private init(client: SupabaseClient = supabase) {
        self.client = client
        session = client.auth.currentSession

        authStateTask = Task { [weak self] in
            await self?.observeAuthState()
        }

        Task { [weak self] in
            await self?.restoreSession()
        }
    }

    var isAuthenticated: Bool {
        session != nil
    }

    var currentUserEmail: String? {
        session?.user.email
    }

    func restoreSession() async {
        defer { isRestoringSession = false }

        do {
            session = try await client.auth.session
        } catch {
            session = client.auth.currentSession
        }
    }

    func signIn(email: String, password: String) async throws {
        session = try await client.auth.signIn(email: email, password: password)
    }

    @discardableResult
    func signUp(email: String, password: String) async throws -> Bool {
        let response = try await client.auth.signUp(email: email, password: password)
        session = response.session
        return response.session != nil
    }

    func signOut() async throws {
        try await client.auth.signOut()
        session = nil
    }

    func signInWithApple(idToken: String, nonce: String) async throws {
        session = try await client.auth.signInWithIdToken(
            credentials: .init(provider: .apple, idToken: idToken, nonce: nonce)
        )
    }

    private func observeAuthState() async {
        for await (_, session) in client.auth.authStateChanges {
            self.session = session

            if isRestoringSession {
                isRestoringSession = false
            }
        }
    }
}
