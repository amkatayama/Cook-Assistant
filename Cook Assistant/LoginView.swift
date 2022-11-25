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
    @State var emailForReset = ""
    @State var password = ""
    @State var authenticationSucceed: Int = 0  // neither true or false
    @State var pwdReset: Bool = false
    @State var resetError: Bool = false
    
    // enables to remove unnecessary navigation links 
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    
    func verifyLogin(em: String, pwd: String) {
        // if both fields are empty
        if self.email == "" && self.password == "" {
            self.authenticationSucceed = 2
        } else {
            // Checking the firebase if the entered login information matches the registered
            Auth.auth().signIn(withEmail: self.email, password: self.password) {(result, error) in
                
                // no error detected on firebase side
                if error == nil {
                    self.authenticationSucceed = 1  // true
                } else {
                    self.authenticationSucceed = 2  // false
                }
            }
        }
        
    }
    
    func passwordReset() {
        if self.emailForReset != "" {
            Auth.auth().sendPasswordReset(withEmail: self.emailForReset) { (err) in
                if err != nil {
                    self.resetError = true
                }
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
                    TextField("Email address", text: self.$email)
                }
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .padding(.all, 20)
                .background(Color.white)
                .cornerRadius(8)
                .border(Color.yellow)
                .autocapitalization(.none)  // disable autocapitalization
                
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                    SecureField("Password", text: self.$password)
                }
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .padding(.all, 20)
                .background(Color.white)
                .cornerRadius(8)
                .border(Color.yellow)
                .autocapitalization(.none)
                
                Button("Forgot password") {
                    self.pwdReset = true
                }
                .padding(.bottom, 30)
                .foregroundColor(.yellow)
                .font(.system(size: 20, weight: .semibold))
                .frame(width: UIScreen.main.bounds.width * 0.8, alignment: .trailing)

                .alert("Password Reset", isPresented: self.$pwdReset, actions: {
                    TextField("Email Address", text: self.$emailForReset)
                    
                    Button("Send Link!", action: {
                        passwordReset()
                        self.emailForReset = ""  // refresh text field
                    })
         
                    Button("Cancel", role: .cancel, action: {})
                }, message: {
                    Text("Enter your email address to receive password reset link.")
                })
            
                // only navigates to ContentView if both email and password are entered correctly
                NavigationLink(destination:  ContentView(), isActive: .constant(self.authenticationSucceed == 1)) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .semibold))
                        .padding(.vertical, 10)
                        .background(Color.yellow.opacity(0.8))
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                        .onTapGesture {   // check login info once login button is tapped
                            verifyLogin(em: self.email, pwd: self.password)
                        }
                }
                
                
                if self.authenticationSucceed == 2 {
                    Text("Wrong email address or password. \n Please try again.")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 20, weight: .semibold))
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .padding(.top, 30)
                    
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
                        .frame(width: UIScreen.main.bounds.width * 0.8)
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .semibold))
                        .padding(.vertical, 10)
                        .background(Color.yellow.opacity(0.8))
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                    }
                    
            }
            // removing "back" navigations on LoginView
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
//        SignupView()

    }
}
