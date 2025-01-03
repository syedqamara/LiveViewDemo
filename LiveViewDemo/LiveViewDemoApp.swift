//
//  LiveViewDemoApp.swift
//  LiveViewDemo
//
//  Created by Apple on 14/12/2024.
//

import SwiftUI
import live_view
import Firebase

@main
struct LiveViewDemoApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var viewFactory = ViewFactory()
    @StateObject private var appManager = AppManager()
    
    @State var isAlertDismissed = false
    init() {
        appManager.singleton.thirdPartySDK?.firebaseSDK?.connector.initialise()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { isConnected in
                
            })
            .store(in: &appManager.cancellables)
    }
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                // Displaying a view that load images from bundle see `ViewFactory+Photos.swift`
                viewFactory.swiftUI(input: .images([]))
                    .environment(\.viewFactory, viewFactory)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
            .onAppear() {
                self.appManager.setup()
            }
            // Binding Global Alert Handler to display alert thrown from any where
            .fullScreenCover(item: $appManager.alert) { content in
                viewFactory.swiftUI(input: .alert(content, $isAlertDismissed))
            }
            .overlay(alignment: .center) {
                if appManager.isLoading {
                    viewFactory.swiftUI(input: .loading("Please wait"))
                }
            }
        }
    }
}

