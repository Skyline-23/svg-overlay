//
//  PhotoSelectCollectionViewCell.swift
//  SVGOverlayUI
//
//  Created by 김부성 on 2022/07/04.
//  Copyright © 2022 com.skyline-23. All rights reserved.
//

import UIKit
import PinLayout

public final class PhotoSelectCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Const
  fileprivate struct Metric {
    static let cornerRadius: CGFloat = 16
  }
  
  // MARK: - UI
  public let assetImageView: UIImageView = UIImageView()
  
  
  // MARK: - Initializing
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.layer.cornerRadius = Metric.cornerRadius
    self.clipsToBounds = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycle
  override public func layoutSubviews() {
    // add subview on contentView to use touch responder chain
    self.contentView.addSubview(assetImageView)
    
    self.assetImageView.pin
      .all()
  }
}
