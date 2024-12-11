//
//  AlimentModel.swift
//  ZakFit_Swiftui
//
//  Created by Apprenant 178 on 08/12/2024.
//

import Foundation

struct Aliment: Identifiable, Codable {
    let id: UUID
    let nom: String
    let qteCalorie: Int
    let qteGlucide: Int
    let qteLipide: Int
}
