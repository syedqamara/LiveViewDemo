//
//  Logs+Ext.swift
//  LiveViewDemo
//
//  Created by Apple on 14/12/2024.
//

import Foundation
import Photos
import PhotosUI
import SwiftUI
import UIKit

public extension Font {
    var lineWidth: CGFloat {
        switch self {
        case .largeTitle:
            return 20
        default:
            return 10
        }
    }
}

public extension PHAssetMediaType {
    var logs: String {
        switch self {
        case .unknown:
            return "Unknown"
        case .image:
            return "Image"
        case .video:
            return "Video"
        case .audio:
            return "Audio"
        default:
            return "Default"
        }
    }
}
public extension PHAssetMediaSubtype {
    var logs: String {
        switch self {
        case .photoLive:
            return "Live Photo"
        case .photoHDR:
            return "HDR Photo"
        case .photoDepthEffect:
            return "Photo Depth Effect"
        case .photoPanorama:
            return "Photo Panorama"
        case .photoScreenshot:
            return "Screenshots"
        case .videoCinematic:
            return "Video Cinematic"
        case .videoHighFrameRate:
            return "Video High frame rate"
        case .videoStreamed:
            return "Video Streamed"
        case .videoTimelapse:
            return "Video Timelapse"
        default:
            return "Default"
        }
    }
}

public extension PHLivePhotoViewPlaybackStyle {
    var logs: String {
        switch self {
        case .undefined:
            return "Undefined"
        case .full:
            return "Full"
        case .hint:
            return "Hint"
        }
    }
}

public extension AlertContent {
    init(error: CoreErrorInfo) {
        self.title = error.code
        self.subtitle = error.localizedDescription
        self.image = nil
    }
}


extension UIButton {
    /// Adds a long-press gesture recognizer to the button
    /// - Parameters:
    ///   - minimumPressDuration: The minimum duration (in seconds) to trigger the long press (default is 0.5 seconds)
    ///   - onPressStart: Called when the user starts pressing for the defined duration
    ///   - onPressEnd: Called when the user releases the press
    func addLongPressGesture(
        minimumPressDuration: TimeInterval = 0.5,
        onPressStart: @escaping () -> Void,
        onPressEnd: @escaping () -> Void
    ) {
        let longPressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleLongPressGesture(_:))
        )
        longPressGesture.minimumPressDuration = minimumPressDuration
        
        // Store closures for use in gesture handling
        self.onPressStart = onPressStart
        self.onPressEnd = onPressEnd
        
        self.addGestureRecognizer(longPressGesture)
    }
    
    // Associated object keys
    private struct AssociatedKeys {
        static var onPressStartKey = "@objc_runtime_onPressStartKey"
        static var onPressEndKey = "@objc_runtime_onPressEndKey"
    }
    
    // Closure properties
    private var onPressStart: (() -> Void)? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.onPressStartKey) as? () -> Void }
        set { objc_setAssociatedObject(self, &AssociatedKeys.onPressStartKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    private var onPressEnd: (() -> Void)? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.onPressEndKey) as? () -> Void }
        set { objc_setAssociatedObject(self, &AssociatedKeys.onPressEndKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            onPressStart?()
        case .ended, .cancelled, .failed:
            onPressEnd?()
        default:
            break
        }
    }
}
