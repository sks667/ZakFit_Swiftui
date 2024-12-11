//
//  UserModel.swift
//  ZakFit_Swiftui
//
//  Created by Apprenant 178 on 09/12/2024.
//

import Foundation

struct UserModel: Codable, Identifiable {
    let id: UUID?
    var nom: String
    var prenom: String
    var email: String
    var mdp: String
    var taille: Int
    var poids: Int
    var preferenceAlimentaire: String
    

}

