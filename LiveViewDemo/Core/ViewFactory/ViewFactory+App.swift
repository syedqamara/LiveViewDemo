//
//  ViewFactory+App.swift
//  LiveViewDemo
//
//  Created by Apple on 15/12/2024.
//

import Foundation
import SwiftUI

public enum AppUI: ViewInput {
    case alert(AlertContent, Binding<Bool>), loading(String)
}
public extension ViewFactory {
    func swiftUI(input: AppUI) -> AnyView {
        switch input {
        case .alert(let alertContent, let isPresented):
            AnyView(
                AlertView(alert: alertContent, isPresented: isPresented)
            )
        case .loading(let message):
            AnyView(
                AnimatedLoadingView(message: message)
            )
        }
    }
}
