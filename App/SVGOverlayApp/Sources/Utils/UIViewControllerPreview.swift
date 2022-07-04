//
//  UIViewControllerPreview.swift
//  SocarAssignmentApp
//
//  Created by 김부성 on 2022/06/07.
//  Copyright © 2022 com.skyline-23. All rights reserved.
//

#if canImport(SwiftUI) && DEBUG
import SwiftUI

extension UIViewController {
  
  private struct Preview: UIViewControllerRepresentable {
    let viewController: UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
      return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
    
  }
  
  func showPreview(_ deviceType: DeviceType = .iPhone13Pro) -> some View {
    Preview(viewController: self).previewDevice(PreviewDevice(rawValue: deviceType.name()))
  }
  
}
#endif
