//
//  IdentifiableType+Extension.swift
//  SVGOverlayApp
//
//  Created by 김부성 on 2022/07/05.
//  Copyright © 2022 com.skyline-23. All rights reserved.
//

import SVGOverlayKit
import Photos

import Differentiator

extension PHAsset: IdentifiableType {
  public var identity: String {
    return self.localIdentifier
  }
}

extension AlbumCover: IdentifiableType {
  public var identity: String {
    return self.name
  }
}
