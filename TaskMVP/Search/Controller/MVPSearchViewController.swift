//
//  MVCViewController.swift
//  TaskMVP
//
//  Created by  on 2021/3/10.
//

import UIKit

/*
 MVC構成になっています、MVP構成に変えてください

 Viewから何かを渡す、Viewが何かを受け取る　以外のことを書かない
 if, guard, forといった制御を入れない
 Presenter以外のクラスを呼ばない
 itemsといった変化するパラメータを持たない(状態を持たない)
*/
final class MVPSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet private weak var searchTextField: UITextField!
  @IBOutlet private weak var searchButton: UIButton! {
    didSet {
      searchButton.addTarget(self, action: #selector(tapSearchButton(_sender:)), for: .touchUpInside)
    }
  }

  @IBOutlet private weak var indicator: UIActivityIndicatorView!

  @IBOutlet private weak var tableView: UITableView! {
    didSet {
      tableView.register(UINib.init(nibName: MVPTableViewCell.className, bundle: nil), forCellReuseIdentifier: MVPTableViewCell.className)
      tableView.delegate = self
      tableView.dataSource = self
    }
  }

  private var items: [GithubModel] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.isHidden = true
    indicator.isHidden = true
  }

  @objc func tapSearchButton(_sender: UIResponder) {
    guard let searchWord = searchTextField.text, !searchWord.isEmpty else { return }
    indicator.isHidden = false
    tableView.isHidden = true
    GithubAPI.shared.get(searchWord: searchWord) { result in
      DispatchQueue.main.async {
        self.indicator.isHidden = true
        self.tableView.isHidden = false
        switch result {
        case .failure(let error):
          print(error)
        case .success(let items):
          self.items = items
          self.tableView.reloadData()
        }
      }
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    Router.shared.showWeb(from: self, githubModel: items[indexPath.item])
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    items.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: MVPTableViewCell.className) as? MVPTableViewCell else {
      fatalError()
    }
    let githubModel = items[indexPath.item]
    cell.configure(githubModel: githubModel)
    return cell
  }
}
