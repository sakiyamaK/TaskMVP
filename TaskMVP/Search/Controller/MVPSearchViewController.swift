//
//  MVCViewController.swift
//  TaskMVP
//
//  Created by  on 2021/3/10.
//

import UIKit

/*
 模範解答
*/

// VCで状態をもたない
// VCで制御をもたない
// つまり、この中だけで何か処理が変化することはない
final class MVPSearchViewController: UIViewController {

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

  private var presenter: MVPSearchPresenterInput!
  func inject(presenter: MVPSearchPresenterInput) {
    self.presenter = presenter
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.isHidden = true
    indicator.isHidden = true
  }

  @objc func tapSearchButton(_sender: UIResponder) {
    //presenterに検索してくれと伝える
    //VCはどこからどうやって検索するか知る必要がない
    self.presenter.searchText(searchTextField.text)
  }
}

extension MVPSearchViewController: MVPSearchPresenterOutput {
  //presenterからloadingフラグが変わったぞと通知がきたときの処理
  //VCは何をしたからloadingが変わったのか知る必要がない
  func update(loading: Bool) {
    DispatchQueue.main.async {
      self.tableView.isHidden = loading
      self.indicator.isHidden = !loading
    }
  }

  //presenterから内部状態が変わったぞと通知がきたときの処理
  //VCは何をしたからpresenterの内部状態が変わったのか知る必要がない
  func update(githubModels: [GithubModel]) {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }

  //presenterからエラーが発生したぞと通知がきたときの処理
  //VCはなぜエラーが出たのか知る必要がない
  func get(error: Error) {
    DispatchQueue.main.async {
      print(error.localizedDescription)
    }
  }

  //presenterからwebをひらけと通知がきたときの処理
  //VCは何をしたからwebを開けと言われたのか知る必要がない
  func showWeb(githubModel: GithubModel) {
    DispatchQueue.main.async {
      Router.shared.showWeb(from: self, githubModel: githubModel)
    }
  }
}

extension MVPSearchViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    //presenterにセルがタップされたことを知らせる
    //VCはこのあと何が起きるのか知る必要がない
    presenter.didSelect(index: indexPath.row)
  }
}

extension MVPSearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //presenterに内部状態(item)の数を知らせてもらう
    //VCはどうなって数が決まったのか知る必要がない
    presenter.numberOfItems
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: MVPTableViewCell.className) as? MVPTableViewCell else {
      fatalError()
    }
    // presenterからmodelをもらう
    // vcはどうやってmodelをもらえたのか知る必要がない
    // presenterがUserDefaultsとかのキャッシュから取ってきたのか、今サーバーと通信したのか、
    // ランダムに何か計算して決まるのか、VCには関係ない
    let githubModel = presenter.item(index: indexPath.item)
    cell.configure(githubModel: githubModel)
    return cell
  }
}
