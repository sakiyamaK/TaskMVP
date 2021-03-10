//
//  WebPresenter.swift
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
protocol WebPresenterInput {
  func viewDidLoaded()
}

//外へ出すアクションのprotocol
protocol WebPresenterOutput: AnyObject {
  func load(request: URLRequest)
}

final class WebPresenter {

  //外へ出すprotocolに準拠したインスタンス(ほとんどの場合ViewControllerのこと)
  private weak var output: WebPresenterOutput!
  //初期化パラメータ
  private var githubModel: GithubModel

  init(output: WebPresenterOutput, githubModel: GithubModel) {
    self.output = output
    self.githubModel = githubModel
  }
}

extension WebPresenter: WebPresenterInput {
  //外から画面に読み込まれたアクションがきたときの処理
  func viewDidLoaded() {
    guard let url = URL(string: githubModel.urlStr) else { return }
    //外へloadのアクションをしろと伝える
    self.output.load(request: URLRequest(url: url))
  }
}
