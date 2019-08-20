// swift-tools-version:4.2
// swift-tools-version declares minimum Swift version to build this package.
// Syntax: '// swift-tools-version:<specifier>' on the 1st line. (4.2|5.0)
import PackageDescription

let package = Package(
    name: "OSKWebUI",
    dependencies: [
        // A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),

        // An expressive, performant, and extensible templating language built for Swift.
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.0"),
        
        // OSK Gadget Bridge
        .package(url: "git@github.com:opensmartkitchen/OSK-Bridge-Mock.git", .branch("master") ),
    ],
    targets: [
        .target(name: "App", dependencies: ["Leaf", "Vapor", "OskGadgetCWrapMock"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ],
    swiftLanguageVersions: [.v4_2] // [.v4_2, .v5]
)
