//
//  File.swift
//  LiveViewDemo
//
//  Created by Apple on 19/12/2024.
//

import Foundation
import Firebase
import Combine
import live_view

public struct FirebaseConnector: SDKConnectorProtocol {
    @Logger() var logger
    public struct Config {
        var name: String
        var options: FirebaseOptions
    }
    var config: Config?
    public init(config: Config? = nil) {
        self.config = config
    }
    public func initialise() -> Future<Bool, CoreErrorInfo> {
        Future { promise in
            if let app = FirebaseApp.app() {
                logger.info("firebase-app-initialise", message: "Application already initialised")
            } else if let config {
                FirebaseApp.configure(name: config.name, options: config.options)
            } else {
                FirebaseApp.configure()
            }
            promise(.success(true))
        }
    }
}


extension Logger {
    init() {
        self.init(logger: nil)
    }
}
