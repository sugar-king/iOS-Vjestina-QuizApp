//
//  LoginData.swift
//  QuizApp
//
//  Created by five on 16.05.2021..
//

import Foundation

struct LoginData : Codable {
    let token: String
    let userId: Int
    
    enum CodingKeys : String, CodingKey {
        case token
        case userId = "user_id"
    }
}
