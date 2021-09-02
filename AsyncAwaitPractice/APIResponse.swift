//
//  APIResponse.swift
//  APIResponse
//
//  Created by Erik Flores on 2/9/21.
//

import Foundation

struct APIResponse: Decodable {
    let characters: String
    let locations: String
    let episodes: String
}