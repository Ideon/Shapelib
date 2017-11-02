// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(    
    name: "Shapelib",
    products: [        
        .executable(name: "tool", targets: ["tool"]),
        .library(name: "Shapelib", targets: ["Shapelib"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Ideon/Cshapelib", .branch("master"))
    ],
    targets: [
        .target(name: "tool", dependencies: ["Shapelib"]),
        .target(name: "Shapelib", dependencies: []),
        .testTarget(name: "ShapelibTests", dependencies: ["Shapelib"])
    ]
)
