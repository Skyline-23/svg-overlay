//
//  CGImage+Extension.swift
//  SVGOverlayUI
//
//  Created by 김부성 on 2022/07/05.
//  Copyright © 2022 com.skyline-23. All rights reserved.
//

import UIKit

import Then

extension CIImage {
  func resize(scale: CGFloat, completionHandler: (CIImage?) -> Void) {
    let filter = CIFilter(name: "CILanczosScaleTransform")?.then {
      $0.setValue(self, forKey: kCIInputImageKey)
      $0.setValue(scale, forKey: kCIInputScaleKey)
      $0.setValue(1.0, forKey: kCIInputAspectRatioKey)
    }
    let resultImage = filter?.outputImage
    completionHandler(resultImage)
  }
}
