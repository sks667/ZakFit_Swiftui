//
//  UserViewModel.swift
//  ZakFit_Swiftui
//
//  Created by Apprenant 178 on 09/12/2024.
//

import Foundation

/// `UserViewModel` est un ViewModel SwiftUI qui gère la logique d'authentification, l'enregistrement des utilisateurs, ainsi que la récupération du profil utilisateur.
class UserViewModel: ObservableObject {
    
    /// Liste des utilisateurs récupérés (rarement utilisée directement dans l'app).
    @Published var user: [UserModel] = []
    
    /// Statut de connexion de l'utilisateur (vrai s'il est connecté, faux sinon).
    @Published var isLoggedIn = false
    
    /// Token JWT pour l'authentification de l'utilisateur.
    @Published var token: String?
    
    /**
     Récupère la liste des utilisateurs via l'API.
     
     Cette fonction effectue une requête GET sécurisée par un token JWT pour récupérer la liste des utilisateurs. Elle est principalement à usage d'administration ou pour afficher le profil complet.
     
     - Important : La requête nécessite un token valide.
     */
    func fetchUser() {
        guard let token = token else {
            print("Token manquant pour récupérer les utilisateurs")
            return
        }

        guard let url = URL(string: "http://127.0.0.1:8080/user") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([UserModel].self, from: data)
                    DispatchQueue.main.async {
                        self.user = decodedData
                        print(self.user)
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            } else if let error = error {
                print("Error fetching data: \(error)")
            }
        }.resume()
    }

    /**
     Connecte un utilisateur via son adresse email et son mot de passe.
     
     Cette fonction effectue une requête POST avec une autorisation Basic pour obtenir un token JWT.
     
     - Parameters:
        - email: Adresse email de l'utilisateur.
        - mdp: Mot de passe de l'utilisateur.
        - completion: Closure qui retourne un Booléen indiquant si la connexion a réussi.
     */
    func login(email: String, mdp: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:8080/user/login") else {
            print("Invalid URL")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let authData = (email + ":" + mdp).data(using: .utf8)!.base64EncodedString()
        request.addValue("Basic \(authData)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil,
                  let responseHttp = response as? HTTPURLResponse, responseHttp.statusCode == 200,
                  let data = data else {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }

            print("Authentification réussie")

            do {
                let token = try JSONDecoder().decode(JWToken.self, from: data)
                print("Token reçu : \(token.value)")
                DispatchQueue.main.async {
                    self.token = token.value // Stockage du token
                    self.isLoggedIn = true // Mise à jour de l'état
                    completion(true)
                }
            } catch {
                print("Erreur dans le décodage du token")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }.resume()
    }

    /**
     Enregistre un nouvel utilisateur dans la base de données via une requête POST.
     
     - Parameters:
        - nom: Nom de l'utilisateur.
        - prenom: Prénom de l'utilisateur.
        - taille: Taille en centimètres.
        - poids: Poids en kilogrammes.
        - email: Adresse email unique.
        - mdp: Mot de passe de l'utilisateur.
        - preferenceAlimentaire: Préférences alimentaires de l'utilisateur.
     
     - Note: Cette fonction encode les informations utilisateur sous forme JSON avant de les envoyer.
     */
    func register(nom: String, prenom: String, taille: Int, poids: Int, email: String, mdp: String, preferenceAlimentaire: String) {
        guard let url = URL(string: "http://localhost:8080/user") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let user = UserModel(
            id: nil,
            nom: nom,
            prenom: prenom,
            email: email,
            mdp: mdp,
            taille: taille,
            poids: poids,
            preference_alimentaire: preferenceAlimentaire
        )

        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
        } catch {
            print("Erreur lors de l'encodage des données : \(error.localizedDescription)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erreur de requête : \(error.localizedDescription)")
                return
            }

            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                print("Utilisateur enregistré avec succès !")
            } else {
                print("Erreur lors de l'enregistrement : \(response.debugDescription)")
            }
        }.resume()
    }
}
