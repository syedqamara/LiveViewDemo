//
//  LivePhotoContentView.swift
//  LiveViewDemo
//
//  Created by Apple on 14/12/2024.
//

import Foundation
import SwiftUI
import Photos
import PhotosUI

// MARK: - SwiftUI Wrapper
struct LivePhotoContentView: UIViewRepresentable {
    let photo: PHLivePhoto

    func makeUIView(context: Context) -> LivePhotoPlayer {
        LivePhotoPlayer(photo: photo)
    }

    func updateUIView(_ uiView: LivePhotoPlayer, context: Context) {
        // No updates required
    }
}
