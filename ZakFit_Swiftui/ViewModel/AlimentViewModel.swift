//
//  AlimentViewModel.swift
//  ZakFit_Swiftui
//
//  Created by Apprenant 178 on 08/12/2024.
//


import Foundation

class AlimentViewModel: ObservableObject {
    @Published var aliments: [Aliment] = [] // Liste des aliments à afficher
    
    func fetchAliments() {
        guard let url = URL(string: "http://127.0.0.1:8080/aliment") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }
            
            do {
                let aliments = try JSONDecoder().decode([Aliment].self, from: data)
                DispatchQueue.main.async {
                    self.aliments = aliments
                }
            } catch {
                print("Erreur de décodage JSON : \(error.localizedDescription)")
            }
        }.resume()
    }
    
    
}
