//
//  LiveImageCreator.swift
//  LiveViewDemo
//
//  Created by Apple on 14/12/2024.
//

import Foundation
import Photos
import Combine

// Create multiple copies for different providers
public struct BundleLiveImageProvider: LiveImageProviderProtocol {
    enum BundleImageProviderError: CoreError {
        case noImage
        case noVideo
        
        var info: CoreErrorInfo {
            switch self {
            case .noImage:
                CoreErrorInfo(description: "No Image resource found for live photo", code: "live-image-finder-no-image")
            case .noVideo:
                CoreErrorInfo(description: "No Video resource found for live photo", code: "live-image-finder-no-video")
            }
        }
    }
    let imageExt: String
    let videoExt: String
    public func image(name: String, on bundle: Bundle) -> Future<LiveImageURLs, CoreErrorInfo> {
        Future { promise in
            guard let image = bundle.url(forResource: name, withExtension: imageExt) else {
                let error = BundleImageProviderError.noImage.info
                return promise(.failure(error))
            }
            guard let video = bundle.url(forResource: name, withExtension: videoExt) else {
                let error = BundleImageProviderError.noVideo.info
                return promise(.failure(error))
            }
            return promise(.success(.init(image: image, video: video)))
        }
    }
    
}
