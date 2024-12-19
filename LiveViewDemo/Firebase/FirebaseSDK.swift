//
//  FirebaseSDK.swift
//  LiveViewDemo
//
//  Created by Apple on 19/12/2024.
//

import Foundation
import Firebase
import live_view

public struct SDKNoDelegate: SDKDelegateProtocol {
    public init() {}
}

typealias FirebaseLivePhotoSDK = FirebaseLivePhotoSDKImplementation

struct FirebaseLivePhotoSDKImplementation<C: SDKConnectorProtocol, M: FirebaseLivePhotoManagerProtocol>: FirebaseLivePhotoSDKProtocol {
    typealias Connector = C
    typealias Manager = M
    typealias Delegate = SDKNoDelegate
    
    var delegate: SDKNoDelegate? = nil
    var connector: C
    var manager: M
    
    init(connector: C, manager: M) {
        self.connector = connector
        self.manager = manager
    }
}
