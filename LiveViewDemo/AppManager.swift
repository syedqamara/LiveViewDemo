//
//  AppManager.swift
//  LiveViewDemo
//
//  Created by Apple on 15/12/2024.
//

import Foundation
import Combine
import live_view

class AppManager: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var alert: AlertContent? = nil
    
    // Safely using Singleton Classes
    @Singleton var singleton
    
    var cancellables: Set<AnyCancellable> = .init()
    
    private func setupThirdParty() {
        let firebaseConnector = FirebaseConnector(config: nil)
        let firebaseManager = FirebaseLivePhotoManager(
            config: FirebaseLivePhotoManager.StorageConfig(
                appName: nil,
                databaseName: "",
                prefix: nil,
                imageExtension: "HEIC"
            )
        )
        let firebaseSDK = FirebaseLivePhotoSDK(connector: firebaseConnector, manager: firebaseManager)
        
        singleton.thirdPartySDK = ThirdPartySDKs(
            firebaseSDK: firebaseSDK
        )
        _ = firebaseConnector.initialise()
    }
    
    func setup() {
        
        // Connect the global binding of alert & loading listener
        singleton
            .loadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { isLoaded in
                self.isLoading = isLoaded
            }
            .store(in: &cancellables)
        
        singleton
            .alertPublisher
            .receive(on: DispatchQueue.main)
            .sink { alertRecieved in
                self.alert = alertRecieved
            }
            .store(in: &cancellables)
        
//        setupThirdParty()
    }
    
}
