//
//  MainTabView.swift
//  ZakFit_Swiftui
//
//  Created by Apprenant 178 on 05/01/2025.
//

import SwiftUI

struct MainTabView: View {
    let token: String  // Le token est nécessaire pour passer aux sous-vues
    
    var body: some View {
        TabView {
            VStack {
                Text("Bienvenue sur ZakFit 🎯")
                    .font(.largeTitle)
                    .padding()

             
            }
            .tabItem {
                Label("Accueil", systemImage: "house")
            }

            RepasView(viewModel: RepasViewModel(token: token))
                .tabItem {
                    Label("Repas", systemImage: "fork.knife")
                }

            AlimentView(token: token)
                .tabItem {
                    Label("Aliments", systemImage: "leaf")
                    
                }
        }
        .accentColor(.orange)
        .navigationBarBackButtonHidden(true)  // Empêche le bouton retour pour rester sur la TabView
    }
}

#Preview {
    MainTabView(token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHBpcmF0aW9uVGltZSI6NjAwLCJ1c2VySWQiOiJDQUZDRTRENy1CN0FELTQyRTItOUZBRS01MTUwOTIwQTI1OTgiLCJleHBpcmF0aW9uIjoxNzM2MDQ2NTY4LjU0MDg4M30.CijfUlqiMDkYrrVCcypmfdTlHtHEtpkCM6eSb0WnrrM")
}
