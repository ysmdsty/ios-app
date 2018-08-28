//
//  FirebaseModel.swift
//  ios-app
//
//  Created by ysmdsty on 2018/08/28.
//  Copyright © 2018年 ysmdsty. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Result

final class FirebaseModel {
    public static func auth(mail: String, pass: String, resultClosure: @escaping (Result<User, ResultErrorWrapper<MessageReadable>>) -> Void) {
        Auth.auth().signIn(withEmail: mail, password: pass) { (result, error) in
            if let error = error {
                resultClosure(.failure(CommonError(message: error.localizedDescription).asMessageReadableResult()))
                return
            }
            guard let user = result?.user else {
                resultClosure(.failure(CommonError(message: "user not found").asMessageReadableResult()))
                return
            }
            resultClosure(.success(user))
        }
    }

    public static func collectionKey(from userId: String) -> String {
        return "user-todo-list-\(userId)"
    }

    public static func add(userId: String, todo: TodoEntity) {
        FirebaseRepository.insert(collectionKey: collectionKey(from: userId), documentkey: todo.uuid, data: TodoEntityModel.documentData(from: todo))
    }

    public static func update(userId: String, todo: TodoEntity) {
        FirebaseRepository.update(collectionKey: collectionKey(from: userId), documentkey: todo.uuid, data: TodoEntityModel.documentData(from: todo))
    }

    public static func findAll(userId: String, resultClosure: @escaping (Result<[TodoEntity], ResultErrorWrapper<MessageReadable>>) -> Void) {
        FirebaseRepository.selectAll(collectionKey: collectionKey(from: userId)) { result in
            switch result {
            case .success(let value):
                resultClosure(.success(value.map { TodoEntityModel.todoEntity(from: $0.data(), uuid: $0.documentID) }))
            case .failure(let error):
                resultClosure(.failure(error))
            }

        }
    }
}
