//
//  TodoEntity.swift
//  ios-app
//
//  Created by ysmdsty on 2018/08/28.
//  Copyright © 2018年 ysmdsty. All rights reserved.
//

import Foundation

struct TodoEntity {
    let uuid: String
    let title: String
    let done: Bool

    init(title: String, done: Bool = false, uuid: String = UUID().uuidString) {
        self.uuid = uuid
        self.title = title
        self.done = done
    }
}
