//
//  MainCell.swift
//  PreOnboarding
//
//  Created by 이택성 on 2023/02/25.
//

import UIKit

class CollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<Int, Int> { }

class MainCell: UICollectionViewCell {
  static let identifier = "MainCell"
  
  let image: UIImageView = {
    let image = UIImageView()
    image.image = UIImage(systemName: "photo")
    return image
  }()
  
  let loadButton: UIButton = {
    let button = UIButton()
    button.setTitle("Load", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .blue
    button.layer.cornerRadius = 20
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addViews()
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addViews() {
    self.addSubview(image)
    self.addSubview(loadButton)
  }
  
  private func setupLayout() {
    image.translatesAutoresizingMaskIntoConstraints = false
    loadButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      image.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      image.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
      image.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10),
      image.widthAnchor.constraint(equalTo: self.image.heightAnchor, multiplier: 1.2),
      
      loadButton.heightAnchor.constraint(equalToConstant: 40),
      loadButton.widthAnchor.constraint(equalToConstant: 120),
      loadButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10)
    ])
  }
}
