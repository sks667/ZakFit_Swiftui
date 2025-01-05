//
//  AjouterRepasView.swift
//

import SwiftUI

struct AjouterRepasView: View {
    @ObservedObject var viewModel: RepasViewModel
    @ObservedObject var alimentViewModel: AlimentViewModel
    @State private var selectedAliments: [AlimentContenu] = []  // Liste d'aliments choisis
    @State private var typeRepas: String = ""
    @State private var dateRepas: Date = Date()
    @Environment(\.dismiss) var dismiss  // Pour fermer la vue après ajout

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    RepasInfoSection(typeRepas: $typeRepas, dateRepas: $dateRepas)
                    AlimentSelectionSection(alimentViewModel: alimentViewModel, selectedAliments: $selectedAliments)
                    AlimentsChoisisSection(selectedAliments: selectedAliments)
                }

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
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
            }
            .navigationTitle("Ajouter un Repas")
            .onAppear {
                alimentViewModel.fetchAliments()
            }
        }
    }
}

struct RepasInfoSection: View {
    @Binding var typeRepas: String
    @Binding var dateRepas: Date

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

struct AlimentSelectionSection: View {
    @ObservedObject var alimentViewModel: AlimentViewModel
    @Binding var selectedAliments: [AlimentContenu]

    var body: some View {
        Section(header: Text("Sélectionner des Aliments")) {
            ForEach(alimentViewModel.aliments) { aliment in
                AlimentRow(aliment: aliment, selectedAliments: $selectedAliments)
            }
        }
    }
}

struct AlimentRow: View {
    var aliment: Aliment
    @Binding var selectedAliments: [AlimentContenu]
    @State private var quantite: Int = 0  // Quantité sélectionnée pour cet aliment

    var body: some View {
        HStack {
            Text(aliment.nom)
            Spacer()
            Stepper("Quantité: \(quantite) g", value: $quantite, in: 0...1000)

            Button(action: {
                guard quantite > 0 else { return }  // N'ajoute pas si la quantité est 0
                if let index = selectedAliments.firstIndex(where: { $0.alimentID == aliment.id }) {
                    selectedAliments[index].quantite += quantite
                } else {
                    let alimentChoisi = AlimentContenu(
                        id: UUID(),
                        alimentID: aliment.id,
                        nom: aliment.nom,
                        quantite: quantite,
                        calorie: aliment.qteCalorie
                    )
                    selectedAliments.append(alimentChoisi)
                }
                quantite = 0  // Réinitialiser après ajout
            }) {
                Image(systemName: "plus.circle")
                    .foregroundColor(.blue)
            }
        }
    }
}

struct AlimentsChoisisSection: View {
    let selectedAliments: [AlimentContenu]

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
