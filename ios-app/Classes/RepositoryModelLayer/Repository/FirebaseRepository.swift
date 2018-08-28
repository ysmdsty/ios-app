//
//  FirebaseRepository.swift
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

final class FirebaseRepository {

    public static func insert(collectionKey: String, documentkey: String, data: [String: Any]) {
        FirebaseAccessor.firestore.collection(collectionKey).document(documentkey).setData(data)
    }

    public static func update(collectionKey: String, documentkey: String, data: [String: Any]) {
        FirebaseAccessor.firestore.collection(collectionKey).document(documentkey).setData(data)
    }

    public static func selectAll(
        collectionKey: String,
        resultClosure: @escaping (Result<[QueryDocumentSnapshot], ResultErrorWrapper<MessageReadable>>) -> Void) {
        FirebaseAccessor.firestore.collection(collectionKey).getDocuments { (querySnapshot, error) in
            if let error = error {
                resultClosure(.failure(CommonError(message: "Error getting documents: \(error)").asMessageReadableResult()))
            } else {
                resultClosure(.success(querySnapshot!.documents))
            }
        }
    }
}
