//
//  MainTabView.swift
//  ZakFit_Swiftui
//
//  Created by Apprenant 178 on 05/01/2025.
//

import SwiftUI

struct MainTabView: View {
    let token: String  // Le token est nécessaire pour passer aux sous vues
    
    var body: some View {
        TabView {
            VStack {
                
                HStack {
                        Image(systemName: "figure.walk.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.orange)
                        Text("Bienvenue sur...")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundColor(.orange)
                }.padding(.top , 170)
                
                Image("zakfitimg")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding()
                
                
                Text("Commence ton suivi sportif dès aujourd'hui")
                        .font(.headline)
                        .foregroundColor(.gray)
                Spacer()
                
             
            }
            .tabItem {
                Label("Accueil", systemImage: "house")
            }

            RepasView(viewModel: RepasViewModel(token: token))
                .tabItem {
                    Label("Repas", systemImage: "takeoutbag.and.cup.and.straw.fill")
                }

            AlimentView(token: token)
                .tabItem {
                    Label("Aliments", systemImage: "carrot.fill")
                    
                }
        }
        .accentColor(.orange)
        .navigationBarBackButtonHidden(true)  // Empêche le bouton retour pour rester sur la TabView
    }
}

#Preview {
    MainTabView(token: "token test")
}
