//
//  Singleton.swift
//  LiveViewDemo
//
//  Created by Apple on 15/12/2024.
//

import Foundation
import Combine

public protocol SingletonProtocol {
    var alertPublisher: CurrentValueSubject<AlertContent?, Never> { get }
    var loadingPublisher: CurrentValueSubject<Bool, Never> { get }
    var converter: LivePhotoConverterProtocol { get }
    var exporter: LivePhotoExporterProtocol { get }
    var bundleLiveImageProvider: LiveImageProviderProtocol { get }
}

class SingletonImplementation: SingletonProtocol {
    var converter: any LivePhotoConverterProtocol = LivePhotoConverter(manager: LivePhotoManager.default)
    var exporter: any LivePhotoExporterProtocol = LivePhotoExporter(manager: LivePhotoManager.default)
    var bundleLiveImageProvider: any LiveImageProviderProtocol = BundleLiveImageProvider(imageExt: "HEIC", videoExt: "MOV")
    
    static let shared = SingletonImplementation()
    private var alertSubject: CurrentValueSubject<AlertContent?, Never> = CurrentValueSubject(nil)
    private var loadingSubject: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    var alertPublisher: CurrentValueSubject<AlertContent?, Never> {
        alertSubject
    }
    var loadingPublisher: CurrentValueSubject<Bool, Never> {
        loadingSubject
    }
}


@propertyWrapper
struct Singleton<S: SingletonProtocol> {
    private var singleton: S
    init(singleton: S = SingletonImplementation.shared) {
        self.singleton = singleton
    }
    var wrappedValue: S {
        singleton
    }
}
