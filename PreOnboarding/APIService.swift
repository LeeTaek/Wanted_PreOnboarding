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
    return Future { promise in
      self.cancellable = URLSession.shared
        .dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: Image.self, decoder: JSONDecoder())
        .print("APIService")
        .sink(receiveCompletion: { completion in
          switch completion{
           case .finished:
             print("fetch Image finished")
           case .failure(let error):
             print("fetch image error: \(error)")
             promise(.failure(URLError(.badServerResponse)))    // 실패할 경우 에러값 publisher 반환
           }
        }, receiveValue: { data in
          promise(.success(data))
        })
    }
    .eraseToAnyPublisher()
  }
}
