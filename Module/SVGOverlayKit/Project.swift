import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "SVGOverlaytKit",
  organizationName: "com.skyline-23",
  packages: [
    .rxSwift,
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
    name: "SVGOverlayKit",
    frameworkDepencies: [
      .rxSwift,
    ],
    testDependencies: []
  ),
  schemes: [],
  additionalFiles: []
)
