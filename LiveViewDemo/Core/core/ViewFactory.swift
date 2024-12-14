//
//  File.swift
//  
//
//  Created by Apple on 13/12/2024.
//

import Foundation
import SwiftUI
import UIKit


public protocol ViewInput {
    
}

// Define a custom Environment Key for ViewFactory
public struct ViewFactoryKey: EnvironmentKey {
    static public let defaultValue: ViewFactory = ViewFactory() // Default value if not provided
}

// Extend the EnvironmentValues to include the viewFactory
public extension EnvironmentValues {
    var viewFactory: ViewFactory {
        get { self[ViewFactoryKey.self] }
        set { self[ViewFactoryKey.self] = newValue }
    }
}

public class ViewFactory: ObservableObject {
    public var isPreview: Bool {
        if let xcPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] {
            return xcPreview == "1"
        }
        return false
    }
    public func swiftUI<I: ViewInput>(input: I) -> AnyView {
        AnyView(Text("Override this function for extensibility"))
    }
    public func uiKit<I: ViewInput>(input: I) -> UIViewController {
        fatalError("Override this function for extensibility")
    }
}
