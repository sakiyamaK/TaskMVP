//
//  MVCTableViewCell.swift
//  TaskMVP
//
//  Created by sakiyamaK on 2021/03/10.
//

import UIKit

/*
 MVCと基本変わらない
 */
final class MVPTableViewCell: UITableViewCell {

  static var className: String { String(describing: MVPTableViewCell.self) }

  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var urlLabel: UILabel!

  override func prepareForReuse() {
    super.prepareForReuse()
    titleLabel.text = nil
    urlLabel.text = nil
  }

  func configure(githubModel: GithubModel) {
    self.titleLabel.text = githubModel.fullName
    self.urlLabel.text = githubModel.urlStr
  }
}

