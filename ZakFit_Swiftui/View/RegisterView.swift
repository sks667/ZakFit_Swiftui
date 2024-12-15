//
//  ContentView.swift
//  ZakFit_Swiftui
//
//  Created by Apprenant 178 on 08/12/2024.
//

import SwiftUI

struct RegisterView: View {
    @State private var nom: String = ""
    @State private var prenom: String = ""
    @State private var taille: String = ""
    @State private var poids: String = ""
    @State private var email: String = ""
    @State private var motDePasse: String = ""
    @State private var preferencesAlimentaires: String = ""
    
    @ObservedObject var viewModel = UserViewModel()

    var body: some View {
        
        NavigationStack {
            VStack(spacing: 20) {
                Text("Inscription")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                HStack{
                    TextField("Nom", text: $nom)
                        .padding()
                        .cornerRadius(100)
                    
                    TextField("Prénom", text: $prenom)
                        .padding()
                        .cornerRadius(100)
                }
                
                HStack{
                    TextField("Taille (en cm)", text: $taille)
                        .keyboardType(.numberPad)
                        .padding()
                        .cornerRadius(10)
                    
                    TextField("Poids (en kg)", text: $poids)
                        .keyboardType(.numberPad)
                        .padding()
                        .cornerRadius(10)
                }
                
                TextField("Préférences Alimentaires", text: $preferencesAlimentaires)
                    .padding()
                    .cornerRadius(10)
                    .padding(.bottom, 35)
                
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .padding()
                    .cornerRadius(10)

                SecureField("Mot de passe", text: $motDePasse)
                    .padding()
                    .cornerRadius(10)

            

                // Bouton d'inscription
                Button(action: {
                    guard let tailleInt = Int(taille), let poidsInt = Int(poids) else {
                        print("Taille ou poids invalide.")
                        return
                    }
                    viewModel.register(
                        nom: nom,
                        prenom: prenom,
                        taille: tailleInt,
                        poids: poidsInt,
                        email: email,
                        mdp: motDePasse,
                        preferenceAlimentaire: preferencesAlimentaires
                    )
                }) {
                    Text("S'inscrire")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)

            }
            .padding()
        }
    }
}
#Preview {
    RegisterView()
}
