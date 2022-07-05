//
//  OverlayBlackButton.swift
//  SVGOverlayUI
//
//  Created by 김부성 on 2022/07/05.
//  Copyright © 2022 com.skyline-23. All rights reserved.
//

import UIKit

public final class OverlayBlackButton: UIButton {
  
  // MARK: - Constants
  
  // MARK: - UI
  
  // MARK: - Initializing
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycle
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    self.clipsToBounds = true
    self.setTitleColor(.white, for: .normal)
    self.backgroundColor = .black
  }
  
}
