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
    @Published var showPassword: Bool = false
    @Published var keepLogged: Bool = false
    @Published var auth = false
}

func login() {}

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                Spacer()
                Text("Sign in")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("create an account").font(.callout)
                // login field
                Form {
                    Section("Username") { // username
                        TextField("Email", text: $viewModel.email)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                    }
                    Section("Password"){ // password section
                        HStack {
                            // trigger for showing typed password
                            if viewModel.showPassword {
                                TextField("Password", text: $viewModel.password)
                                    .textContentType(.password)
                                    .privacySensitive()
                            }
                            else {
                                SecureField("Password", text: $viewModel.password)
                                    .textContentType(.password)
                                    .privacySensitive()
                            }
                            Toggle("Show", isOn: $viewModel.showPassword).toggleStyle(.button)
                        }
                    }
                    HStack {
                        Toggle("Remember me", isOn: $viewModel.keepLogged)
                            .font(.callout)
                            .toggleStyle(.button)
                        Spacer()
                        Text("Forgot Password")
                            .font(.callout)
                    }
                }
                .scrollDisabled(true)
                .cornerRadius(20)
                .padding()
                Spacer()
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: login) {
                    Text("Login")
                        .foregroundStyle(Color.white.gradient)
                        .fontWeight(.bold)
                        .frame(minWidth: 300)
                }
                .cornerRadius(10)
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

#Preview {
    LoginView()
}
