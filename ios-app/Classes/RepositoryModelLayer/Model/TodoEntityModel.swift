//
//  TodoEntityModel.swift
//  ios-app
//
//  Created by ysmdsty on 2018/08/28.
//  Copyright © 2018年 ysmdsty. All rights reserved.
//

import Foundation

final class TodoEntityModel {
    public static func documentData(from todo: TodoEntity) -> [String: Any] {
        return ["title": todo.title, "done": todo.done]
    }

    public static func todoEntity(from documentData: [String: Any], uuid: String) -> TodoEntity {
        return TodoEntity(title: documentData["title"] as? String ?? "", done: documentData["done"]  as? Bool ?? false, uuid: uuid)
    }
}
