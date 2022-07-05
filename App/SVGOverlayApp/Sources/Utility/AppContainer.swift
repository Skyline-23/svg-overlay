//
//  AppContainer.swift
//  SVGOverlayApp
//
//  Created by 김부성 on 2022/07/05.
//  Copyright © 2022 com.skyline-23. All rights reserved.
//

import UIKit

import Swinject
import ReactorKit

protocol AppContainer: AnyObject {
  var appDelegate: AppDelegate { get }
  var continer: Container { get }
}

extension AppContainer {
  var appDelegate: AppDelegate { UIApplication.shared.delegate as! AppDelegate }
  var container: Container { appDelegate.container }
}
