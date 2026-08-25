// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "TaskCancellationDemo",
    platforms: [.macOS(.v13)],
    targets: [.executableTarget(name: "TaskCancellationDemo")]
)
