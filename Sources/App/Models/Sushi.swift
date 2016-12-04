//
//  Sushi.swift
//  server-side-swift
//
//  Created by yuzushioh on 12/4/16.
//
//

import Foundation
import Vapor
import Fluent

struct Sushi {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

extension Sushi: JSONRepresentable {
    func makeJSON() throws -> JSON {
        return try JSON(node: [
            "name": "\(name)"
        ])
    }
}
