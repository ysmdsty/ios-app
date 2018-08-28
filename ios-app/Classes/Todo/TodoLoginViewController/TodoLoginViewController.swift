//
//  TodoLoginViewController.swift
//  ios-app
//
//  Created by ysmdsty on 2018/08/27.
//  Copyright © 2018年 ysmdsty. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import Firebase
import FirebaseAuth
import Result

final class TodoLoginViewController: ViewController {
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!

    var viewModel: TodoLoginViewModel!

    override func loadView() {
        super.loadView()
        viewModel = TodoLoginViewModel.registered(controller: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loginButtonTappedEvent.drive(onNext: { [weak wself = self] (input) in
            FirebaseModel.auth(mail: input.0, pass: input.1) { result in
                switch result {
                case .success:
                    wself?.performSegue(withIdentifier: "ToTodoListViewController", sender: nil)
                case .failure(let error):
                    wself?.viewModel.errorMessage.accept(error.element.message)
                }
            }
        }).disposed(by: rx.disposeBag)
    }

}
