//
//  OverlayStep.swift
//  SVGOverlayApp
//
//  Created by 김부성 on 2022/07/05.
//  Copyright © 2022 com.skyline-23. All rights reserved.
//

import RxFlow
import Photos

enum OverlayStep: Step {
  case dismiss
  
  case photoPickerIsRequired
  case overlayIsRequired(PHAsset)
}
