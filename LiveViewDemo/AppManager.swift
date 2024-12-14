//
//  AppManager.swift
//  LiveViewDemo
//
//  Created by Apple on 15/12/2024.
//

import Foundation
import Combine

class AppManager: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var alert: AlertContent? = nil
    
    @Singleton var singleton
    
    var cancellables: Set<AnyCancellable> = .init()
    
    func setup() {
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
    }
    
}
