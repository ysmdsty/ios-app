//
//  FirebaseAccessor.swift
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

final class FirebaseAccessor {
    public static let instance = FirebaseAccessor()
    public static var firestore: Firestore { return instance._firestore }
    private let _firestore: Firestore

    private init() {
        FirebaseApp.configure()
        let firebase = Firestore.firestore()
        let settings = firebase.settings
        settings.areTimestampsInSnapshotsEnabled = true
        firebase.settings = settings
        _firestore = firebase
    }

    public static func initialConfigure() {
        _ = instance
    }
}
