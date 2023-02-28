//
//  ViewController.swift
//  PreOnboarding
//
//  Created by 이택성 on 2023/02/25.
//

import UIKit

class ViewController: UIViewController {
  let collectionView: UICollectionView = {
    let layout = UICollectionViewLayout()
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.isScrollEnabled = false
    cv.showsVerticalScrollIndicator = false
    return cv
  }()
  
  let loadAllButton: UIButton = {
    let button = UIButton()
    button.setTitle("Load All Images", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .systemBlue
    button.layer.cornerRadius = 20
    return button
  }()

  var viewModel = ViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.view.backgroundColor = .systemBackground
    addViews()
    setupLayout()
    loadAllButton.addTarget(self, action: #selector(loadAllImage), for: .touchUpInside)
    createCell()
  }


  
  private func addViews() {
    self.view.addSubview(collectionView)
    self.view.addSubview(loadAllButton)
    collectionView.register(MainCell.self, forCellWithReuseIdentifier: MainCell.identifier)
  }
  
  private func setupLayout() {
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    loadAllButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
      collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
      collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      
      loadAllButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      loadAllButton.widthAnchor.constraint(equalToConstant: 280),
      loadAllButton.heightAnchor.constraint(equalToConstant: 60),
      loadAllButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
    ])
    
    collectionView.collectionViewLayout = createContentLayout()
  }
  
  
  private func createContentLayout() -> UICollectionViewLayout {
    let layout: UICollectionViewCompositionalLayout = {
      let itemSpacing: CGFloat = 10
      let width: CGFloat = 1.0
      let height: CGFloat = 1.0 / 6.0
      
      // item
      let itemSize = NSCollectionLayoutSize (
        widthDimension: .fractionalWidth(width),
        heightDimension: .fractionalHeight(1)
      )
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      item.contentInsets = NSDirectionalEdgeInsets(top: itemSpacing, leading: itemSpacing, bottom: itemSpacing, trailing: itemSpacing)
      
      // Group
      let groupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .fractionalHeight(height)
      )
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      
      // Section
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = NSDirectionalEdgeInsets(top: itemSpacing, leading: itemSpacing, bottom: itemSpacing, trailing: itemSpacing)
      
      return UICollectionViewCompositionalLayout(section: section)
    }()
    
    return layout
  }
  
  
  
  func createCell() {
    // ViewModel에서 변화된 DataSource에 따라 Cell에 적용
    viewModel.diffableDataSource = CollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCell", for: indexPath) as? MainCell else { return UICollectionViewCell() }
      
      cell.loadButton.tag = indexPath.row
      cell.loadButton.addTarget(self, action: #selector(self.loadImage), for: .touchUpInside)
      cell.imageInfo = itemIdentifier
      
      return cell
    })
    
    // 초기 CollectionView 레이아웃
    let numOfCell = (0..<4).map{ Image(id: String($0)) }
    viewModel.snapshot.appendSections([0])
    viewModel.snapshot.appendItems(numOfCell, toSection: 0)
    viewModel.diffableDataSource.apply(viewModel.snapshot, animatingDifferences: false)
  }
  
  
  @objc private func loadImage(sender: UIButton) {
    viewModel.initSnapshotImage(at: sender.tag)
    viewModel.fetchImage(id: ImageId(rawValue: sender.tag) ?? .none)
  }

  
  @objc private func loadAllImage() {
    viewModel.fetchAllImages(count: 4)
  }
}

