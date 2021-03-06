import ProjectDescription

public extension TargetDependency {
  // Application
  static let rxSwift: TargetDependency = .package(product: "RxSwift")
  static let rxCocoa: TargetDependency = .package(product: "RxCocoa")
  static let rxFlow: TargetDependency = .package(product: "RxFlow")
  static let rxDataSources: TargetDependency = .package(product: "RxDataSources")
  static let reactorKit: TargetDependency = .package(product: "ReactorKit")
  static let then: TargetDependency = .package(product: "Then")
  static let swinject: TargetDependency = .package(product: "Swinject")
  
  // UI
  static let snapKit: TargetDependency = .package(product: "SnapKit")
  static let pinLayout: TargetDependency = .package(product: "PinLayout")
  static let rxGesture: TargetDependency = .package(product: "RxGesture")
}

public extension Package {
  static let rxSwift: Package = .package(
    url: "https://github.com/ReactiveX/RxSwift.git",
    .upToNextMajor(from: "6.0.0")
  )
  
  static let reactorKit: Package = .package(
    url: "https://github.com/ReactorKit/ReactorKit.git",
    .upToNextMajor(from: "3.2.0")
  )
  
  static let rxFlow: Package = .package(
    url: "https://github.com/RxSwiftCommunity/RxFlow.git",
    .upToNextMajor(from: "2.11.0")
  )
  
  static let rxDataSources: Package = .package(
    url: "https://github.com/RxSwiftCommunity/RxDataSources.git",
    .upToNextMajor(from: "5.0.0")
  )
  
  static let then: Package = .package(
    url: "https://github.com/devxoul/Then.git",
    .branch("master")
  )
  
  static let swinject: Package = .package(
    url: "https://github.com/Swinject/Swinject.git",
    .branch("master")
  )
  
  // UI
  static let snapKit: Package = .package(
    url: "https://github.com/SnapKit/SnapKit.git",
    .upToNextMajor(from: "5.0.1")
  )
  
  static let pinLayout: Package = .package(
    url: "https://github.com/layoutBox/PinLayout.git",
    .upToNextMajor(from: "1.10.0")
  )
  
  static let rxGesture: Package = .package(
    url: "https://github.com/RxSwiftCommunity/RxGesture.git",
    .branch("main")
  )
}

// MARK: SourceFile
public extension SourceFilesList {
  static let sources: SourceFilesList = "Sources/**"
  static let tests: SourceFilesList = "Tests/**"
}

// MARK: Resource
public enum ResourceType: String {
  case xibs = "Sources/**/*.xib"
  case storyboards = "Resources/**/*.storyboard"
  case assets = "Resources/**"
}

// MARK: Extension
fileprivate extension Array where Element == ResourceFileElement {
  static func resources(with resources: [ResourceType]) -> [ResourceFileElement] {
    resources.map { ResourceFileElement(stringLiteral: $0.rawValue) }
  }
}

public extension ResourceFileElements {
  static func resources(with resources: [ResourceType]) -> ResourceFileElements {
    ResourceFileElements.init(resources: .resources(with: resources))
  }
}
