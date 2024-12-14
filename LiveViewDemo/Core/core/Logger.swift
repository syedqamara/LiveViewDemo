//
//  Logger.swift
//  LiveViewDemo
//
//  Created by Apple on 14/12/2024.
//

import Foundation
import Photos
import PhotosUI

protocol Logging {
    func info<I>(_ input: I, message: String)
}

class LoggingManager: Logging {
    static let shared = LoggingManager()
    
    func info<I>(_ input: I, message: String) {
        print("""
        --------------------------------------------------------
        | \(message)
        --------------------------------------------------------
        Input: \(input)
        --------------------------------------------------------
        """)
    }
    
    
    func info(_ asset: PHAsset, message: String) {
        print("""
        --------------------------------------------------------
        | \(message)
        --------------------------------------------------------
        Asset ID: \(asset.localIdentifier)
        AssetMedia Type: \(asset.mediaType.logs)
        AssetMedia SubType: \(asset.mediaSubtypes.logs)
        --------------------------------------------------------
        """)
    }
    func info(_ playbackStyle: PHLivePhotoViewPlaybackStyle, message: String) {
        print("""
        --------------------------------------------------------
        | \(message)
        --------------------------------------------------------
        Playback Style: \(playbackStyle.logs)
        --------------------------------------------------------
        """)
    }
}

@propertyWrapper
struct Logger<L: Logging> {
    private var logger: L
    init(logger: L = LoggingManager.shared) {
        self.logger = logger
    }
    var wrappedValue: L {
        logger
    }
}
