//
//  Environment.swift
//  LiveViewDemo
//
//  Created by Apple on 17/12/2024.
//

import Foundation

class AppEnvironment {
    
    /// Enum representing the application's running environment
    enum Environment {
        case debug
        case release
        case preview
        case unitTest
        case uiTest
        case unknown
    }
    
    /// Returns the current environment
    static var current: Environment {
        #if DEBUG
        return isRunningTests ? .unitTest : (isPreview ? .preview : .debug)
        #elseif RELEASE
        return isRunningTests ? .unitTest : (isPreview ? .preview : .release)
        #else
        if isUITest { return .uiTest }
        if isPreview { return .preview }
        return .unknown
        #endif
    }
    
    /// Checks if the application is running in a test environment
    private static var isRunningTests: Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
    
    /// Checks if the application is running in a UI test environment
    private static var isUITest: Bool {
        return ProcessInfo.processInfo.arguments.contains("UITest")
    }
    private static var isPreview: Bool {
        if let xcPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] {
            return xcPreview == "1"
        }
        return false
    }
    public static var useMockDependencies: Bool {
        self.current != .debug && self.current != .release
    }
}
