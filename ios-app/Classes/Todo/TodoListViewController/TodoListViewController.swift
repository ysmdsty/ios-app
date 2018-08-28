//
//  TodoListViewController.swift
//  ios-app
//
//  Created by ysmdsty on 2018/08/27.
//  Copyright © 2018年 ysmdsty. All rights reserved.
//

import UIKit
import FirebaseAuth

final class TodoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var addButton: UIButton!

    var user: User!
    var data: [TodoEntity] = []

    override func loadView() {
        super.loadView()
        user = Auth.auth().currentUser
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()

        var refreshControl = UIRefreshControl()
        self.tableView.addSubview(refreshControl)
        weak var weakRefreshControl = refreshControl
        refreshControl.rx
            .controlEvent(.valueChanged)
            .map { _ in
                if let refreshControl = weakRefreshControl {
                    return !refreshControl.isRefreshing
                } else {
                    return true
                }
            }.map { $0 == false }.subscribe { [weak wself = self] _ in
                wself?.reloadData()
            }.disposed(by: self.rx.disposeBag)

        refreshControl.rx
            .controlEvent(.valueChanged)
            .map { _ in
                if let refreshControl = weakRefreshControl {
                    return refreshControl.isRefreshing
                } else {
                    return false
                }
            }.map { $0 == true }.subscribe { _ in
                weakRefreshControl?.endRefreshing()
            }.disposed(by: self.rx.disposeBag)
        addButton.rx.tap.subscribe { [weak wself = self] _ in
            guard let uid = wself?.user.uid else { return }
            guard let textField = wself?.textField else { return }
            guard let text = textField.text, !text.isEmpty else { return }
            textField.text = ""
            let todo = TodoEntity(title: text)
            FirebaseModel.add(userId: uid, todo: todo)
            wself?.appendAndReload(todo: todo)
        }.disposed(by: self.rx.disposeBag)
    }

    private func reloadData() {
        FirebaseModel.findAll(userId: user.uid) { [weak wself = self] result in
            switch result {
            case .success(let value):
                wself?.reload(data: value)
            case .failure:
                return
            }
        }
    }

    private func reload(data: [TodoEntity]) {
        DispatchQueue.main.async {
            self.data =  data
            self.tableView.reloadData()
        }
    }
    private func appendAndReload(todo: TodoEntity) {
        DispatchQueue.main.async {
            self.data.append(todo)
            self.tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowData = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        cell.textLabel?.text = rowData.title
        cell.backgroundColor = rowData.done ? .blue : .white
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let rowData = data[indexPath.row]
        let newRowData = TodoEntity(title: rowData.title, done: !rowData.done, uuid: rowData.uuid)
        data[indexPath.row] = newRowData
        FirebaseModel.update(userId: user.uid, todo: newRowData)
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
    }
}
