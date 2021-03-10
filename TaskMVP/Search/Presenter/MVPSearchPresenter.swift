//
//  MVPSearchPresenter.swift
//  TaskMVP
//
//  Created by sakiyamaK on 2021/03/11.
//

import Foundation

/*
 模範解答
 */

//モジュール同士を疎結合にするためprotocolを用意する

//外から受け付けるアクションのprotocol
protocol MVPSearchPresenterInput {
  var numberOfItems: Int { get }
  func item(index: Int) -> GithubModel
  func searchText(_ text: String?)
  func didSelect(index: Int)
}

//外へ出すアクションのprotocol
protocol MVPSearchPresenterOutput: AnyObject {
  func update(loading: Bool)
  func update(githubModels: [GithubModel])
  func get(error: Error)
  func showWeb(githubModel: GithubModel)
}

final class MVPSearchPresenter {

  //外へ出すprotocolに準拠したインスタンス(ほとんどの場合ViewControllerのこと)
  private weak var output: MVPSearchPresenterOutput!
  //内部で利用する通信用のprotocolに準拠したインスタンス
  private var api: GithubAPIProtocol!
  //このモジュール内で変化するパラメータ(状態が変わる)
  private var githubModels: [GithubModel]

  init(output: MVPSearchPresenterOutput, api: GithubAPIProtocol = GithubAPI.shared) {
    self.output = output
    self.api = api
    self.githubModels = []
  }
}

extension MVPSearchPresenter: MVPSearchPresenterInput {
  //外部から数を教えろと通知がきたときの処理
  //presenterは画面で何があった時にこの通知が必要なのか知らなくていい
  var numberOfItems: Int { githubModels.count }

  //外部からこのindexのitemをくれと通知がきたときの処理
  //presenterは画面で何があった時にこの通知が必要なのか知らなくていい
  func item(index: Int) -> GithubModel { githubModels[index] }

  //外部からこのindexのitemが選択されたぞと通知がきたときの処理
  //presenterは画面で何があった時にこの通知が必要なのか知らなくていい
  func didSelect(index: Int) {
    //このmodelを使ってwebを開けと外部に通知する
    //presenterはどうやってwebを開くのか知る必要はない
    //アプリ内ブラウザかもしれないし、webviewを立ち上げるのかもしれないし、スマホの標準ブラウザかもしれないがpresenterには関係ない
    output.showWeb(githubModel: githubModels[index])
  }

  //外部からこのテキストで検索しろと通知がきたときの処理
  //presenterは画面で何があった時にこの通知が必要なのか知らなくていい
  //音声入力かもしれないし、キーボード入力かもしれないし、過去の履歴から検索したのかもしれないがpresenterには関係ない
  func searchText(_ text: String?) {
    guard let text = text, !text.isEmpty else { return }
    //loadingが始まったぞ外部に通知する
    //presenterはこのフラグが外部で利用されているのかどうかも知る必要がない
    output.update(loading: true)
    self.api.get(searchWord: text) {[weak self] (result) in
      //loadingが終わったぞ外部に通知する
      //presenterはこのフラグが外部で利用されているのかどうかも知る必要がない
      self?.output.update(loading: false)
      switch result {
      case .success(let githubModels):
        //状態を更新する
        self?.githubModels = githubModels
        //状態が変わったぞと外部に通知する
        self?.output.update(githubModels: githubModels)
      case .failure(let error):
        //エラーがあったぞと外部に通知する
        self?.output.get(error: error)
      }
    }
  }
}
