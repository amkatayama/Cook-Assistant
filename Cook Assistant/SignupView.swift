//
//  SignupView.swift
//  Cook Assistant
//
//  Created by Arata Michael Katayama on 2022/11/23.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct SignupView: View {
    // creating necessary variables
    @State var username = ""
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State var errorMessage = ""
    @State var signuppage = false
    @State var authenticationSucceed: Bool = false
    @State var navigate: Bool = false
    
    // check if all the fields contain the correct information
    // show different errors messages for different errors
    func validateFields() -> String? {
        
        // check if all the fields are filled
        if self.username.count == 0 || self.email.count == 0 || self.password.count == 0 || self.confirmPassword.count == 0 {
            
            errorMessage = "Please fill in all fields"
            return "error"

        }
        // check if the password is secure
        if isPasswordSecure(self.password) == false {
            
            // show error message
            errorMessage = "Please make sure you password includes at least one uppercase, one lowercase, one numeric digit and is more than 8 characters."
            return "error"
        }
        
        // check if the password and confirmed password match
        if self.confirmPassword != self.password {
            
            errorMessage = "Please make sure that your passwords match."
            return "error"
            
        }
        
        // if no error is detected return nil (default setting of return value)
        return nil
        
    }
    
    // checking if the password is secure enough
    func isPasswordSecure(_ password: String) -> Bool {
        
        // setting a format for the password
        // password should have: at least one uppercase and a lowercase, at leat one number, and 8 characters long
        let passwordFormat = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        
        // return true or false depending on whether password follows the format or not
        return passwordFormat.evaluate(with: password)
    }
    
    func checkLoginInfo() {
        // validate the fields
        let error = validateFields()
        
        // if the return value of validateFields() is "error"
        if error != nil {
            
            // If error in fields show error message
            self.authenticationSucceed = false
            
            // otherwise if nil
        } else {
            
            // show message to show that sign up was successful
            self.authenticationSucceed = true
            
            // store the most recent input from the user
            let usr = self.username
            let eml = self.email
            let pwd = self.password
            
            // create the user accordingly to the registerd information
            Auth.auth().createUser(withEmail: eml, password: pwd) { (result, err) in
                // Check for errors
                if err != nil {
                    // error found in creating user
                    print("Error creating user")
                } else {
                    
                    // user was created successfully
                    // storing database into a constant
                    let db = Firestore.firestore()
                    
                    // find collection called "users" and create a new docuemnt with their user id
                    db.collection("users").addDocument(data: ["username":usr, "uid":result!.user.uid]) { (error) in
                        
                        // check for errors
                        if error != nil {
                            print("Error saving user data")
                        }
                    }
                    
                    // empty the textfields
                    self.username = ""
                    self.email = ""
                    self.password = ""
                    self.confirmPassword = ""
                    
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack (spacing: 30) {
                Spacer()
                
                // Creating a title for the page
                Text("Create Account")
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundColor(.yellow)
                    .background(Color.gray.opacity(0.9))
                    .cornerRadius(8)
                    .padding(.bottom, 20)
                
                // Text field for username
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.gray)
                    TextField("Username", text: $username)
                }
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .padding(.all, 10)
                .background(Color.white)
                .cornerRadius(8)
                .padding(.horizontal, 20)
                
                // Text field for email address
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.gray)
                    TextField("Email address", text: $email)
                }
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .padding(.all, 10)
                .background(Color.white)
                .cornerRadius(8)
                .padding(.horizontal, 20)
                
                // Text field for email address
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                    TextField("Password", text: $password)
                }
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .padding(.all, 10)
                .background(Color.white)
                .cornerRadius(8)
                .padding(.horizontal, 20)
                
                // Text field for the user to re-enter the password for confirmation
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                    SecureField("Re-enter your password", text: $confirmPassword)
                }
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .padding(.all, 10)
                .background(Color.white)
                .cornerRadius(8)
                .padding(.horizontal, 20)
                
                // create navigation link which only works when authenticationSucceed = true
                NavigationLink(destination: ContentView(), isActive: .constant(self.authenticationSucceed == true)) {
                    Text("Create Account")
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .medium))
                }
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .padding(.all, 10)
                .background(Color.blue.opacity(0.8))
                .cornerRadius(8)
                .padding(.all, 20)
                // call function at the same time the button is tapped
                .simultaneousGesture(TapGesture().onEnded{
                    checkLoginInfo()
                    // if all information is valid
                    
                })
                
                if self.authenticationSucceed == false{
                    // showing different error messages for different errors
                    Text(errorMessage)
                        .background(Color.red.opacity(0.6))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .padding(.top, 30)
                }
                
                Spacer()
                
            }
        }
    }
    
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}

