//
//  ViewModel.swift
//  PreOnboarding
//
//  Created by 이택성 on 2023/02/25.
//

import UIKit
import Combine

class ViewModel {
  var cancellables = Set<AnyCancellable>()
  @Published var id: ImageId = .none
  
  var diffableDataSource: CollectionViewDiffableDataSource!
  var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
  
  init() {
    $id
      .receive(on: RunLoop.main)
      .sink { (_) in
        self.fetchImage()
      }.store(in: &cancellables)
  }


  func fetchImage() {
    APIService.shared.fetchImages(id: id)
      .print("viewModel fetchImage")
      .sink { completion in
        switch completion {
        case .finished:
          print("ViewModel searchMovies finished")
        case .failure:
          print("ViewModel searchMovies failure")
        }
      } receiveValue: { image in
        self.snapshot.deleteAllItems()
        self.snapshot.appendItems([image.url])
        self.diffableDataSource.apply(self.snapshot, animatingDifferences: true)
      }
      .store(in: &cancellables)
  }
  
}

