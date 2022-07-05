//
//  OverlayReactor.swift
//  SVGOverlayApp
//
//  Created by 김부성 on 2022/07/05.
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

final class OverlayReactor: Reactor {
  
  typealias ImageSectionModel = AnimatableSectionModel<String, UIImage>
  
  let initialState: State
  
  enum Action {
    case chooseSVG(Int)
  }
  
  enum Mutation {
    case updateIndex(Int)
  }
  
  struct State {
    var selectedIndex: Int = 0
    var backgroundImage: PHAsset
    var selectedImage: UIImage? = nil
    var imageSection: [ImageSectionModel] = [ImageSectionModel(
      model: "",
      items: [
        SVGOverlayAppAsset._001,
        SVGOverlayAppAsset._002,
        SVGOverlayAppAsset._003,
        SVGOverlayAppAsset._004,
        SVGOverlayAppAsset._005,
        SVGOverlayAppAsset._006,
        SVGOverlayAppAsset._007,
        SVGOverlayAppAsset._008,
        SVGOverlayAppAsset._009,
        SVGOverlayAppAsset._010,
        SVGOverlayAppAsset._011,
        SVGOverlayAppAsset._012,
        SVGOverlayAppAsset._013,
        SVGOverlayAppAsset._014
      ].map { $0.image })]
  }
  
  init(image: PHAsset) {
    self.initialState = State(backgroundImage: image)
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .chooseSVG(index):
      return .just(Mutation.updateIndex(index))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .updateIndex(index):
      state.selectedIndex = index
      state.selectedImage = state.imageSection.first?.items[index]
    }
    return state
  }
  
}
