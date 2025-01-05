//
//  ContientModel.swift
//  ZakFit_Swiftui
//
//  Created by Apprenant 178 on 03/01/2025.
//

import Foundation

// Structure pour les aliments dans le repas
    struct AlimentContenu: Codable, Identifiable {
        var id: UUID?  // Optionnel
        var alimentID: UUID  // ID de l'aliment pour le POST
        var nom: String?
        var quantite: Int  
        var calorie: Int?
    }
