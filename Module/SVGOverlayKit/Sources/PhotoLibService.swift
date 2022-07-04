//
//  PhotoLibService.swift
//  SVGOverlayKit
//
//  Created by 김부성 on 2022/07/04.
//  Copyright © 2022 com.skyline-23. All rights reserved.
//

import Foundation
import Photos
import UIKit

public protocol PhotoLibServiceType: AnyObject {
  /// 사진 앱 권한
  func requestPhotosPermission() -> PHAuthorizationStatus
  /// 사진앱 변경됨
  func registerPhotoLibrary(target: PHPhotoLibraryChangeObserver)
  func getAlbumImage(index i: Int) -> PHFetchResult<PHAsset>
  func getAlbumString(index i: Int) -> String
  func getAlbumCount() -> Int
}

/// Photo Service Class
/// 모든 PhotoKit과 관련된 작업들은 여기에서 이루어집니다.
///

public final class PhotoLibService: PhotoLibServiceType {
  
  fileprivate let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
  
  public func requestPhotosPermission() -> PHAuthorizationStatus {
    return PHPhotoLibrary.authorizationStatus()
  }
  
  public func registerPhotoLibrary(target: PHPhotoLibraryChangeObserver) {
    PHPhotoLibrary.shared().register(target)
  }
  
  public func getAlbumImage(index i: Int) -> PHFetchResult<PHAsset> {
    let fetchOption = PHFetchOptions()
    fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    
    let album = self.cameraRoll.object(at: i)
    return PHAsset.fetchAssets(in: album, options: fetchOption)
  }
  
  public func getAlbumString(index i: Int) -> String {
    return self.cameraRoll.object(at: i).localizedTitle ?? ""
  }
  
  public func getAlbumCount() -> Int {
    return self.cameraRoll.count
  }
  
  
}
