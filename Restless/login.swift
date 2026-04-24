//
//  login.swift
//  Restless
//
//  Created by Brian Wang-chen on 3/27/26.
//
import SwiftUI
import Supabase

class LoginViewModel: ObservableObject {
    @Published var showPassword: Bool = false
    @Published var keepLogged: Bool = false
}

// func to ensure valid email
func isValidEmail(_ email: String) -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return predicate.evaluate(with: email)
}

// func to ensure valid password format
func isValidPassword(_ password: String) -> Bool {
    // Minimum 8 characters, at least one uppercase letter, one number and one special character
    let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&#])[A-Za-z\\d$@$!%*?&#]{8,}"
    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
}


struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()
    @State var email: String = ""
    @State var password: String = ""
    @State var auth: Result<Void, Error>?
    @State var isLoading = false
    
    // valid email
    var isEmailValid: Bool { isValidEmail(email) }
    var isPasswordValid: Bool { isValidPassword(password) }
    
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
                        TextField("Email", text: $email)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .foregroundStyle(isEmailValid ? .primary: Color.red)
                    }
                    Section("Password"){ // password section
                        HStack {
                            // trigger for showing typed password
                            if viewModel.showPassword {
                                TextField("Password", text: $password)
                                    .textContentType(.password)
                                    .privacySensitive()
                                    .foregroundStyle(isPasswordValid ? .primary: Color.red)
                            }
                            else {
                                SecureField("Password", text: $password)
                                    .textContentType(.password)
                                    .privacySensitive()
                                    .foregroundStyle(isPasswordValid ? .primary: Color.red)
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
                .disabled(!isEmailValid || !isPasswordValid)
                
                if isLoading {
                    ProgressView()
                }
            }
        }
    }
    // when user attempts login with credentials
    func login() {
        Task {
            isLoading = true
        }
    }
}

#Preview {
    LoginView()
}
