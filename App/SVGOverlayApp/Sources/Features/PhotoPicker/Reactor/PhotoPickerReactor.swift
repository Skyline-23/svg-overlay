//
//  PhotoPickerReactor.swift
//  SVGOverlayApp
//
//  Created by 김부성 on 2022/07/04.
//  Copyright © 2022 com.skyline-23. All rights reserved.
//

import UIKit
import Photos

import ReactorKit
import RxRelay
import RxFlow
import RxDataSources
import Swinject

import SVGOverlayKit

final class PhotoPickerReactor: Reactor {
  
  typealias ImageSectionModel = AnimatableSectionModel<String, PHAsset>
  typealias AlbumSectionModel = AnimatableSectionModel<String, AlbumCover>
  
  let initialState: State
  let container: Container
  
  enum Action {
    case fetchAlbum
    case chooseAlbum(Int)
  }
  
  enum Mutation {
    case updateAlbum([Album])
    case updateCurrentAlbum(Int)
  }
  
  struct State {
    var albumIndex: Int = 0
    var album: [Album] = []
    var title: String? = .init()
    var imageSection: [ImageSectionModel] = []
    var albumSection: [AlbumSectionModel] = []
  }
  
  var photoLibService: PhotoLibServiceType?
  init(container: Container) {
    self.initialState = State()
    self.container = Container(parent: container)
    self.photoLibService = self.container.resolve(PhotoLibServiceType.self)
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .chooseAlbum(index):
      return Observable.just(.updateCurrentAlbum(index))
      
    case .fetchAlbum:
      guard let photoLibService = photoLibService else { return .empty() }
      return photoLibService.fetchListAlbums()
        .map { Mutation.updateAlbum($0) }
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case var .updateAlbum(album):
      album = album.filter { $0.asset.firstObject != nil }
      state.album = album
      state.title = album[state.albumIndex].name
      
      // update for tableView
      state.albumSection = [AlbumSectionModel(
        model: "",
        items: zip(album.compactMap { $0.name }, album.map { $0.asset.firstObject })
          .map { AlbumCover(name: $0, coverAsset: $1) }
      )]
      
      // update for collectionView
      let result = album[state.albumIndex].asset
      let indexSet = IndexSet(integersIn: 0..<result.count)
      state.imageSection = [ImageSectionModel(
        model: "",
        items: result.objects(at: indexSet)
      )]
      
    case let .updateCurrentAlbum(index):
      state.albumIndex = index
      state.title = state.album[index].name
      let result = state.album[index].asset
      let indexSet = IndexSet(integersIn: 0..<result.count)
      state.imageSection = [ImageSectionModel(
        model: "",
        items: result.objects(at: indexSet)
      )]
    }
    return state
  }
  
}
