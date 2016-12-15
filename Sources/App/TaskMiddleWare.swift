//
//  TaskMiddleWare.swift
//  server-side-swift
//
//  Created by yuzushioh on 12/15/16.
//
//

import Vapor
import HTTP

final class TaskMiddleWare: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        do {
            return try next.respond(to: request)
        } catch CustomServerError.userAlreadyExisted  {
            throw Abort.custom(status: .forbidden, message: "このユーザーは既に存在します。")
        } catch {
            throw Abort.badRequest
        }
    }
}
