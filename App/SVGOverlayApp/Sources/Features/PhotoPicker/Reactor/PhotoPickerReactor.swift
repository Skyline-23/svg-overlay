//
//  PhotoPickerReactor.swift
//  SVGOverlayApp
//
//  Created by 김부성 on 2022/07/04.
//  Copyright © 2022 com.skyline-23. All rights reserved.
//


import Foundation
import ReactorKit
import RxRelay
import RxFlow
import RxDataSources
import SVGOverlayKit
import Photos

final class PhotoPickerReactor: Reactor {
  
  typealias ImageSectionModel = AnimatableSectionModel<String, PHAsset>
  typealias AlbumSectionModel = AnimatableSectionModel<String, AlbumCover>
  
  let initialState: State
  
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
  
  let photoService: PhotoLibServiceType = PhotoLibService()
  init() {
    self.initialState = State()
  }
  
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .chooseAlbum(index):
      return Observable.just(.updateCurrentAlbum(index))
      
    case .fetchAlbum:
      return photoService.fetchListAlbums()
        .map { Mutation.updateAlbum($0) }
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .updateAlbum(album):
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
