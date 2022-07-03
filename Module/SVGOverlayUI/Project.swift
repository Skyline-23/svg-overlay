import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "SVGOverlayUI",
  organizationName: "com.skyline-23",
  packages: [
    .snapKit,
    .rxSwift,
    .rxKingfisher,
    .pinLayout,
  ],
  settings: .settings(
    base: [:],
    configurations: [
      .debug(
        name: "Alpha",
        settings: SettingsDictionary().swiftCompilationMode(.singlefile),
        xcconfig: .relativeToRoot("Configurations/Alpha.xcconfig")
      ),
      .release(
        name: "Production",
        settings: SettingsDictionary().swiftCompilationMode(.wholemodule),
        xcconfig: .relativeToRoot("Configurations/Production.xcconfig")
      )
    ],
    defaultSettings: .recommended
  ),
  targets: Project.staticFameworkTarget(
    name: "SVGOverlayUI",
    frameworkDepencies: [
      .snapKit,
      .rxSwift,
      .rxCocoa,
      .rxKingfisher,
      .pinLayout,
    ],
    testDependencies: []
  ),
  schemes: [],
  additionalFiles: []
)
