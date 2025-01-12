//
//  RepasModel.swift
//  ZakFit_Swiftui
//
//  Created by Apprenant 178 on 03/01/2025.
//

import Foundation

struct RepasModel: Identifiable, Codable {
    var id: UUID?  
    var calorieTotal: Double
    var typeRepas: String
    var dateRepas: Date
    var aliments: [AlimentContenu]
}


