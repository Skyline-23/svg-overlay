//
//  PHFetchResult + Extension.swift
//  SVGOverlayKit
//
//  Created by 김부성 on 2022/07/04.
//  Copyright © 2022 com.skyline-23. All rights reserved.
//

import Photos

extension PHFetchResult where ObjectType == PHAssetCollection {
  func toAlbumArray() -> [Album] {
    var album:[Album] = [Album]()
    
    self.enumerateObjects{ (object: AnyObject!, count: Int, stop: UnsafeMutablePointer) in
      if object is PHAssetCollection {
        let obj:PHAssetCollection = object as! PHAssetCollection
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        
        let newAlbum = Album(name: obj.localizedTitle, asset: PHAsset.fetchAssets(in: obj, options: nil))
        album.append(newAlbum)
      }
    }
    
    return album
  }
}
