//
//  Untitled.swift
//  ZakFit_Swiftui
//
//  Created by Apprenant 178 on 09/12/2024.
//
import Foundation
import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel = UserViewModel()
    @State private var email: String = ""
    @State private var mdp: String = ""

    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $mdp)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                Button(action: {
                    viewModel.login(email: email, mdp: mdp) { success in
                        if success {
                            viewModel.isLoggedIn = true
                        } else {
                            print("Identifiants invalides")
                        }
                    }
                }) {
                    Text("Log In")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .navigationDestination(isPresented: $viewModel.isLoggedIn) {
                    ContentView()
                        .navigationBarBackButtonHidden(true)
                }
                
                
                .padding(.top, 20)
            }
            .padding()
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
