//
//  RepasView.swift
//  ZakFit_Swiftui
//
//  Created by Apprenant 178 on 03/01/2025.
//

import SwiftUI

struct RepasView: View {
    @StateObject var viewModel: RepasViewModel

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        if viewModel.repasList.isEmpty {
                            VStack {
                                Text("Aucun repas enregistré")
                                    .foregroundColor(.gray)
                                    .italic()
                                    .padding()
                            }
                        } else {
                            ForEach(viewModel.repasList) { repas in
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "fork.knife")
                                            .foregroundColor(.blue)
                                        Text("\(repas.typeRepas)")
                                            .font(.title2)
                                            .bold()
                                    }
                                    Text("Date : \(repas.dateRepas.formatted())")
                                        .foregroundColor(.gray)
                                    Text("Calories : \(Int(repas.calorieTotal)) kcal")
                                        .foregroundColor(repas.calorieTotal > 500 ? .red : .green)
                                        .bold()
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .shadow(radius: 3)
                                .padding(.horizontal)
                            }
                        }
                    }
                }

                NavigationLink(destination: AjouterRepasView(viewModel: viewModel, alimentViewModel: viewModel.alimentViewModel)) {
                    Image(systemName: "plus")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .padding()
                }
            }
            .navigationTitle("Mes Repas")
            .toolbar {
                Button(action: {
                    viewModel.fetchRepas()  // Bouton de rafraîchissement
                }) {
                    Image(systemName: "arrow.clockwise.circle")
                        .font(.title2)
                }
            }
            .onAppear {
                viewModel.fetchRepas()
            }
        }
    }
}

