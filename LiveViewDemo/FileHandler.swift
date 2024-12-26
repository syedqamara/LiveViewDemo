//
//  FileHandler.swift
//  LiveViewDemo
//
//  Created by Apple on 27/12/2024.
//

import Foundation


public enum StorageType: String {
    case temporary = "tmp"
    case permanent = "document"
}

public struct FileConfig {
    public enum FileOperation {
        case create, read, update, delete
    }
    let id: String
    let operation: FileOperation
    let storageType: StorageType
}

class Cache {
    
}

public class FileHandler {
    private let queue: DispatchQueue = .init(label: "com.cache.file.queue-(\(UUID().uuidString))", qos: .background)
    public init() {
        
    }
    public func load(fileName: String) throws -> Data {
        try queue.sync {
            let cacheDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let url = cacheDirectory.appendingPathComponent(fileName)
            
            @Cached<Data>(key: fileName) var imageData
            if let imageData {
                return imageData
            }
            let fetchedData = try Data(contentsOf: url)
            _imageData.wrappedValue = fetchedData
            return fetchedData
        }
    }
    public func save(fileName: String, data: Data?) {
        queue.sync(flags: .barrier) {
            do {
                @Cached<Data>(key: fileName) var imageData
                let cacheDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let url = cacheDirectory.appendingPathComponent(fileName)
                imageData = data
                if let data = data {
                    if FileManager.default.fileExists(atPath: url.path) {
                        try data.write(to: url, options: .atomic)
                    } else {
                        try data.write(to: url, options: .atomic)
                    }
                } else {
                    if FileManager.default.fileExists(atPath: url.path) {
                        // Rule 1: Remove the existing file if data is nil
                        try FileManager.default.removeItem(at: url)
                    } else {
                        print("No file exists at: \(url)")
                    }
                }
            } catch {
                print("Error getting cache directory: \(error.localizedDescription)")
            }
        }
    }

}
