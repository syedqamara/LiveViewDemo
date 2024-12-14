//
//  File.swift
//  
//
//  Created by Apple on 14/12/2024.
//

import Foundation
import Combine
import Photos

public enum PermissionErrors: CoreError {
    case accessDenied
    case accessNotGiven
    
    var info: CoreErrorInfo {
        switch self {
        case .accessDenied:
            return CoreErrorInfo(description: "Access denied visit settings", code: "photos-library-access-denied")
        case .accessNotGiven:
            return CoreErrorInfo(description: "Access not given", code: "photos-library-access-not-given")
        }
    }
}

public protocol PermissionHandlerProtocol {
    func checkPermission() -> Future<Bool, PermissionErrors>
}

public class PermissionHandler: PermissionHandlerProtocol {
    public func checkPermission() -> Future<Bool, PermissionErrors> {
        Future { promise in
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    promise(.success(true))
                case .restricted:
                    promise(.failure(.accessDenied))
                case .denied:
                    promise(.failure(.accessDenied))
                case .notDetermined:
                    promise(.failure(.accessNotGiven))
                default:
                    promise(.failure(.accessDenied))
                }
            }
        }
    }
}
