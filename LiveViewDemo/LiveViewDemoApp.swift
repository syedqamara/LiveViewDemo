//
//  LiveViewDemoApp.swift
//  LiveViewDemo
//
//  Created by Apple on 14/12/2024.
//

import SwiftUI


@main
struct LiveViewDemoApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var viewFactory = ViewFactory()
    @StateObject private var appManager = AppManager()
    
    @State var isAlertDismissed = false
    init() {
        
    }
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                viewFactory.swiftUI(input: .bundle)
                    .environment(\.viewFactory, viewFactory)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
            .onAppear() {
                self.appManager.setup()
            }
            .fullScreenCover(item: $appManager.alert) { content in
                viewFactory.swiftUI(input: .alert(content, $isAlertDismissed))
            }
            .fullScreenCover(isPresented: $appManager.isLoading, content: {
                viewFactory.swiftUI(input: .loading("Please wait"))
            })
        }
    }
}

