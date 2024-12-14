//
//  Core.swift
//  LiveViewDemo
//
//  Created by Apple on 14/12/2024.
//

import Foundation
import Photos
import Combine

public protocol LiveImageProviderProtocol {
    func image(name: String, on bundle: Bundle) -> Future<LiveImageURLs, CoreErrorInfo>
}

public struct LiveImageURLs {
    let image: URL
    let video: URL
}
public struct LiveImageContent {
    let photo: PHLivePhoto
    let urls: LiveImageURLs
}

protocol CoreError: Error {
    var info: CoreErrorInfo { get }
}
extension CoreError {
    var localizedDescription: String { info.localizedDescription }
}

public struct CoreErrorInfo: Error {
    let description: String
    let code: String
    var localizedDescription: String { description }
    init(description: String, code: String) {
        self.description = description
        self.code = code
    }
    init(error: NSError) {
        func getDescription(_ error: NSError) -> String {
            """
            ------------------------------------------------------
            | Description | \(error.localizedDescription)
            ------------------------------------------------------
            | Failure Reason | \(error.localizedFailureReason ?? "")
            ------------------------------------------------------
            | Recovery Options | \(error.localizedRecoveryOptions?.joined(separator: " ") ?? "")
            ------------------------------------------------------
            | Recovery Suggestion | \(error.localizedRecoverySuggestion ?? "")
            ------------------------------------------------------
            """
        }
        func getCode(_ error: NSError) -> String {
            "\(error.domain)-\(error.code)"
        }
        self.description = getDescription(error)
        self.code = getCode(error)
    }
    
}
