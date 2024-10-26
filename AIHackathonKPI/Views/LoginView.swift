//
//  ContentView.swift
//  AIHackathon
//
//  Created by Masroor Elahi on 26/10/2024.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel

    init() {
        // Injecting NetworkManager into LoginViewModel
        _viewModel = StateObject(wrappedValue: LoginViewModel(networkManager: NetworkManager()))
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle)
                .padding(.bottom, 40)
            
            TextField("Username", text: $viewModel.username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.top)
            }
            
            Button("Login") {
                Task {
                    await viewModel.login()
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            if viewModel.isAuthenticated {
                Text("Login Successful!")
                    .foregroundColor(.green)
                    .padding(.top)
            }
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
