//
//  MainFlow.swift
//  SVGOverlayApp
//
//  Created by 김부성 on 2022/07/05.
//  Copyright © 2022 com.skyline-23. All rights reserved.
//

import UIKit

import RxFlow
import Swinject

import SVGOverlayKit
import Photos

final class MainFlow: Flow {
  
  var root: Presentable {
    return self.rootViewController
  }
  
  fileprivate let container: Container
  
  let navigationAppearance:UINavigationBarAppearance = {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithTransparentBackground()
    return appearance
  }()
  
  private lazy var rootViewController: UINavigationController = {
    let navigationController = UINavigationController()
    navigationController.navigationBar.standardAppearance = navigationAppearance
    navigationController.navigationBar.isHidden = true
    return navigationController
  }()
  
  init(container: Container) {
    self.container = container
  }
  
  func navigate(to step: Step) -> FlowContributors {
    guard let step = step as? OverlayStep else { return .none }
    
    switch step {
    case .photoPickerIsRequired:
      return navigateToPhotoPicker()
      
    case let .overlayIsRequired(asset):
      return presentOverlay(asset: asset)
      
    case .dismiss:
      self.rootViewController.dismiss(animated: true, completion: nil)
      return .none
      
    default:
      return .none
    }
  }
  
}

extension MainFlow {
  private func navigateToPhotoPicker() -> FlowContributors {
    let reactor = PhotoPickerReactor(container: self.container)
    let viewController = PhotoPickerViewController(reactor: reactor)
      
    self.rootViewController.pushViewController(viewController, animated: false)
    
    return .one(flowContributor: .contribute(withNext: viewController))
  }
  
  private func presentOverlay(asset: PHAsset) -> FlowContributors {
    let reactor = OverlayReactor(image: asset)
    let viewController = OverlayViewController(reactor: reactor)
      
    viewController.modalPresentationStyle = .overFullScreen
    self.rootViewController.present(viewController, animated: true)
    
    return .one(flowContributor: .contribute(withNext: viewController))
  }
}
