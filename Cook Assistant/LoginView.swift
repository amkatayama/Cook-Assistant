//
//  LoginView.swift
//  Cook Assistant
//
//  Created by Arata Michael Katayama on 2022/11/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    
    @State var email = ""
    @State var password = ""
    @State var authenticationSucceed: Int = 0  // neither true or false
//    @State var isNavigationBarHidden: Bool = true
//    @State var loginButtonTapped: Bool = false

    
    func verifyLogin(em: String, pwd: String) {
        // if both fields are empty
        if self.email == "" && self.password == "" {
            self.authenticationSucceed = 2
        }
        // Checking the firebase if the entered login information matches the registered
        Auth.auth().signIn(withEmail: email, password: password) {(result, error) in

            // no error detected on firebase side
            if error == nil {
                self.authenticationSucceed = 1  // true
            } else {
                self.authenticationSucceed = 2  // false
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                
                Spacer()
                
                Text("Welcome")
                    .font(.system(size: 64, weight: .semibold))
                    .foregroundColor(.yellow)
                
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.gray)
                    TextField("Email address", text: $email)
                }
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .padding(.all, 20)
                .background(Color.white)
                .cornerRadius(8)
                .padding(.horizontal, 20)
                
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                    SecureField("Password", text: $password)
                }
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .padding(.all, 20)
                .background(Color.white)
                .cornerRadius(8)
                .padding(.horizontal, 20)
                
                Spacer()
                
                // only navigates to ContentView if both email and password are entered correctly
                NavigationLink(destination: ContentView(), isActive: .constant(self.authenticationSucceed == 1)) {
                    Text("Login")
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .medium))
                }
                .padding(.all, 10)
                .background(Color.blue.opacity(0.8))
                .cornerRadius(8)
                .onTapGesture {   // check login info once login button is tapped
                    verifyLogin(em: self.email, pwd: self.password)
                }
                
                if self.authenticationSucceed == 2 {
                    Text("Wrong email address or password. \n Please try again.")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 20, weight: .semibold))
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .padding(.top, 30)
                    
                    HStack {
                        Text("Forgot your password?")
                        NavigationLink(destination: ContentView()) {
                            Text(" Click Here")
                        }
                    }
                    
                    // reset textfield to null
//                    self.email = ""
//                    self.password = ""
                }
//
                    // Text inidicating that the create account button is only for first time users
                    Text("For first time users")
                        .padding(.top, 130)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.black)
                    
                    // Create account button
                    NavigationLink(destination: SignupView()) {
                        Text("Create Account")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .font(.system(size: 24, weight: .semibold))
                            .padding(.vertical, 10)
                            .background(Color.yellow.opacity(0.8))
                            .cornerRadius(8)
                            .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                    
            }
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
        SignupView()
    }
}
