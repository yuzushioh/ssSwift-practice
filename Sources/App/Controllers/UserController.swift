//
//  UserController.swift
//  server-side-swift
//
//  Created by yuzushioh on 12/13/16.
//
//

import Vapor
import HTTP

final class UserController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        return try User.all().makeNode().converted(to: JSON.self)
    }
    
    func show(request: Request, user: User) throws -> ResponseRepresentable {
        return user
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        var user = try request.postUser()
        let users = try User.query().filter("email", user.email).run()
        
        guard users.isEmpty else {
            throw CustomServerError.userAlreadyExisted
        }
        
        try user.save()
        return user
    }
    
    func update(request: Request, item user: User) throws -> ResponseRepresentable {
        let new = try request.postUser()
        var user = user
        user.username = new.username
        user.email = new.email
        try user.save()
        return user
    }
    
    func delete(request: Request, user: User) throws -> ResponseRepresentable {
        try user.delete()
        return JSON([:])
    }
    
    func clear(request: Request) throws -> ResponseRepresentable {
        try User.query().delete()
        return JSON([])
    }
    
    func replace(request: Request, user: User) throws -> ResponseRepresentable {
        try user.delete()
        return try create(request: request)
    }
    
    func makeResource() -> Resource<User> {
        return Resource(
            index: index,
            store: create,
            show: show,
            replace: replace,
            modify: update, 
            destroy: delete,
            clear: clear
        )
    }
}

extension Request {
    func postUser() throws -> User {
        guard let json = json else {
            throw Abort.badRequest
        }
        
        return try User(node: json)
    }
}
