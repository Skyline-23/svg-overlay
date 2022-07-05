//
//  SVGSelectCollectionViewCell.swift
//  SVGOverlayUI
//
//  Created by 김부성 on 2022/07/05.
//  Copyright © 2022 com.skyline-23. All rights reserved.
//

import UIKit

import Then
import PinLayout

public final class SVGSelectCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Const
  fileprivate struct Metric {
    static let imageInset: CGFloat = 12
  }
  
  // MARK: - UI
  public let assetImageView: UIImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  
  // MARK: - Initializing
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.layer.borderColor = UIColor.black.cgColor
    self.layer.borderWidth = 1
    self.clipsToBounds = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycle
  override public func prepareForReuse() {
    super.prepareForReuse()
    self.assetImageView.image = nil
  }
  
  override public func layoutSubviews() {
    // add subview on contentView to use touch responder chain
    self.contentView.addSubview(assetImageView)
    
    self.assetImageView.pin
      .all(Metric.imageInset)
  }
  
}
