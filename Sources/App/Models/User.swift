//
//  User.swift
//  server-side-swift
//
//  Created by yuzushioh on 12/13/16.
//
//

import Foundation
import Vapor
import Fluent

final class User: Model {
    var id: Node?
    var username: String
    var email: String

    init(username: String, email: String) {
        self.username = username
        self.email = email
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        username = try node.extract("username")
        email = try node.extract("email")
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "username": username,
            "email": email
        ])
    }
}

extension User {
    public convenience init?(from username: String, email: String) throws {
        self.init(username: username, email: email)
    }
}

extension User: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create("users") { tasks in
            tasks.id()
            tasks.string("username")
            tasks.string("email")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("tasks")
    }
}
