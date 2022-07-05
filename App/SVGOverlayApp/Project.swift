import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "SVGOverlayApp",
  organizationName: "com.skyline-23",
  packages: [
    .rxDataSources,
    .reactorKit,
    .rxFlow,
    .then,
    .rxGesture,
    .swinject,
  ],
  settings: .settings(
    base: [
      "MARKETING_VERSION": "1.0"
    ],
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
  targets: Project.appTarget(
    name: "SVGOverlayApp",
    appDependencies: [
      .project(target: "SVGOverlayKit", path: .relativeToRoot("Module/SVGOverlayKit")),
      .project(target: "SVGOverlayUI", path: .relativeToRoot("Module/SVGOverlayUI")),
      .rxDataSources,
      .reactorKit,
      .rxFlow,
      .then,
      .rxGesture,
      .swinject,
    ],
    testDependencies: []
  ),
  schemes: [],
  additionalFiles: []
)
