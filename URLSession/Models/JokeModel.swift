//
//  JokeModel.swift
//  URLSession
//
//  Created by u on 13.04.2022.
//

import Foundation


struct Joke: Codable {
    let error: Bool?
    let category, type, setup, delivery: String?
    var flags: Flags?
    let id: Int?
    let safe: Bool?
    let lang: String?
    
    init(type: [String: Any]) {
        self.error = type["error"] as? Bool
        self.category = type["category"] as? String
        self.type = type["type"] as? String
        self.setup = type["setup"] as? String
        self.delivery = type["delivery"] as? String
        self.flags = type["flags"] as? Flags
        self.id = type["id"] as? Int
        self.safe = type["safe"] as? Bool
        self.lang = type["lang"] as? String
    }
}


struct Flags: Codable {
    let nsfw, religious, political, racist: Bool?
    let sexist, explicit: Bool?
    
    init(type: [String: Any]) {
        self.nsfw = type["nsfw"] as? Bool
        self.religious = type["religious"] as? Bool
        self.political = type["political"] as? Bool
        self.racist = type["racist"] as? Bool
        self.sexist = type["sexist"] as? Bool
        self.explicit = type["explicit"] as? Bool
    }
}

