//
//  AlbumSelectTableViewCell.swift
//  SVGOverlayUI
//
//  Created by 김부성 on 2022/07/04.
//  Copyright © 2022 com.skyline-23. All rights reserved.
//

import UIKit
import PinLayout

public final class AlbumSelectTableViewCell: UITableViewCell {
  
  // MARK: - Const
  fileprivate struct Metric {
    static let cornerRadius: CGFloat = 8
    static let albumImageSize: CGFloat = 64
  }
  
  // MARK: - UI
  public let albumImageView: UIImageView = UIImageView()
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
  override public func layoutSubviews() {
    // add subview on contentView to use touch responder chain
    [
      albumImageView,
      albumTitleLabel
    ].forEach { self.contentView.addSubview($0) }
    
    self.albumImageView.pin
      .vCenter()
      .size(Metric.albumImageSize)
    
    self.albumTitleLabel.pin
      .vCenter()
      .sizeToFit()
      .after(of: albumImageView).margin(10)
  }
}
