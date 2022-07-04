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
  
  typealias ImageSectionModel = SectionModel<String, PHAsset>
  
  let initialState: State
  
  enum Action {
    case fetchAlbum
    case chooseAlbum(Int)
  }
  
  enum Mutation {
    case updateAlbum([Album])
  }
  
  struct State {
    var albumIndex: Int = 0
    var album: [Album] = []
    var imageSection: [ImageSectionModel] = []
  }
  
  let photoService: PhotoLibServiceType = PhotoLibService()
  init() {
    self.initialState = State()
  }
  
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .chooseAlbum(index):
      return .empty()
      
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
      let result = album[state.albumIndex].asset
      let indexSet = IndexSet(integersIn: 0..<result.count)
      state.imageSection = [ImageSectionModel(
        model: "",
        items: result.objects(at: indexSet)
      )]
    }
    return state
  }
  
}
