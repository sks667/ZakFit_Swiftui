//
//  RepasView.swift
//  ZakFit_Swiftui
//
//  Created by Apprenant 178 on 08/12/2024.
//

import SwiftUI

import SwiftUI

struct RepasView: View {
    @StateObject private var viewModel = AlimentViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.aliments) { aliment in
                HStack {
                    VStack(alignment: .leading) {
                        Text(aliment.nom)
                            .font(.headline)
                        Text("Calories pour 100g : \(aliment.qteCalorie) kcal")
                            .font(.subheadline)
                    }
                    Spacer()
                    Button(action: {
                        // Ajouter cet aliment au repas
                        print("\(aliment.nom) ajouté au repas !")
                    }) {}
                }
            }
            .navigationTitle("Liste des Aliments")
            .onAppear {
                viewModel.fetchAliments() // Récupérer les aliments dès que la vue apparaît
            }
        }
    }
}

#Preview {
    RepasView()
}
