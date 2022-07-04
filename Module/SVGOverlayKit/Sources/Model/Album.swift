//
//  Album.swift
//  SVGOverlayKit
//
//  Created by 김부성 on 2022/07/04.
//  Copyright © 2022 com.skyline-23. All rights reserved.
//

import Foundation
import Photos

public struct Album {
  public let name: String?
  public let asset: PHFetchResult<PHAsset>
}

public struct AlbumCover: Equatable {
  public let name: String
  public let coverAsset: PHAsset?
  
  public init(name: String, coverAsset: PHAsset?) {
    self.name = name
    self.coverAsset = coverAsset
  }
}
