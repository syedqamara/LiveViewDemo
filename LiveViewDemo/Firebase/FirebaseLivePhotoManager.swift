//
//  FirebaseLivePhotoManager.swift
//  LiveViewDemo
//
//  Created by Apple on 19/12/2024.
//

import Foundation
import Firebase
import FirebaseStorage
import Combine
import live_view

public class FirebaseLivePhotoManager: FirebaseLivePhotoManagerProtocol {
    public struct StorageConfig {
        public let appName: String?
        public let databaseName: String
        public let prefix: String?
        public let imageExtension: String
        public init(appName: String?, databaseName: String, prefix: String?, imageExtension: String) {
            self.appName = appName
            self.databaseName = databaseName
            self.prefix = prefix
            self.imageExtension = imageExtension
        }
    }
    @Logger var logger
    @Singleton var singleton
    private let config: StorageConfig?
    public init(config: StorageConfig) {
        self.config = config
    }
    private func storage() -> StorageReference? {
        var app: FirebaseApp? = nil
        if let name = config?.appName {
            app = FirebaseApp.app(name: name) ?? FirebaseApp.app()
        } else {
            app = FirebaseApp.app()
        }
        guard let app = app else {
            @Singleton var singleton
            let alert = AlertContent(title: "Error", subtitle: "No firebase app is initialised")
            singleton.alertPublisher.send(alert)
            return nil
        }
        let storage = Storage.storage(app: app)
        if let prefix = config?.prefix {
            return storage.reference(withPath: prefix)
        } else {
            return storage.reference()
        }
    }
    // Upload files (image and video) to Firebase Storage
    public func upload(image: LiveImageURLs, name: String) -> Future<LiveImageURLs, CoreErrorInfo> {
        Future { [weak self] promise in
            guard let storageRef = self?.storage(), let config = self?.config else {
                promise(.failure(CoreErrorInfo(description: "No storage found", code: "firebase-no-storage-reference")))
                return
            }
            let imageRef = storageRef.child("\(name).jpg")
            let videoRef = storageRef.child("\(name).mov")
            
            var uploadedImageURL: URL?
            var uploadedVideoURL: URL?
            
            let group = DispatchGroup()
            
            // Upload image
            group.enter()
            imageRef.putFile(from: image.image, metadata: nil) { _, error in
                if let error = error {
                    promise(.failure(CoreErrorInfo(description: error.localizedDescription, code: "firebase-image-upload-error")))
                } else {
                    imageRef.downloadURL { url, error in
                        if let error = error {
                            promise(.failure(CoreErrorInfo(description: error.localizedDescription, code: "firebase-image-url-fetch-error")))
                        } else if let url = url {
                            uploadedImageURL = url
                        }
                        group.leave()
                    }
                }
            }
            
            // Upload video
            group.enter()
            videoRef.putFile(from: image.video, metadata: nil) { _, error in
                if let error = error {
                    promise(.failure(CoreErrorInfo(description: error.localizedDescription, code: "firebase-video-upload-error")))
                } else {
                    videoRef.downloadURL { url, error in
                        if let error = error {
                            promise(.failure(CoreErrorInfo(description: error.localizedDescription, code: "firebase-video-url-fetch-error")))
                        } else if let url = url {
                            uploadedVideoURL = url
                        }
                        group.leave()
                    }
                }
            }
            
            // Notify completion when all tasks are done
            group.notify(queue: .main) {
                if let uploadedImageURL = uploadedImageURL, let uploadedVideoURL = uploadedVideoURL {
                    promise(.success(LiveImageURLs(image: uploadedImageURL, video: uploadedVideoURL)))
                } else {
                    promise(.failure(CoreErrorInfo(description: "Unable to upload all files", code: "firebase-upload-partial-error")))
                }
            }
        }
    }
    // Download URLs for image and video by image name
    public func download(imageName: String) -> Future<LiveImageURLs, CoreErrorInfo> {
        Future {
            [weak self]
            promise in
            guard let storageRef = self?.storage(), let config = self?.config else {
                promise(.failure(CoreErrorInfo(description: "No storage found", code: "firebase-no-storage-reference")))
                return
            }
            let imageRef = storageRef.child("\(imageName).\(config.imageExtension)")
            let videoRef = storageRef.child("\(imageName).mov")
            
            var imageURL: URL?
            var videoURL: URL?
            
            let group = DispatchGroup()
            
            // Fetch image URL
            group.enter()
            imageRef.downloadURL { url, error in
                if let error = error {
                    promise(.failure(CoreErrorInfo(description: error.localizedDescription, code: "firebase-download-image-error")))
                } else {
                    imageURL = url
                }
                group.leave()
            }
            
            // Fetch video URL
            group.enter()
            videoRef.downloadURL { url, error in
                if let error = error {
                    promise(.failure(CoreErrorInfo(description: error.localizedDescription, code: "firebase-download-video-error")))
                } else {
                    videoURL = url
                }
                group.leave()
            }
            
            // Notify completion when all tasks are done
            group.notify(queue: .main) {
                if let imageURL = imageURL, let videoURL = videoURL {
                    promise(.success(LiveImageURLs(image: imageURL, video: videoURL)))
                } else {
                    promise(.failure(CoreErrorInfo(description: "Unable to fetch all URLs", code: "firebase-download-partial-error")))
                }
            }
        }
    }
    struct FileInfo {
        let name: String
        let `extension`: String
        init(name: String, `extension`: String) {
            self.name = name
            self.extension = `extension`
        }
        var fileName: String { "\(name).\(self.extension)" }
    }
    func getFileInfo(url: URL) throws -> FileInfo {
        let lastPath = url.lastPathComponent
        let name = lastPath.components(separatedBy: ".").first
        let ext = lastPath.components(separatedBy: ".").first
        if let name, let ext {
            return FileInfo(name: name, extension: ext)
        }
        throw CoreErrorInfo(description: "Invalid file name in URL", code: "url-found-invalid-file-name")
    }
    // Download files (image and video) to local URLs
    var cancellables: Set<AnyCancellable> = .init()
    fileprivate func getAlreadyDownloadedURLs(urls: LiveImageURLs) -> LiveImageURLs? {
        @Defaults(.custom(urls.image.absoluteString)) var imagePath: String?
        @Defaults(.custom(urls.video.absoluteString)) var videoPath: String?
        
        guard let imagePath, let imageURL = URL(string: imagePath), let videoPath, let videoURL = URL(string: videoPath) else {
            return nil
        }
        return LiveImageURLs(image: imageURL, video: videoURL)
    }
    public func download(urls: LiveImageURLs) -> Future<LiveImageURLs, CoreErrorInfo> {
        cancellables.cancelAllOperations()
        if let alreadySaveURLs = self.getAlreadyDownloadedURLs(urls: urls) {
            return Future { promise in
                promise(.success(alreadySaveURLs))
            }
        }
        return Future { [weak self] promise in
            let group = DispatchGroup()
            
            var localImageURL: URL?
            var localVideoURL: URL?
            guard let config = self?.config else {
                promise(.failure(CoreErrorInfo(description: "No Config found", code: "firebase-no-config-found")))
                return
            }
            
            // Download image
            group.enter()
            
            let imageTask = URLSession.shared.downloadTask(with: urls.image) { location, _, error in
                guard let self else { return }
                if let error = error {
                    promise(.failure(CoreErrorInfo(description: error.localizedDescription, code: "firebase-image-download-task-error")))
                } else if let location = location {
                    do {
                        let data = try Data(contentsOf: location)
                        let filename = try self.getFileInfo(url: urls.image)
                        let config = FileConfig(id: urls.image.absoluteString, name: filename.fileName, operation: .create(data), storageType: .permanent)
                        self.singleton.fileHandler.operation(config: config)
                            .receive(on: DispatchQueue.global(qos: .background))
                            .sink { completion in
                                group.leave()
                                if case .failure(let error) = completion {
                                    promise(.failure(error))
                                }
                            } receiveValue: { url in
                                localImageURL = url
                                
                            }
                            .store(in: &self.cancellables)

                    } catch {
                        promise(.failure(CoreErrorInfo(description: error.localizedDescription, code: "local-image-save-error")))
                        group.leave()
                    }
                }
            }
            imageTask.resume()
            
            // Download video
            group.enter()
            let videoTask = URLSession.shared.downloadTask(with: urls.video) { location, _, error in
                guard let self else { return }
                if let error = error {
                    promise(.failure(CoreErrorInfo(description: error.localizedDescription, code: "firebase-video-download-task-error")))
                } else if let location = location {
                    do {
                        let data = try Data(contentsOf: location)
                        let filename = try self.getFileInfo(url: urls.video)
                        let config = FileConfig(id: urls.video.absoluteString, name: filename.fileName, operation: .create(data), storageType: .permanent)
                        self.singleton.fileHandler.operation(config: config)
                            .receive(on: DispatchQueue.global(qos: .background))
                            .sink { completion in
                                group.leave()
                                if case .failure(let error) = completion {
                                    promise(.failure(error))
                                }
                            } receiveValue: { url in
                                localVideoURL = url
                                
                            }
                            .store(in: &self.cancellables)
                    } catch {
                        promise(.failure(CoreErrorInfo(description: error.localizedDescription, code: "local-video-save-error")))
                    }
                }
                group.leave()
            }
            videoTask.resume()
            
            // Notify completion when all tasks are done
            group.notify(queue: .global(qos: .background)) {
                if let localImageURL = localImageURL, let localVideoURL = localVideoURL {
                    promise(.success(LiveImageURLs(image: localImageURL, video: localVideoURL)))
                } else {
                    promise(.failure(CoreErrorInfo(description: "Unable to download all files", code: "firebase-download-partial-error")))
                }
            }
        }
    }
}
