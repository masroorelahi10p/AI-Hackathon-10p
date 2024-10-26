//
//  LoginViewModel.swift
//  AIHackathon
//
//  Created by Masroor Elahi on 26/10/2024.
//

import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    @Published var username = "eve.holt@reqres.in"
    @Published var password = "cityslicka"
    @Published var isAuthenticated = false
    @Published var errorMessage: String?

    private let networkManager: NetworkManaging

    // Dependency Injection
    init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }

    func login() async {
        let user = User(email: username, password: password)
        
        do {
            let body = try JSONEncoder().encode(user)
            let response: LoginResponse = try await networkManager.performRequest(
                urlString: "https://reqres.in/api/login",
                method: "POST",
                body: body
            )
            isAuthenticated = response.token.isEmpty == false
            if response.token.isEmpty {
                errorMessage = "Invalid username or password"
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
