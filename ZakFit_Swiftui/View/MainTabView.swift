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
            // **Accueil**
            VStack {
                Text("Bienvenue sur ZakFit 🎯")
                    .font(.largeTitle)
                    .padding()

                Text("Sélectionne un onglet pour commencer")
                    .foregroundColor(.gray)
            }
            .tabItem {
                Label("Accueil", systemImage: "house")
            }

            // **RepasView**
            RepasView(viewModel: RepasViewModel(token: token))
                .tabItem {
                    Label("Repas", systemImage: "fork.knife")
                }

            // **AlimentView**
            AlimentView(token: token)
                .tabItem {
                    Label("Aliments", systemImage: "leaf")
                }
        }
        .navigationBarBackButtonHidden(true)  // Empêche le bouton retour pour rester sur la TabView
    }
}

#Preview {
    MainTabView(token: "fake-token")
}
