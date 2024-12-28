//
//  RepasView.swift
//  ZakFit_Swiftui
//
//  Created by Apprenant 178 on 08/12/2024.
//

import SwiftUI

struct RepasView: View {
    @StateObject private var viewModel = AlimentViewModel()
    @State private var isShowingAddAliment = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    
                    
                    ForEach(viewModel.aliments) { aliment in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(aliment.nom)
                                    .font(.headline)
                                Text("Calories pour 100g : \(aliment.qteCalorie) kcal")
                                    .font(.subheadline)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                    Text("Tu as \(viewModel.calculerTotalCalories()) Aliments enregistrées")
                        .font(.headline)
                        .padding()
                        .foregroundStyle(.orange)
                        
                }
                .padding()
            }
            .sheet(isPresented: $isShowingAddAliment) {
                AjouterAlimentView()
            }
            .navigationBarItems(trailing: Button(action: {
                // Action pour afficher le formulaire
                isShowingAddAliment = true
            }) {
                VStack {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(Color.orange)
                    Text("Ajouter")
                        .font(.headline)
                        .foregroundColor(Color.orange)
                }
                
                
            })
            
            .navigationTitle("Liste des Aliments")
            .onAppear {
                viewModel.fetchAliments()
                
            }
        }
        
        
    }
}

#Preview {
    RepasView()
}
