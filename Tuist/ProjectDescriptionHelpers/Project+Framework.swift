//
//  Project+Framework.swift
//  ProjectDescriptionHelpers
//
//  Created by 김부성 on 2022/07/04.
//

import ProjectDescription

extension Project {
  
  public static func staticFameworkTarget(
    name: String,
    frameworkDepencies: [TargetDependency],
    testDependencies: [TargetDependency]
  ) -> [Target] {
    let sources = Target(
      name: name,
      platform: .iOS,
      product: .staticFramework,
      bundleId: "com.skyline-23.\(name)",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: [.iphone, .ipad]),
      infoPlist: .default, // 기본 info.plist 파일 생성
      sources: .sources, // 소스파일 path
      resources: [], // 리소스파일 path
      dependencies: frameworkDepencies // 프레임워크 의존성
    )
    
    let tests = Target(
      name: "\(name)Tests",
      platform: .iOS,
      product: .unitTests,
      bundleId: "com.skyline-23.\(name)Tests",
      infoPlist: .default, // 기본 info.plist 파일 생성
      sources: .tests, // 소스파일 path
      resources: [],
      dependencies: [.target(name: name)] + testDependencies // 의존성에 앱 타겟과 추가 의존성 반영
    )
    return [sources, tests]
  }
}
