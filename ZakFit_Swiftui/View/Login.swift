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
    @State private var showError = false // Indicateur pour afficher une alerte
    @State private var errorMessage = "" // Message d'erreur à afficher

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
                            // Navigation activée automatiquement via isLoggedIn
                        } else {
                            errorMessage = "Identifiants invalides. Veuillez réessayer."
                            showError = true
                        }
                    }
                }) {
                    Text("Log In")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
                .alert(isPresented: $showError) {
                    Alert(
                        title: Text("Erreur"),
                        message: Text(errorMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .navigationDestination(isPresented: $viewModel.isLoggedIn) {
                    if let token = viewModel.token {
                        RepasView(viewModel: RepasViewModel(token: token)) // Utilise le token dynamique
                            .navigationBarBackButtonHidden(true)
                    } else {
                        Text("Erreur : Token non disponible")
                            .foregroundColor(.red)
                    }
                }
                
                .padding(.top, 20)
                .padding(.bottom, 40)
                
                NavigationLink(destination: RegisterView()) {
                    Text("Créer un compte")
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                }
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
