//
//  Router.swift
//  TaskMVP
//
//  Created by sakiyamaK on 2021/03/10.
//

import UIKit

/*
 */

final class Router {
  static let shared = Router()
  private init() {}

  private var window: UIWindow?

  func showRoot(window: UIWindow) {
    guard let vc = UIStoryboard.init(name: "MVPSearch", bundle: nil).instantiateInitialViewController() as? MVPSearchViewController else {
      return
    }
    //presenterとvc同士を繋ぎ合う
    let presenter = MVPSearchPresenter(output: vc)
    vc.inject(presenter: presenter)

    let nav = UINavigationController(rootViewController: vc)
    window.rootViewController = nav
    window.makeKeyAndVisible()
    self.window = window
  }

  func showWeb(from: UIViewController, githubModel: GithubModel) {
    guard let web = UIStoryboard.init(name: "Web", bundle: nil).instantiateInitialViewController() as? WebViewController else {
      return
    }
    //presenterとvc同士を繋ぎ合う
    //初期化パラメータ(githubModel)が必要ならそれもPresenterに渡す
    let presenter = WebPresenter(output: web, githubModel: githubModel)
    web.inject(presenter: presenter)
   show(from: from, to: web)
  }

  private func show(from: UIViewController, to: UIViewController, completion:(() -> Void)? = nil){
    if let nav = from.navigationController {
      nav.pushViewController(to, animated: true)
      completion?()
    } else {
      from.present(to, animated: true, completion: completion)
    }
  }
}
