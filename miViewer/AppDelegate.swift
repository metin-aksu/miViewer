//
//  AppDelegate.swift
//  miViewer
//
//  Created by Metin AKSU on 30.06.2026.
//

import AppKit
import Combine

/// Açılmak istenen dosya URL'lerini tutan paylaşılan kuyruk. Her yeni pencere
/// açıldığında kuyruktan bir URL "kapar" ve kendi tarayıcısına yükler; böylece
/// her dosya kendi penceresinde, diğerlerinden bağımsız görüntülenir.
@MainActor
final class OpenManager: ObservableObject {
    static let shared = OpenManager()
    @Published var queue: [URL] = []

    func enqueue(_ urls: [URL]) {
        queue.append(contentsOf: urls)
    }

    /// Kuyruktaki ilk URL'i alıp çıkarır (yoksa nil).
    func claim() -> URL? {
        queue.isEmpty ? nil : queue.removeFirst()
    }
}

/// Resme çift tıklandığında (veya "Birlikte Aç" ile) macOS'un uygulamaya
/// ilettiği dosya URL'lerini yakalar ve paylaşılan kuyruğa ekler.
final class AppDelegate: NSObject, NSApplicationDelegate {
    func application(_ application: NSApplication, open urls: [URL]) {
        OpenManager.shared.enqueue(urls)
    }
}
