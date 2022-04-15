//
//  DogModel.swift
//  URLSession
//
//  Created by u on 11.04.2022.
//

import Foundation

struct RandomDog: Codable {
    
    var message: String?
    var status: String?
    
    init(message: String, status: String) {
        self.message = message
        self.status = status
    }
    
}
