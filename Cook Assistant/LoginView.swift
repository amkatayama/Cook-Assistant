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
    
    @State var usr_eml = ""
    @State var usr_pwd = ""
    @State var authenticationSucceed: Bool = false
//    @State var isNavigationBarHidden: Bool = true
//    @State var loginButtonTapped: Bool = false

    
    func verifyLogin(email: String, password: String) {
        // Checking the firebase if the entered login information matches the registered
        Auth.auth().signIn(withEmail: email, password: password) {(result, error) in

            // no error detected on firebase side
            if error == nil {
                self.authenticationSucceed = true
            } else {
                self.authenticationSucceed = false
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
                    TextField("Email address", text: $usr_eml)
                }
                .padding(.all, 20)
                .background(Color.white)
                .cornerRadius(8)
                .padding(.horizontal, 20)
                
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                    SecureField("Password", text: $usr_pwd)
                }
                .padding(.all, 20)
                .background(Color.white)
                .cornerRadius(8)
                .padding(.horizontal, 20)
                
                HStack {
                    Text("Forgot your password?")
                    NavigationLink(destination: ContentView()) {
                        Text(" Click Here")
                    }
                }
                
                Spacer()
                
                // only navigates to ContentView if both email and password are entered correctly
                NavigationLink(destination: ContentView(), isActive: .constant(self.authenticationSucceed == true)) {
                    Text("Login")
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .medium))
                }
                .padding(.all, 10)
                .background(Color.blue.opacity(0.8))
                .cornerRadius(8)
                .onTapGesture {   // check login info once login button is tapped
                    verifyLogin(email: usr_eml, password: usr_pwd)
                    if self.authenticationSucceed == false {
                        Text("Wrong email address or password. \n Please try again.")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 20, weight: .semibold))
                            .background(Color.red.opacity(0.8))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .padding(.all, 30)

                        // reset textfield to null
                        self.usr_eml = ""
                        self.usr_pwd = ""
                    }
                }
                
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
