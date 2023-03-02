//
//  ViewModel.swift
//  PreOnboarding
//
//  Created by 이택성 on 2023/02/25.
//

import UIKit
import Combine

class CollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<Int, Image> { }

class ViewModel {
  var cancellables = Set<AnyCancellable>()  
  var diffableDataSource: CollectionViewDiffableDataSource!
  var snapshot = NSDiffableDataSourceSnapshot<Int, Image>()

  
  func fetchImage(id: ImageId) {
    APIService.shared.fetchImages(id: id)
      .print("[viewModel fetchImage]")
      .sink { completion in
        switch completion {
        case .finished:
          print("[ViewModel searchMovies] finished")
        case .failure:
          print("[ViewModel searchMovies] failure")
        }
      } receiveValue: { [unowned self] image in
        DispatchQueue.main.async {
          self.insertSnapshotItem(at: id.rawValue, item: image)
        }
      }
      .store(in: &cancellables)
  }
  
  func fetchAllImages(count: Int) {
    // 이미지 초기화
    initAllSnapshot()
    
    let publishers: [AnyPublisher<Image, Error>] = (0..<count).map { APIService.shared.fetchImages(id: ImageId(rawValue: $0) ?? .none) }
    
    
    Publishers.MergeMany(publishers)
      .print("[viewModel fetchAllImages]")
      .sink { completion in
        switch completion {
        case .finished:
          print("[ViewModel fetchAllImages] finished")
        case .failure:
          print("[ViewModel fetchAllImages] failure")
        }
      } receiveValue: { [unowned self] imageData in
        // 해당 데이터를 업데이트 할 cell의 index를 구함
        var index: ImageId = .none
        ImageId.allCases.forEach{
          if $0.getId().contains(imageData.id) {
            index = $0
          }
        }
        DispatchQueue.main.async {
          self.insertSnapshotItem(at: index.rawValue, item: imageData)
        }
      }
      .store(in: &cancellables)
  }
  
  // 해당 스냅샷의 이미지 데이터 초기화
  func initSnapshotImage(at index: Int) {
    insertSnapshotItem(at: index, item: Image())
  }
  
  
  // 해당 인덱스의 Snapshot 변경
  func insertSnapshotItem(at index: Int, item: Image) {
    let currentItem = self.snapshot.itemIdentifiers[index]
    if currentItem.id != item.id {
      self.snapshot.insertItems([item], beforeItem: currentItem)
      self.snapshot.deleteItems([currentItem])
      self.diffableDataSource.apply(self.snapshot, animatingDifferences: false)
    }
  }
  
  func initAllSnapshot() {
    self.snapshot.deleteAllItems()
    // 초기 CollectionView 레이아웃
    let numOfCell = (0..<4).map{ Image(id: String($0)) }
    self.snapshot.appendSections([0])
    self.snapshot.appendItems(numOfCell, toSection: 0)
    self.diffableDataSource.apply(self.snapshot, animatingDifferences: false)
  }
}

