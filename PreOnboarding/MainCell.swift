//
//  MainCell.swift
//  PreOnboarding
//
//  Created by 이택성 on 2023/02/25.
//

import UIKit

class MainCell: UICollectionViewCell {
  static let identifier = "MainCell"
  
  let imageView: UIImageView = {
    let image = UIImageView()
    image.image = UIImage(systemName: "photo")
    return image
  }()
  
  let progressBar: UIProgressView = {
    let progressBar = UIProgressView()
    progressBar.progress = 0.5
    progressBar.backgroundColor = .blue
    progressBar.trackTintColor = .systemGray
    return progressBar
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
  
  var imageInfo: Image! {
    didSet{
      self.setupData()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addViews() {
    self.addSubview(imageView)
    self.addSubview(progressBar)
    self.addSubview(loadButton)
  }
  
  private func setupLayout() {
    imageView.translatesAutoresizingMaskIntoConstraints = false
    loadButton.translatesAutoresizingMaskIntoConstraints = false
    progressBar.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
      imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
      imageView.widthAnchor.constraint(equalTo: self.imageView.heightAnchor, multiplier: 1.2),
      imageView.centerYAnchor.constraint(equalTo: super.centerYAnchor),
      
      progressBar.heightAnchor.constraint(equalToConstant: 5),
      progressBar.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: 10),
      progressBar.trailingAnchor.constraint(equalTo: self.loadButton.leadingAnchor, constant: -10),
      progressBar.centerYAnchor.constraint(equalTo: super.centerYAnchor),
      
      loadButton.heightAnchor.constraint(equalToConstant: 40),
      loadButton.widthAnchor.constraint(equalToConstant: 120),
      loadButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
      loadButton.centerYAnchor.constraint(equalTo: super.centerYAnchor)
    ])
  }
  
  private func setupData() {
    imageView.image = UIImage(systemName: "photo")
    guard let imageURL = URL(string: imageInfo.download_url) else { return }
    
    URLSession.shared.dataTask(with: imageURL) { data, response, _ in
      guard let imageData = data else { return }
      DispatchQueue.main.async {
        self.imageView.image = UIImage(data: imageData) ?? UIImage(systemName: "photo")
      }
    }.resume()
     
  }

}
