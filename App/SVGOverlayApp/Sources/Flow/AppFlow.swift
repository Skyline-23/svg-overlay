//
//  AppFlow.swift
//  SVGOverlayApp
//
//  Created by 김부성 on 2022/07/05.
//  Copyright © 2022 com.skyline-23. All rights reserved.
//

import UIKit

import RxFlow
import Swinject

final class AppFlow: Flow {
  
  private let window: UIWindow
  
  var root: Presentable {
    return self.window
  }
  
  var container: Container
  
  init(window: UIWindow, container: Container) {
    self.window = window
    self.container = container
  }
  
  func navigate(to step: Step) -> FlowContributors {
    guard let step = step as? OverlayStep else { return .none }
    
    switch step {
    case .photoPickerIsRequired:
      return navigateToPhotoPicker()
      
    default:
      return .none
      
    }
  }
  
}

extension AppFlow {
  
  private func navigateToPhotoPicker() -> FlowContributors {
    let mainFlow = MainFlow(container: self.container)
    
    Flows.use(mainFlow, when: .created) { [unowned self] root in
      self.window.rootViewController = root
      
      UIView.transition(with: self.window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
      
    }
    
    return .one(flowContributor: .contribute(withNextPresentable: mainFlow, withNextStepper: OneStepper(withSingleStep: OverlayStep.photoPickerIsRequired)));
  }
  
}
import Foundation
