//
//  UserViewModel.swift
//  ZakFit_Swiftui
//
//  Created by Apprenant 178 on 09/12/2024.
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var user: [UserModel] = []
    @Published var isLoggedIn = false
    
    
    func fetchUser() {
        
        guard let url = URL(string: "http://127.0.0.1:8080/user") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
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
    
    func login(email: String, mdp: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:8080/user/login") else {
            print("Invalid URL")
            completion(false) // Echec immédiat
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
                    completion(false) // Indique l'échec
                }
                return
            }
            
            print("Authentification réussie")
            
            do {
                let token = try JSONDecoder().decode(JWToken.self, from: data)
                print("token: ", token.value)
                KeyChainManager.save(token: token.value)
                DispatchQueue.main.async {
                    completion(true) // Succès
                }
            } catch {
                print("Erreur dans le décodage du token")
                DispatchQueue.main.async {
                    completion(false) // Echec
                }
            }
        }.resume()
    }
}
