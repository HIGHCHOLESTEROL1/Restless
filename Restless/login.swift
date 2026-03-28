//
//  login.swift
//  Restless
//
//  Created by Brian Wang-chen on 3/27/26.
//
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showField: Bool = false
    @Published var keepLogged: Bool = false
}

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("Sign in")
                .font(.Title)
                .fontWeight(.bold)
            Text("create an account")
            // login field
            Form {
                Section("Username") { // username
                    TextField("Email", text: $viewModel.email)
                }
                Section("Password"){ // password section
                    HStack {
                        // trigger for showing typed password
                        if !viewModel.showField {
                            TextField("Password", text: $viewModel.password)
                        }
                        else {
                            SecureField("Password", text: $viewModel.password)
                        }
                        Toggle("Show", isOn: $viewModel.showField).toggleStyle(.button)
                    }
                    }
                
                Toggle("Keep me logged in", isOn: $viewModel.keepLogged)
                        .toggleStyle(.switch)
                // login button
                Button("login") { }
            }
            .scrollDisabled(true)
            .padding()
            Spacer()
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
