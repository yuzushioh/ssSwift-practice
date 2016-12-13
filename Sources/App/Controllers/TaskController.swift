//
//  TaskController.swift
//  server-side-swift
//
//  Created by yuzushioh on 12/13/16.
//
//

import Vapor
import HTTP

final class TaskController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        return try Task.all().makeNode().converted(to: JSON.self)
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        var task = try request.post()
        try task.save()
        return task
    }
    
    func show(request: Request, task: Task) throws -> ResponseRepresentable {
        return task
    }
    
    func delete(request: Request, task: Task) throws -> ResponseRepresentable {
        try task.delete()
        return JSON([:])
    }
    
    func clear(request: Request) throws -> ResponseRepresentable {
        try Task.query().delete()
        return JSON([])
    }
    
    func update(request: Request, item task: Task) throws -> ResponseRepresentable {
        let new = try request.post()
        var task = task
        task.title = new.title
        task.rank = new.rank
        try task.save()
        return task
    }
    
    func replace(request: Request, task: Task) throws -> ResponseRepresentable {
        try task.delete()
        return try create(request: request)
    }
    
    func makeResource() -> Resource<Task> {
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
    func post() throws -> Task {
        guard let json = json else {
            throw Abort.badRequest
        }
        
        return try Task(node: json)
    }
}
