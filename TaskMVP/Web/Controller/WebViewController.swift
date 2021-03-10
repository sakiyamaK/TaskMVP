//
//  WebViewController.swift
//  TaskMVP
//
//  Created by  on 2021/3/10.
//

import UIKit
import WebKit

/*
 MVC構成になっています、MVP構成に変えてください

 Viewから何かを渡す、Viewが何かを受け取る　以外のことを書かない
 if, guard, forといった制御を入れない
 Presenter以外のクラスを呼ばない
 githubModelといった変化するパラメータを持たない(状態を持たない)
 */

final class WebViewController: UIViewController {

  @IBOutlet private weak var webView: WKWebView!

  private var githubModel: GithubModel?

  func configure(githubModel: GithubModel) {
    self.githubModel = githubModel
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    guard
      let githubModel = githubModel,
      let url = URL(string: githubModel.urlStr) else {
      return
    }
    webView.load(URLRequest(url: url))
  }
}
