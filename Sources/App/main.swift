import Vapor

let drop = Droplet()

drop.get("helloworld") { request in
    return "Hello World!"
}

drop.get("json") { request in
    return try JSON(node: [
        "message": "success"
    ])
}

drop.get("json", "sushi") { request in
    return try JSON(node: [
        "message": "へいお待ちっ！！"
    ])
}

drop.get("json", "sushi", String.self) { request, name in
    let sushi = Sushi(name: name)
    return try sushi.makeJSON()
}

drop.get("sushi", Int.self) { request, count in
    return try JSON(node: [
        "message": "へいおまち！🍣\(count)貫だよっ！！"
    ])
}

drop.post("post") { request in
    guard let name = request.data["name"]?.string else {
        throw Abort.badRequest
    }
    
    return try JSON(node: [
        "message": "\(name)様で13:00に予約でよろしいでしょうか？"
    ])
}

drop.run()
