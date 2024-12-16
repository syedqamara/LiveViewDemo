//
//  ExampleBundleLiveImageViewModel.swift
//  LiveViewDemo
//
//  Created by Apple on 15/12/2024.
//

import Foundation
import Combine

public protocol ExampleBundleLiveImageViewModelProtocol: ObservableObject {
    init()
    var livePhoto: LivePhotoConversions? { get set }
    func load(image: String)
    func save()
}

public class ExampleBundleLiveImageViewModel: ExampleBundleLiveImageViewModelProtocol {
    
    @Published public var livePhoto: LivePhotoConversions?
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    @Singleton private var singleton
    
    public required init() {
        
    }
    public func load(image: String) {
        singleton.loadingPublisher.send(true)
        singleton.bundleLiveImageProvider
            .image(name: image, on: .main)
            .receive(on: DispatchQueue.main)
            .sink {
                [singleton]
                completion in
                if case .failure(let error) = completion {
                    singleton.loadingPublisher.send(false)
                    singleton.alertPublisher.send(AlertContent(error: error))
                }
            } receiveValue: {
                [weak self]
                urls in
                self?.convert(image: urls)
            }
            .store(in: &cancellables)
    }
    private func convert(image: LiveImageURLs) {
        singleton.converter
            .convert(image)
            .receive(on: RunLoop.current)
            .sink {
                [singleton]
                completion in
                singleton.loadingPublisher.send(false)
                if case .failure(let error) = completion {
                    singleton.alertPublisher.send(AlertContent(error: error))
                }
            } receiveValue: { [singleton, weak self]
                photo in
                singleton.loadingPublisher.send(false)
                self?.livePhoto = photo
            }
            .store(in: &cancellables)
    }
    public func save() {
        guard let urls = livePhoto?.content?.urls, !singleton.loadingPublisher.value else {
            let error = CoreErrorInfo(description: "No live photo to save", code: "example-bundle-save-live-photo-not-found")
            singleton.alertPublisher.send(AlertContent(error: error))
            return
        }
        singleton.loadingPublisher.send(true)
        singleton.exporter
            .export(urls)
            .receive(on: DispatchQueue.main)
            .sink { [singleton] completion in
                singleton.loadingPublisher.send(false)
                if case .failure(let error) = completion {
                    singleton.alertPublisher.send(AlertContent(error: error))
                }
            } receiveValue: { [singleton] isSaved in
                singleton.loadingPublisher.send(false)
                if !isSaved {
                    let error = CoreErrorInfo(description: "Unable to save live photo", code: "live-photo-save-to-gallary-failed")
                    singleton.alertPublisher.send(AlertContent(error: error))
                } else {
                    let alertContent = AlertContent(title: "Success", subtitle: "Live photo saved successfully in Gallary", design: .success)
                    singleton.alertPublisher.send(alertContent)
                }
            }
            .store(in: &cancellables)

    }
}
