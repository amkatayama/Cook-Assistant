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
    
    // if email address already exists user cannot create password
    
    // creating necessary variables
    @State var username = ""
    @State var email = ""
    @State var areacode = ""
    @State var phone = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State var errorMessage = ""
    @State var signuppage = false
    @State var authenticationSucceed: Bool = false
    @State var enableSMS: Bool = false
    @State var navigate: Bool = false
    
    @State var msg = ""
    
    // check if all the fields contain the correct information
    // show different errors messages for different errors
    func validateFields() -> String? {
        
        // check if all the fields are filled
        if self.username.count == 0 || self.email.count == 0 || self.password.count == 0 || self.confirmPassword.count == 0 {
            
            self.errorMessage = "Please fill in all fields"
            return "error"

        }
        // check if the password is secure
        if isPasswordSecure(self.password) == false {
            
            // show error message
            self.errorMessage = "Please make sure you password includes at least one uppercase, one lowercase, one numeric digit and is more than 8 characters."
            return "error"
        }
        
        // check if the password and confirmed password match
        if self.confirmPassword != self.password {
            
            self.errorMessage = "Please make sure that your passwords match."
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
    
    func checkRegisterInfo() {
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
            
            // create the user accordingly to the registerd information
            Auth.auth().createUser(withEmail: self.email, password: self.password) { (result, err) in
                // if an email already exists return error
                if err != nil {
                    // error found in creating user
                    self.errorMessage = "The email address is currently in use. Please enter a new email address or try logging in."
                }
            }
        }
    }
    
//    func verifyPhone() {
//        PhoneAuthProvider.provider().verifyPhoneNumber("+"+self.areacode+self.phone, uiDelegate: nil) {(ID, err) in
//
//            if err != nil {
//                self.msg = (err?.localizedDescription)!
//                return
//            }
//        }
//    }
    
    @Environment(\.colorScheme) var colorScheme  // handling light and dark schemes
        
    var body: some View {
        NavigationView {
            VStack (spacing: 30) {
                Spacer()
                
                // Creating a title for the page
//                Text(colorScheme == .dark ? "Create Account":"Create Account")
                Text("Create Account")
                    .frame(width: UIScreen.main.bounds.width * 0.9)  // scaled size for different screen size
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundColor(.yellow)
                    .cornerRadius(8)
                    .padding(.bottom, 20)
                
                // Text field for username
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.gray)
                    TextField("Username", text: self.$username)
                }
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .padding(.all, 10)
                .background(Color.white)
                .cornerRadius(8)
                .border(.yellow)
                .padding(.horizontal, 20)
                .autocapitalization(.none)  // diasble autocapitalization
                .disableAutocorrection(true)  // disable autoconversion
                
                // Text field for email address
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.gray)
                    TextField("Email address", text: self.$email)
                }
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .padding(.all, 10)
                .background(Color.white)
                .cornerRadius(8)
                .border(.yellow)
                .padding(.horizontal, 20)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                
                HStack {
                    Image(systemName: "phone")
                        .foregroundColor(.gray)
                    
                    TextField("+1", text: self.$areacode)
                        .keyboardType(.numberPad)  // number pad by default
                        .frame(width: 30)
                    
                    TextField("Phone Number (Optional)", text: self.$phone)
                        .keyboardType(.numberPad)
                }
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .padding(.all, 10)
                .background(Color.white)
                .cornerRadius(8)
                .border(.yellow)
                .padding(.horizontal, 20)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                
                // Text field for email address
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                    SecureField("Password", text: self.$password)
                    
                }
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .padding(.all, 10)
                .background(Color.white)
                .cornerRadius(8)
                .border(.yellow)
                .padding(.horizontal, 20)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                
                // Text field for the user to re-enter the password for confirmation
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                    SecureField("Re-enter your password", text: self.$confirmPassword)
                }
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .padding(.all, 10)
                .background(Color.white)
                .cornerRadius(8)
                .border(.yellow)
                .padding(.horizontal, 20)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                
                // create navigation link which only works when authenticationSucceed = true
                NavigationLink(destination: LoginView(), isActive: .constant(self.enableSMS == true)) {
                    Text("Create Account")
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .medium))
                }
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .padding(.all, 10)
                .background(Color.yellow)
                .cornerRadius(8)
                .padding(.all, 20)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                // call function at the same time the button is tapped
                .simultaneousGesture(TapGesture().onEnded{
                    checkRegisterInfo()
//                    if enableSMS == true {
//                       verifyPhone()
//                    }
                })
                // permission to send confirmaiton notification with SMS
                .alert(isPresented: self.$authenticationSucceed) {
                    Alert(
                        title: Text("Allow SMS notification"),
                        message: Text("Enter your email address to receive password reset link."),
                        primaryButton: .default(Text("Yes")) {
                            self.enableSMS = true
                        },
                        secondaryButton: .cancel()
                    )}
                
                
                if self.authenticationSucceed == false{
                    // showing different error messages for different errors
                    Text(self.errorMessage)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 20, weight: .semibold))
                        .background(Color.red.opacity(0.8))
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
        LoginView()
        SignupView()
    }
}

