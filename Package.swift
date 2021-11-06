// swift-tools-version:5.5.0
import PackageDescription

let package = Package(
        name: "scc",
        platforms: [.macOS(.v12)],
        products: [
                .executable(name: "scc", targets: ["Compiler"]),
        ],
        dependencies: [
                .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
                .package(url: "https://github.com/casually-blue/LLVMSwift", from: "0.8.1"),
        ],
        targets: [
                .executableTarget(
                        name: "Compiler",
                        dependencies: [
                                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                                .product(name: "LLVM", package: "LLVMSwift"),
                        ]
                        )
])
