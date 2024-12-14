//
//  LivePhotoSaver.swift
//  LiveViewDemo
//
//  Created by Apple on 15/12/2024.
//

import Foundation
import Combine

public protocol LivePhotoExporterProtocol {
    init(manager: LivePhotoManagerProtocol)
    func export(_ resource: LiveImageURLs) -> Future<Bool, CoreErrorInfo>
}

public struct LivePhotoExporter: LivePhotoExporterProtocol {
    let manager: LivePhotoManagerProtocol
    public init(manager: LivePhotoManagerProtocol) {
        self.manager = manager
    }
    public func export(_ resource: LiveImageURLs) -> Future<Bool, CoreErrorInfo> {
        Future { promise in
            self.manager.saveToLibrary(resource, completion: promise)
        }
    }
}
