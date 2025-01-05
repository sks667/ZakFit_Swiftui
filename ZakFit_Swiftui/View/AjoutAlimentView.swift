//
//  AjoutAlimentView.swift
//  ZakFit_Swiftui
//
//  Created by Apprenant 178 on 16/12/2024.
//

import SwiftUI

struct AjouterAlimentView: View {
    @ObservedObject var viewModel: AlimentViewModel
    @Environment(\.dismiss) var dismiss
    @State private var nom = ""
    @State private var calories = ""
    @State private var lipides = ""
    @State private var glucides = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informations de l'aliment")) {
                    TextField("Nom de l'aliment", text: $nom)
                    TextField("Calories pour 100g", text: $calories)
                        .keyboardType(.numberPad)
                    TextField("Glucides pour 100g", text: $glucides)
                        .keyboardType(.numberPad)
                    TextField("Lipides pour 100g", text: $lipides)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Ajouter un Aliment")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                    .foregroundColor(.orange)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter") {
                        guard !nom.isEmpty,
                              let calories = Int(calories),
                              let glucides = Int(glucides),
                              let lipides = Int(lipides) else {
                            print("Les valeurs des champs ne sont pas valides")
                            return
                        }
                        viewModel.ajouterAliment(nom: nom, calories: calories, glucides: glucides, lipides: lipides)
                        dismiss()
                    }
                    .foregroundColor(.orange)
                }
            }
        }
    }
}

#Preview {
    let exampleViewModel = AlimentViewModel(token: "fake-token") 
    AjouterAlimentView(viewModel: exampleViewModel)
}
