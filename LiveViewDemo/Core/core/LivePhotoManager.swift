//
//  LivePhotoManager.swift
//  LiveViewDemo
//
//  Created by Apple on 15/12/2024.
//

import Foundation
import AVFoundation
import MobileCoreServices
import Photos

public protocol LivePhotoManagerProtocol {
    func extractResources(from livePhoto: PHLivePhoto, completion: @escaping (Result<LiveImageURLs, CoreErrorInfo>) -> Void)
    func generate(from imageURL: URL?, videoURL: URL, progress: @escaping (CGFloat) -> Void, completion: @escaping (Result<LiveImageContent, CoreErrorInfo>) -> Void)
    func saveToLibrary(_ resources: LiveImageURLs, completion: @escaping (Result<Bool, CoreErrorInfo>) -> Void)
}

public class LivePhotoManager: LivePhotoManagerProtocol {
    public static let `default` = LivePhotoManager(photoManager: LivePhotoKit())
    private var photoManager: LivePhotoKitProtocol
    private let queue = DispatchQueue(label: "com.limit-point.LivePhotoQueue", attributes: .concurrent)
    init(photoManager: LivePhotoKitProtocol) {
        self.photoManager = photoManager
    }
    public func extractResources(from livePhoto: PHLivePhoto, completion: @escaping (Result<LiveImageURLs, CoreErrorInfo>) -> Void) {
        self.queue.async {
            self.photoManager.extractResources(from: livePhoto) { resource in
                guard let resource else {
                    let error = CoreErrorInfo(description: "Unable to extract live photo resources", code: "live-photo-resource-extract-error-unknown")
                    return
                }
                completion(.success(resource))
            }
        }
    }
    /// Generates a PHLivePhoto from an image and video.  Also returns the paired image and video.
    public func generate(from imageURL: URL?, videoURL: URL, progress: @escaping (CGFloat) -> Void, completion: @escaping (Result<LiveImageContent, CoreErrorInfo>) -> Void) {
        queue.async {
            self.photoManager.generate(from: imageURL, videoURL: videoURL, progress: progress) { photo, urls in
                guard let photo, let urls else {
                    let error = CoreErrorInfo(description: "Unable to generate live photo", code: "live-photo-generate-error-unknown")
                    completion(.failure(error))
                    return
                }
                let content = LiveImageContent(photo: photo, urls: urls)
                completion(.success(content))
            }
        }
    }
    /// Save a Live Photo to the Photo Library by passing the paired image and video.
    public func saveToLibrary(_ resources: LiveImageURLs, completion: @escaping (Result<Bool, CoreErrorInfo>) -> Void) {
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetCreationRequest.forAsset()
            let options = PHAssetResourceCreationOptions()
            creationRequest.addResource(with: PHAssetResourceType.pairedVideo, fileURL: resources.video, options: options)
            creationRequest.addResource(with: PHAssetResourceType.photo, fileURL: resources.image, options: options)
        }, completionHandler: { (success, error) in
            if let error = error as? NSError {
                let err = CoreErrorInfo(error: error)
                completion(.failure(err))
            } else {
                completion(.success(success))
            }
        })
    }
}
