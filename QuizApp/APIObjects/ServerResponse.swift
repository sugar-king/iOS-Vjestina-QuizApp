//
//  ServerResponse.swift
//  QuizApp
//
//  Created by five on 16.05.2021..
//

import Foundation

enum ServerResponse : Int, Codable {
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case badRequest = 400
    case ok = 200
}
