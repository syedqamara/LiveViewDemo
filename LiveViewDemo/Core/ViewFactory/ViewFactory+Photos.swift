//
//  ViewFactory+Photos.swift
//  LiveViewDemo
//
//  Created by Apple on 14/12/2024.
//

import Foundation
import SwiftUI

public enum PhotosUIModule: ViewInput {
    case bundle
}

public extension ViewFactory {
    func swiftUI(input: PhotosUIModule) -> AnyView {
        switch input {
        case .bundle:
            return AnyView(
                ExampleBundleLivePhoto<ExampleBundleLiveImageViewModel>()
            )
        }
    }
}
