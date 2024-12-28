//
//  AjoutAlimentView.swift
//  ZakFit_Swiftui
//
//  Created by Apprenant 178 on 16/12/2024.
//

import SwiftUI

        struct AjouterAlimentView: View {
            @Environment(\.dismiss) var dismiss
            @State private var nom = ""
            @State private var calories = ""
            
            var body: some View {
                NavigationView {
                    Form {
                        Section(header: Text("Informations de l'aliment")) {
                            TextField("Nom de l'aliment", text: $nom)
                            TextField("Calories pour 100g", text: $calories)
                                .keyboardType(.numberPad)
                        }
                    }
                    .navigationTitle("Ajouter un Aliment")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Annuler") {
                                dismiss()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Ajouter") {
                                print("Aliment ajouté : \(nom) - \(calories) kcal")
                                dismiss()
                            }
                        }
                    }
                }
            }
        }

#Preview {
    AjouterAlimentView()
}
