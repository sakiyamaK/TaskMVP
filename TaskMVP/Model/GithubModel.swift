//
//  GithubModel.swift
//  TaskMVP
//
//  Created by sakiyamaK on 2021/03/10.
//

import Foundation

/*
 今回はモデルはいじらない
 人によってはmodelに自身を取得するapiを書く人もいる
 */

struct GithubResponse: Codable {
  let items: [GithubModel]?
}

struct GithubModel: Codable {
  let fullName: String
  var urlStr: String { "https://github.com/\(fullName)" }

  enum CodingKeys: String, CodingKey {
    case fullName = "full_name"
  }
}
