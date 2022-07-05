//
//  HapticFeedback.swift
//  SVGOverlayKit
//
//  Created by 김부성 on 2022/07/05.
//  Copyright © 2022 com.skyline-23. All rights reserved.
//

import UIKit

public final class HapticFeedback {
  
  /**
   충격이 발생했음을 나타내기위한 햅틱 피드백.
   
   - parameters:
   - style: 피드백 스타일
   */
  public static func impactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.prepare()
    generator.impactOccurred()
  }
  
  /**
   선택 변경을 나타내기위한 햅틱 피드백.
   */
  public static func selectionFeedback() {
    let generator = UISelectionFeedbackGenerator()
    generator.prepare()
    generator.selectionChanged()
  }
  
  /**
   성공, 실패 및 경고를 나타내기위한 햅틱 피드백.
   
   - parameters:
   - type: 피드백 타입
   */
  public static func notificationFeedback(type: UINotificationFeedbackGenerator.FeedbackType) {
    let generator = UINotificationFeedbackGenerator()
    generator.prepare()
    generator.notificationOccurred(type)
  }
  
}
