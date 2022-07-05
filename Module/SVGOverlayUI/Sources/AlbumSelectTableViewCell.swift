//
//  AlbumSelectTableViewCell.swift
//  SVGOverlayUI
//
//  Created by 김부성 on 2022/07/04.
//  Copyright © 2022 com.skyline-23. All rights reserved.
//

import Photos
import UIKit
import Then

import PinLayout

public final class AlbumSelectTableViewCell: UITableViewCell {
  
  private let cacheManager = PHCachingImageManager()
  
  // MARK: - Const
  fileprivate struct Metric {
    static let cornerRadius: CGFloat = 8
    static let albumImageSize: CGFloat = 64
    static let imageLeft: CGFloat = 15
    static let titleAfter: CGFloat = 10
  }
  
  // MARK: - UI
  public let albumImageView: UIImageView = UIImageView().then {
    $0.backgroundColor = .lightGray
    $0.image = UIImage.init(systemName: "photo.on.rectangle")
    $0.tintColor = .gray
    $0.contentMode = .scaleAspectFit
  }
  public let albumTitleLabel: UILabel = UILabel()
  
  
  // MARK: - Initializing
  override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.albumImageView.layer.cornerRadius = Metric.cornerRadius
    self.albumImageView.clipsToBounds = true
    
    self.albumTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycle
  override public func prepareForReuse() {
    super.prepareForReuse()
    self.albumImageView.image = UIImage.init(systemName: "photo.on.rectangle")
    self.albumImageView.contentMode = .scaleAspectFit
    self.albumTitleLabel.text = ""
  }
  
  override public func layoutSubviews() {
    // add subview on contentView to use touch responder chain
    [
      albumImageView,
      albumTitleLabel
    ].forEach { self.contentView.addSubview($0) }
    
    self.albumImageView.pin
      .vCenter()
      .size(Metric.albumImageSize)
      .left(Metric.imageLeft)
    
    self.albumTitleLabel.pin
      .vCenter()
      .sizeToFit()
      .after(of: albumImageView).margin(Metric.titleAfter)
  }
  
  public func loadImage(asset: PHAsset) {
    let size = CGSize(width: self.frame.width * UIScreen.main.scale, height: self.frame.height * UIScreen.main.scale)
    self.cacheManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: nil) { [weak self] image, _ in
      self?.albumImageView.contentMode = .scaleAspectFill
      self?.albumImageView.image = image
    }
  }
}
