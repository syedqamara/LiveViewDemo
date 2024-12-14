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
                // Displaying a view that load images from bundle see `ViewFactory+Photos.swift`
                viewFactory.swiftUI(input: .bundle)
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
            // Binding Global Loading View to display loading from any where
            .fullScreenCover(isPresented: $appManager.isLoading, content: {
                viewFactory.swiftUI(input: .loading("Please wait"))
            })
        }
    }
}

