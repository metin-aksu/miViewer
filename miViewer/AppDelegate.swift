//
//  AppDelegate.swift
//  miViewer
//
//  Created by Metin AKSU on 30.06.2026.
//

import AppKit

/// Resme çift tıklandığında (veya "Birlikte Aç" ile) macOS'un uygulamaya
/// ilettiği dosya URL'ini yakalar ve paylaşılan ImageBrowser'a aktarır.
final class AppDelegate: NSObject, NSApplicationDelegate {
    /// App tarafından kurulan paylaşılan tarayıcı. Henüz hazır değilken
    /// gelen URL `pendingURL`'de bekletilir.
    var browser: ImageBrowser? {
        didSet { flushPendingIfNeeded() }
    }

    private var pendingURL: URL?

    func application(_ application: NSApplication, open urls: [URL]) {
        guard let url = urls.first else { return }
        if let browser {
            browser.load(fileURL: url)
        } else {
            pendingURL = url
        }
    }

    private func flushPendingIfNeeded() {
        guard let browser, let url = pendingURL else { return }
        browser.load(fileURL: url)
        pendingURL = nil
    }
}
