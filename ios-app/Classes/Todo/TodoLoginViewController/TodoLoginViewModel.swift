//
//  TodoLoginViewModel.swift
//  ios-app
//
//  Created by ysmdsty on 2018/08/28.
//  Copyright © 2018年 ysmdsty. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class TodoLoginViewModel {
    typealias Controller = TodoLoginViewController
    weak var controller: Controller!

    var errorMessage: BehaviorRelay = BehaviorRelay(value: "")

    private init(_ controller: Controller) {
        self.controller = controller
    }

    public static func registered(controller: Controller) -> Self {
        let instance = self.init(controller)
        instance.bind()
        return instance
    }

    var loginButtonTappedEvent: Driver<(String, String)> {
        weak var wController = controller
        return controller.loginButton.rx.tap
            .map { _ in (wController?.mailTextField.text ?? "", wController?.passTextField.text ?? "") }
            .asDriver(onErrorJustReturn: ("", ""))
            .filter { !$0.0.isEmpty && !$0.1.isEmpty }
    }

    private func bind() {
        errorMessage.asDriver()
            .drive(controller.messageLabel.rx.text)
            .disposed(by: controller.rx.disposeBag)
        Observable
            .combineLatest(controller.mailTextField.rx.text,
                           controller.passTextField.rx.text) { (text1, text2) -> Bool in
                            guard let text1 = text1, let text2 = text2 else { return false }
                            return !text1.isEmpty && !text2.isEmpty
            }
            .asDriver(onErrorJustReturn: false)
            .drive(controller.loginButton.rx.isEnabled)
            .disposed(by: controller.rx.disposeBag)
    }
}
