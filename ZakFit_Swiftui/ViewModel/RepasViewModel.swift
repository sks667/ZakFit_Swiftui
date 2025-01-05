//
//  RepasViewModel.swift
//  ZakFit_Swiftui
//
//  Created by Apprenant 178 on 03/01/2025.
//
import Foundation

class RepasViewModel: ObservableObject {
    @Published var repasList: [RepasModel] = [] // Liste des repas affichés
    @Published var aliments: [AlimentContenu] = []

    private let baseURL = "http://127.0.0.1:8080/repas"
    private let token: String
    var alimentViewModel: AlimentViewModel // Ajout de la variable

    init(token: String) {
        self.token = token
        self.alimentViewModel = AlimentViewModel(token: token) // Instanciation de AlimentViewModel
    }

    func fetchRepas() {
        guard let url = URL(string: baseURL) else {
            print("URL invalide")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erreur réseau : \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Réponse HTTP invalide : \(String(describing: response))")
                return
            }

            guard let data = data else {
                print("Données manquantes")
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let repasList = try decoder.decode([RepasModel].self, from: data)
                DispatchQueue.main.async {
                    self.repasList = repasList
                }
                print("Repas récupérés : \(repasList)")
            } catch {
                print("Erreur de décodage JSON : \(error.localizedDescription)")
                print("Données JSON brutes : \(String(data: data, encoding: .utf8) ?? "Aucune donnée")")
            }
        }.resume()
    }
    func addRepas(typeRepas: String, dateRepas: Date, alimentsSelectionnes: [AlimentContenu]) {
        guard let url = URL(string: "http://127.0.0.1:8080/repas") else {
            print("URL invalide")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "calorieTotal": 0,  // Le backend le calcule automatiquement
            "typeRepas": typeRepas,
            "dateRepas": ISO8601DateFormatter().string(from: dateRepas),
            "aliments": alimentsSelectionnes.map { ["alimentID": $0.alimentID.uuidString, "quantite": $0.quantite] }
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Erreur lors de la création du body JSON : \(error.localizedDescription)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erreur réseau : \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Réponse HTTP invalide")
                return
            }

            DispatchQueue.main.async {
                self.fetchRepas()  // Rafraîchir la liste après l'ajout du repas
            }

            print("Repas ajouté avec succès")
        }.resume()
    }
}

