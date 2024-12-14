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
