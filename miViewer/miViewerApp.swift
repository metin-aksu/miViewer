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

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
