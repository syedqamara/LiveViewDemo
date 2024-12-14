//
//  LivePhotoConverter.swift
//  LiveViewDemo
//
//  Created by Apple on 14/12/2024.
//

import Foundation
import Photos
import PhotosUI
import Combine

public struct LivePhotoConversions {
    let progress: Int
    var content: LiveImageContent?
    init(progress: Int, content: LiveImageContent? = nil) {
        self.progress = progress
        self.content = content
    }
}

public protocol LivePhotoConverterProtocol {
    init(manager: LivePhotoManagerProtocol)
    func convert(_ liveImage: LiveImageURLs) -> AnyPublisher<LivePhotoConversions, CoreErrorInfo>
}

public struct LivePhotoConverter: LivePhotoConverterProtocol {
    let manager: LivePhotoManagerProtocol
    let subject: PassthroughSubject<LivePhotoConversions, CoreErrorInfo> = .init()
    public init(manager: LivePhotoManagerProtocol) {
        self.manager = manager
    }
    public func convert(_ liveImage: LiveImageURLs) -> AnyPublisher<LivePhotoConversions, CoreErrorInfo> {
        self.manager.generate(from: liveImage.image, videoURL: liveImage.video) { progress in
            let percentage = Int(progress * 100)
            let conversion = LivePhotoConversions(progress: percentage)
            subject.send(conversion)
        } completion: { content in
            switch content {
            case .success(let success):
                let conversion = LivePhotoConversions(progress: 100, content: success)
                subject.send(conversion)
                subject.send(completion: .finished)
            case .failure(let error):
                subject.send(completion: .failure(error))
                subject.send(completion: .finished)
            }
        }
        return subject.eraseToAnyPublisher()
    }
}
