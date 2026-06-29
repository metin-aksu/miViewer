//
//  miViewerApp.swift
//  miViewer
//
//  Created by Metin AKSU on 30.06.2026.
//

import SwiftUI

@main
struct miViewerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var browser = ImageBrowser()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(browser)
                .onAppear { appDelegate.browser = browser }
        }
    }
}
