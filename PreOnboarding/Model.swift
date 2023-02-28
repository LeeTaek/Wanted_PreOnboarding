//
//  Model.swift
//  PreOnboarding
//
//  Created by 이택성 on 2023/02/25.
//

import Foundation

struct Image: Codable, Hashable {
  let id, author: String
  let width, height: Int
  let url, download_url: String
  
  init(id: String = UUID().description, author: String = "", width: Int = 0, height: Int = 0, url: String = "", download_url: String = "") {
    self.id = id
    self.author = author
    self.width = width
    self.height = height
    self.url = url
    self.download_url = download_url
  }
}



enum ImageId: Int, CaseIterable {
  case first = 0
  case second = 1
  case third = 2
  case fourth = 3
  case none = 4
  
  func getId() -> String {
    switch self {
    case .first:
      return "10/info"
    case .second:
      return "26/info"
    case .third:
      return "319/info"
    case .fourth:
      return "376/info"
    default:
      return ""
    }
  }
}
