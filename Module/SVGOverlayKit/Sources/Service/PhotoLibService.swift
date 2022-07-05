//
//  PhotoLibService.swift
//  SVGOverlayKit
//
//  Created by 김부성 on 2022/07/04.
//  Copyright © 2022 com.skyline-23. All rights reserved.
//

import Foundation
import Photos
import RxSwift
import UIKit
import Then

public protocol PhotoLibServiceType: AnyObject {
  /// 사진 앱 권한
  func requestPhotosPermission() -> PHAuthorizationStatus
  func fetchListAlbums() -> Observable<[Album]>
}

/// Photo Service Class
/// 모든 PhotoKit과 관련된 작업들은 여기에서 이루어집니다.
///

open class PhotoLibService: PhotoLibServiceType {
  
  //  private collections
  private var smartAlbums = PHFetchResult<PHAssetCollection>()
  private var userCollections = PHFetchResult<PHAssetCollection>()
  private var manager = PHCachingImageManager()
  
  
  public init() {
    // fetch Albums
    smartAlbums = PHAssetCollection.fetchAssetCollections(
      with: .smartAlbum,
      subtype: .any,
      options: nil)
    userCollections = PHAssetCollection.fetchAssetCollections(
      with: .album,
      subtype: .any,
      options: nil)
  }
  
  public func requestPhotosPermission() -> PHAuthorizationStatus {
    return PHPhotoLibrary.authorizationStatus()
  }
  
  public func fetchListAlbums() -> Observable<[Album]> {
    var album: [Album] = .init()
    
    album.append(contentsOf: smartAlbums.toAlbumArray())
    album.append(contentsOf: userCollections.toAlbumArray())
    
    return Observable.just(album)
  }
  
}
