//
//  AlimentViewModel.swift
//  ZakFit_Swiftui
//
//  Created by Apprenant 178 on 08/12/2024.
//

import Foundation

/// `AlimentViewModel` est un ViewModel pour gérer l'affichage, la récupération et l'ajout d'aliments via des requêtes HTTP.
class AlimentViewModel: ObservableObject {
    
    /// Liste des aliments récupérés depuis l'API.
    @Published var aliments: [Aliment] = []
    
    /// Nombre total d'aliments récupérés.
    @Published var alimentsCount: Int = 0
    
    /// URL de base de l'API.
    private let baseURL = "http://127.0.0.1:8080/aliment"
    
    /// Token d'authentification pour les requêtes sécurisées.
    private let token: String
    
    /**
     Initialise le ViewModel avec un token d'authentification.
     
     - Parameter token: Le token JWT utilisé pour authentifier les requêtes.
     */
    init(token: String) {
        self.token = token
    }
    
    /**
     ## `fetchAliments()`
     
     Récupère la liste des aliments pour l'utilisateur connecté.
     
     Cette fonction effectue une requête `GET` pour obtenir la liste des aliments depuis l'API. La réponse inclut :
     - Les aliments standards accessibles à tous les utilisateurs.
     - Les aliments personnalisés créés par l'utilisateur connecté.
     
     - Note : La liste des aliments est mise à jour dans la variable `aliments` après récupération des données.
     */
    func fetchAliments() {
        guard let url = URL(string: baseURL) else {
            print("URL invalide")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // Ajout du token pour la requête
        
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
                let aliments = try JSONDecoder().decode([Aliment].self, from: data)
                DispatchQueue.main.async {
                    self.aliments = aliments // Mise à jour de la liste des aliments
                }
            } catch {
                print("Erreur de décodage JSON : \(error.localizedDescription)")
            }
        }.resume()
    }
    
    /**
     ## `ajouterAliment(nom:calories:glucides:lipides:)`
     
     Ajoute un nouvel aliment à la base de données pour l'utilisateur connecté.
     
     - Parameters:
        - nom: Le nom de l'aliment (par exemple "Pâtes").
        - calories: La quantité de calories pour 100g.
        - glucides: La quantité de glucides pour 100g.
        - lipides: La quantité de lipides pour 100g.
     
     Cette fonction effectue une requête `POST` pour envoyer l'aliment au serveur et utilise le token d'authentification pour la sécurité.
     
     - Important : Après l'ajout réussi, la liste des aliments est mise à jour grâce à un nouvel appel à `fetchAliments()`.
     */
    func ajouterAliment(nom: String, calories: Int, glucides: Int, lipides: Int) {
        guard let url = URL(string: "http://127.0.0.1:8080/aliment") else {
            print("URL invalide")
            return
        }

        let nouvelAliment = [
            "nom": nom,
            "qteCalorie": calories,
            "qteGlucide": glucides,
            "qteLipide": lipides
        ] as [String: Any]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: nouvelAliment, options: [])
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // Ajout du token
            request.httpBody = jsonData

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Erreur lors de la requête POST : \(error.localizedDescription)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Réponse du serveur invalide : \(String(describing: response))")
                    return
                }

                print("Aliment ajouté avec succès !")
                DispatchQueue.main.async {
                    self.fetchAliments() // Rafraîchit la liste après l'ajout
                }
            }.resume()
        } catch {
            print("Erreur lors de la création du JSON : \(error.localizedDescription)")
        }
    }
    
    /**
     ## `fetchAlimentsCount()`
     
     Récupère le nombre total d'aliments enregistrés 
     
     Cette fonction effectue une requête `GET` sur l'endpoint `/aliment/count` et met à jour la variable `alimentsCount` avec le nombre retourné par le serveur.
     
     - Note : Le nombre retourné représente la somme des aliments standards et personnalisés.
     */
    func fetchAlimentsCount() {
        guard let url = URL(string: "\(baseURL)/count") else {
            print("URL invalide")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erreur lors de la récupération du count : \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Réponse HTTP invalide")
                return
            }
            
            guard let data = data else {
                print("Données manquantes")
                return
            }
            
            do {
                let count = try JSONDecoder().decode(Int.self, from: data) // Décodage du nombre d'aliments
                DispatchQueue.main.async {
                    self.alimentsCount = count // Mise à jour de l'affichage du nombre d'aliments
                }
            } catch {
                print("Erreur de décodage JSON : \(error.localizedDescription)")
            }
        }.resume()
    }
}
    
    


