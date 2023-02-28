//
//  APIService.swift
//  PreOnboarding
//
//  Created by 이택성 on 2023/02/25.
//

import Foundation
import Combine

class APIService {
  static let shared = APIService()
  let BASE_URL = "https://picsum.photos/id/"
  
  var cancellable: AnyCancellable?

  func fetchImages(id: ImageId) -> AnyPublisher<Image, Error> {
    guard let url = URL(string: BASE_URL + id.getId()) else {
      return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
    }
    print(url)
    return URLSession.shared
      .dataTaskPublisher(for: url)
      .map(\.data)
      .decode(type: Image.self, decoder: JSONDecoder())
      .print("[APIService]")
      .eraseToAnyPublisher()
  }
}
