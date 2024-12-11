//
//  Token.swift
//  ZakFit_Swiftui
//
//  Created by Apprenant 178 on 09/12/2024.
//

import Foundation

struct JWToken: Codable {
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case value = "token"
    }
}
