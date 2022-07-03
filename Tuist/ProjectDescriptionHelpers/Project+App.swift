//
//  Project+App.swift
//  ProjectDescriptionHelpers
//
//  Created by 김부성 on 2022/07/04.
//

import ProjectDescription

extension Project {
  public static func appTarget(
    name: String,
    appDependencies: [TargetDependency],
    testDependencies: [TargetDependency]
  ) -> [Target] {
    let infoPlist: [String: InfoPlist.Value] = [
      "CFBundleShortVersionString": "1.0",
      "CFBundleVersion": "1",
      "UILaunchStoryboardName": "LaunchScreen",
      "NSAppTransportSecurity" : ["NSAllowsArbitraryLoads":true],
      "UISupportedInterfaceOrientations" : ["UIInterfaceOrientationPortrait"],
      "UIUserInterfaceStyle":"Light",
      "NSLocationWhenInUseUsageDescription":"This application requires location services to work",
      "UIApplicationSceneManifest" : ["UIApplicationSupportsMultipleScenes":true,
                                      "UISceneConfigurations":[
                                        "UIWindowSceneSessionRoleApplication":[[
                                          "UISceneConfigurationName":"Default Configuration",
                                          "UISceneDelegateClassName":"$(PRODUCT_MODULE_NAME).SceneDelegate"
                                        ]]
                                      ]
                                     ]
    ]
    
    let sources = Target(
      name: name,
      platform: .iOS,
      product: .app,
      bundleId: "com.skyline-23.\(name)",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: [.iphone, .ipad]),
      infoPlist: .extendingDefault(with: infoPlist), // 기본 info.plist 파일 생성
      sources: .sources, // 소스파일 path
      resources: .resources(with: [.assets, .storyboards]), // 리소스파일 path
      dependencies: appDependencies // 앱 의존성
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
