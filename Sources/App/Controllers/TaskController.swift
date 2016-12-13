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
    
    // GETリクエストについては index() と show() が呼ばれます。
    
    // 全てを取り出してJSON形式にしてレスポンスしてくれます。
    // curl http://127.0.0.1:8080/tasks
    func index(request: Request) throws -> ResponseRepresentable {
        return try Task.all().makeNode().converted(to: JSON.self)
    }
    
    // 詳細情報取得
    // http://127.0.0.1:8080/tasks/id
    func show(request: Request, task: Task) throws -> ResponseRepresentable {
        return task
    }
    
    //POSTリクエストは create() が呼ばれます。
    
    // curl http://127.0.0.1:8080/tasks -X POST -d '{"title": "hoge", "rank": "中"}' -H "Content-Type: application/json" -H "Accept: application/json"
    func create(request: Request) throws -> ResponseRepresentable {
        var task = try request.post()
        try task.save()
        return task
    }
    
    // PUTリクエストは update() が呼ばれます。
    
    // curl http://127.0.0.1:8080/tasks/id -X PUT -d '{"title": "あっぷでーと", "rank": "低"}' -H "Content-Type: application/json" -H "Accept: application/json"
    func update(request: Request, item task: Task) throws -> ResponseRepresentable {
        let new = try request.post()
        var task = task
        task.title = new.title
        task.rank = new.rank
        try task.save()
        return task
    }
    
    // DELETEリクエストは delete() が呼ばれます。
    
    // curl http://127.0.0.1:8080/tasks/id -X DELETE
    func delete(request: Request, task: Task) throws -> ResponseRepresentable {
        try task.delete()
        return JSON([:])
    }
    
    func clear(request: Request) throws -> ResponseRepresentable {
        try Task.query().delete()
        return JSON([])
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
