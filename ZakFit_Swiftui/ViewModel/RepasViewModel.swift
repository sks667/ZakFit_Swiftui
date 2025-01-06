//
//  RepasViewModel.swift
//  ZakFit_Swiftui
//
//  Created by Apprenant 178 on 03/01/2025.
//

import Foundation

/**
 `RepasViewModel` est un ViewModel qui gère la récupération, l'ajout et l'affichage des repas pris par l'utilisateur connecté.

 ### Fonctionnalités principales :
 - Récupérer la liste des repas depuis le serveur (`fetchRepas()`).
 - Ajouter un nouveau repas avec des aliments sélectionnés (`addRepas()`).
 - Mettre à jour l'affichage des repas via la propriété `repasList`.

 Ce ViewModel utilise un `token` JWT pour sécuriser les requêtes HTTP.
 */
class RepasViewModel: ObservableObject {
    
    /// Liste des repas récupérés depuis l'API.
    @Published var repasList: [RepasModel] = []
    
    /// Liste des aliments sélectionnables pour composer un repas.
    @Published var aliments: [AlimentContenu] = []
    
    /// URL de base pour les requêtes concernant les repas.
    private let baseURL = "http://127.0.0.1:8080/repas"
    
    /// Token d'authentification JWT utilisé pour sécuriser les requêtes.
    private let token: String
    
    /// Instance de `AlimentViewModel` pour accéder aux aliments liés aux repas.
    var alimentViewModel: AlimentViewModel
    
    /**
     Initialise le `RepasViewModel` avec un token d'authentification.
     
     - Parameter token: Le token JWT utilisé pour authentifier l'utilisateur.
     */
    init(token: String) {
        self.token = token
        self.alimentViewModel = AlimentViewModel(token: token)
    }
    
    /**
     ## `fetchRepas()`
     
     Récupère la liste des repas pour l'utilisateur connecté.
     
     Cette fonction effectue une requête `GET` vers l'API pour récupérer tous les repas de l'utilisateur.
     - Si la requête réussit, la liste des repas est mise à jour.
     - Si une erreur réseau ou une erreur de décodage JSON survient, un message est affiché dans la console.
     
     - Important : Les données sont affichées avec un format de date ISO 8601 pour correspondre à l'API.
     */
    func fetchRepas() {
        guard let url = URL(string: baseURL) else {
            print("URL invalide")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // Ajout du token dans l'en-tête

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
                    self.repasList = repasList // Mise à jour de la liste des repas
                }
                print("Repas récupérés : \(repasList)")
            } catch {
                print("Erreur de décodage JSON : \(error.localizedDescription)")
                print("Données JSON brutes : \(String(data: data, encoding: .utf8) ?? "Aucune donnée")")
            }
        }.resume()
    }
    
    /**
     ## `addRepas(typeRepas:dateRepas:alimentsSelectionnes:)`
     
     Ajoute un nouveau repas pour l'utilisateur connecté.
     
     Cette fonction envoie une requête `POST` pour créer un nouveau repas avec les informations suivantes :
     - Type de repas (par exemple "Dîner").
     - Date du repas.
     - Liste des aliments sélectionnés avec leur quantité.
     
     - Parameters:
        - typeRepas: Le type de repas (exemple : "Petit-déjeuner", "Dîner").
        - dateRepas: La date du repas.
        - alimentsSelectionnes: Liste des `AlimentContenu` sélectionnés avec la quantité consommée.
     
     - Note : Une fois le repas ajouté, la fonction `fetchRepas()` est appelée pour rafraîchir la liste.
     */
    func addRepas(typeRepas: String, dateRepas: Date, alimentsSelectionnes: [AlimentContenu]) {
        guard let url = URL(string: "\(baseURL)") else {
            print("URL invalide")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Construction du corps de la requête JSON
        let body: [String: Any] = [
            "calorieTotal": 0,  // Le backend calcule automatiquement les calories
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
                self.fetchRepas()  // Rafraîchit la liste après l'ajout du repas
            }

            print("Repas ajouté avec succès")
        }.resume()
    }
}

