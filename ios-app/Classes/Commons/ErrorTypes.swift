//
//  ErrorTypes.swift
//  ios-app
//
//  Created by ysmdsty on 2018/08/28.
//  Copyright © 2018年 ysmdsty. All rights reserved.
//

import Foundation

final class ResultErrorWrapper<T>: Swift.Error {
    public let element: T

    required init(_ element: T) {
        self.element = element
    }
}

public protocol MessageReadable {
    var message: String {get}
}

final class CommonError: Swift.Error, MessageReadable {

    let message: String
    init(message: String) {
        self.message = message
    }

    func asMessageReadableResult() -> ResultErrorWrapper<MessageReadable> {
        return ResultErrorWrapper(self)
    }
}
