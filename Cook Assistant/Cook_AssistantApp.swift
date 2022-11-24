//
//  Cook_AssistantApp.swift
//  Cook Assistant
//
//  Created by Arata Michael Katayama on 2022/11/23.
//

import SwiftUI
import Firebase

@main
struct Cook_AssistantApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
