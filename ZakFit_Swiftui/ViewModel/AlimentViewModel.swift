//
//  AlimentViewModel.swift
//  ZakFit_Swiftui
//
//  Created by Apprenant 178 on 08/12/2024.
//


import Foundation


class AlimentViewModel: ObservableObject {
    @Published var aliments: [Aliment] = [] // Liste des aliments à afficher
    @Published var alimentsCount: Int = 0
    private let baseURL = "http://127.0.0.1:8080/aliment" // URL de l'API
    private let token: String // Token d'authentification
    
    init(token: String) {
        self.token = token
    }
    
    func fetchAliments() {
        guard let url = URL(string: baseURL) else {
            print("URL invalide")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // Ajout du token
        
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
                    self.aliments = aliments
                }
            } catch {
                print("Erreur de décodage JSON : \(error.localizedDescription)")
            }
        }.resume()
    }
    
    
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
        ] as [String : Any]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: nouvelAliment, options: [])
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Erreur lors de la requête POST : \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Réponse du serveur invalide")
                    return
                }
                
                print("Aliment ajouté avec succès !")
                DispatchQueue.main.async {
                    self.fetchAliments()
                }
            }.resume()
        } catch {
            print("Erreur lors de la création du JSON : \(error.localizedDescription)")
        }
    }
    
    
    
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
                    self.alimentsCount = count
                }
            } catch {
                print("Erreur de décodage JSON : \(error.localizedDescription)")
            }
        }.resume()
    }
}
    
    


