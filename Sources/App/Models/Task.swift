//
//  Task.swift
//  server-side-swift
//
//  Created by yuzushioh on 12/13/16.
//
//

import Vapor
import Fluent
import Foundation

final class Task: Model {
    var id: Node?
    var title: String
    var rank: String
    
    init(title: String, rank: String) {
        self.title = title
        self.rank = rank
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        title = try node.extract("title")
        rank = try node.extract("rank")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "title": title,
            "rank": rank
        ])
    }
}

extension Task {
    public convenience init?(from title: String, rank: String) throws {
        self.init(title: title, rank: rank)
    }
}

extension Task: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create("tasks") { tasks in
            tasks.id()
            tasks.string("title")
            tasks.string("rank")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("tasks")
    }
}
