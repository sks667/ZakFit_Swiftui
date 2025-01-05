
//
//  AlimentView.swift
//  ZakFit_Swiftui
//
//  Created by Apprenant 178 on 08/12/2024.
//

import SwiftUI

struct AlimentView: View {
    @StateObject private var viewModel: AlimentViewModel
    @State private var isShowingAddAliment = false

    init(token: String) {
        _viewModel = StateObject(wrappedValue: AlimentViewModel(token: token)) // Initialisation avec le token
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    if viewModel.aliments.isEmpty {
                        Text("Aucun aliment trouvé")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        
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
                        
                        Text("Total des aliments enregistrés : \(viewModel.alimentsCount)")
                            .font(.title3)
                            .bold()
                            .padding()
                            .foregroundColor(.orange)

                        

                    }
                }
                .padding()
            }
            .sheet(isPresented: $isShowingAddAliment) {
                AjouterAlimentView(viewModel: viewModel) // Passer le ViewModel pour synchronisation
            }
            .navigationBarItems(trailing: Button(action: {
                isShowingAddAliment = true
            }) {
                VStack {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(.orange)
                    Text("Ajouter")
                        .font(.headline)
                        .foregroundColor(.orange)
                }
            })
            .navigationTitle("Liste des Aliments")
            .onAppear {
                viewModel.fetchAliments()  // Récupère la liste complète des aliments
                viewModel.fetchAlimentsCount()  // Récupère le nombre total d'aliments depuis le backend
            }
        }
    }
}

#Preview {
    AlimentView(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJDQUZDRTRENy1CN0FELTQyRTItOUZBRS01MTUwOTIwQTI1OTgiLCJleHBpcmF0aW9uIjoxNzM2MDQ0NjQ0Ljk0MzE2MzksImV4cGlyYXRpb25UaW1lIjo2MDB9.cG_Wb-wTrlJIFHsRwMj6HMjG-DwFvkCb2RTlhujF0Vo")
}
