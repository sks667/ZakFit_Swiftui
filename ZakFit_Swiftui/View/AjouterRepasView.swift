//
//  AjouterRepasView.swift
//  ZakFit_Swiftui
//
//  Created par Apprenant 178 le 03/01/2025.
//

import SwiftUI

/**
 `AjouterRepasView` est une vue qui permet à l'utilisateur d'ajouter un repas en sélectionnant :
 - Un type de repas (Petit-déjeuner, Déjeuner, Dîner, etc.).
 - Une date et une heure.
 - Une liste d'aliments avec la quantité sélectionnée.
 
 Cette vue utilise :
 - Un **`RepasViewModel`** pour gérer l'ajout du repas.
 - Un **`AlimentViewModel`** pour récupérer les aliments disponibles.
 */
struct AjouterRepasView: View {
    
    @ObservedObject var viewModel: RepasViewModel
    @ObservedObject var alimentViewModel: AlimentViewModel
    @State private var selectedAliments: [AlimentContenu] = []
    @State private var typeRepas: String = ""
    @State private var dateRepas: Date = Date()
    @Environment(\.dismiss) var dismiss

    /**
     Corps de la vue contenant le formulaire pour ajouter un repas.
     */
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    // Section pour les informations générales du repas
                    RepasInfoSection(typeRepas: $typeRepas, dateRepas: $dateRepas)
                    
                    // Section pour sélectionner les aliments
                    AlimentSelectionSection(alimentViewModel: alimentViewModel, selectedAliments: $selectedAliments)
                    
                    // Section affichant les aliments déjà sélectionnés
                    AlimentsChoisisSection(selectedAliments: selectedAliments)
                }

                // Bouton pour valider l'ajout du repas
                Button(action: {
                    if typeRepas.isEmpty || selectedAliments.isEmpty {
                        print("Veuillez remplir tous les champs.")
                        return
                    }
                    viewModel.addRepas(typeRepas: typeRepas, dateRepas: dateRepas, alimentsSelectionnes: selectedAliments)
                    dismiss()  // Fermer la vue après l'ajout
                }) {
                    Text("Ajouter le Repas")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
            }
            .navigationTitle("Ajouter un Repas")
            .onAppear {
                alimentViewModel.fetchAliments()  // Récupération des aliments
            }
        }
    }
}

/// Section pour entrer les informations du repas (type et date)
struct RepasInfoSection: View {
    @Binding var typeRepas: String
    @Binding var dateRepas: Date

    /**
     Affiche des champs pour saisir :
     - Le type de repas (via un `TextField`).
     - La date et l'heure (via un `DatePicker`).
     */
    var body: some View {
        Section(header: Text("Informations du Repas")) {
            TextField("Nom du Repas", text: $typeRepas)
                .padding(5)
                .background(Color(.systemGray6))
                .cornerRadius(8)

            DatePicker("Date et Heure", selection: $dateRepas, displayedComponents: [.date, .hourAndMinute])
        }
    }
}

/// Section pour afficher la liste des aliments disponibles
struct AlimentSelectionSection: View {
    @ObservedObject var alimentViewModel: AlimentViewModel
    @Binding var selectedAliments: [AlimentContenu]

    /**
     Affiche la liste des aliments récupérés par `alimentViewModel`.
     
     L'utilisateur peut choisir la quantité d'un aliment avec un `Stepper` et cliquer sur le bouton "+" pour l'ajouter à la liste.
     */
    var body: some View {
        Section(header: Text("Sélectionner des Aliments")) {
            ForEach(alimentViewModel.aliments) { aliment in
                AlimentRow(aliment: aliment, selectedAliments: $selectedAliments)
            }
        }
    }
}

/// Section pour afficher chaque aliment avec la possibilité d'ajouter une quantité
struct AlimentRow: View {
    var aliment: Aliment
    @Binding var selectedAliments: [AlimentContenu]
    @State private var quantite: Int = 0  // Quantité sélectionnée

    /**
     Affiche une ligne avec le nom de l'aliment, un `Stepper` pour ajuster la quantité et un bouton "+" pour l'ajouter.
     
     - Si la quantité est 0, le bouton "+" ne fait rien.
     */
    var body: some View {
        HStack {
            Text(aliment.nom)
            Spacer()
            Stepper("Quantité: \(quantite) g", value: $quantite, in: 0...1000)

            Button(action: {
                guard quantite > 0 else { return }  // Ne pas ajouter si la quantité est 0
                if let index = selectedAliments.firstIndex(where: { $0.alimentID == aliment.id }) {
                    selectedAliments[index].quantite += quantite  // Ajouter à la quantité existante
                } else {
                    let alimentChoisi = AlimentContenu(
                        id: UUID(),
                        alimentID: aliment.id,
                        nom: aliment.nom,
                        quantite: quantite,
                        calorie: aliment.qteCalorie
                    )
                    selectedAliments.append(alimentChoisi)  // Ajouter un nouvel aliment à la liste
                }
                quantite = 0  // Réinitialiser la quantité après ajout
            }) {
                Image(systemName: "plus.circle")
                    .foregroundColor(.orange)
            }
        }
    }
}

/// Section pour afficher les aliments sélectionnés
struct AlimentsChoisisSection: View {
    let selectedAliments: [AlimentContenu]

    /**
     Affiche la liste des aliments sélectionnés avec leurs quantités.
     
     - Si la liste est vide : Affiche un message "Aucun aliment sélectionné".
     - Sinon : Affiche le nom et la quantité pour chaque aliment.
     */
    var body: some View {
        Section(header: Text("Aliments Sélectionnés")) {
            if selectedAliments.isEmpty {
                Text("Aucun aliment sélectionné")
                    .foregroundColor(.gray)
            } else {
                ForEach(selectedAliments) { aliment in
                    HStack {
                        Text("\(aliment.nom ?? "Inconnu")")
                        Spacer()
                        Text("\(aliment.quantite) g")
                    }
                }
            }
        }
    }
}
