//
//  ImageBrowser.swift
//  miViewer
//
//  Created by Metin AKSU on 30.06.2026.
//

import Foundation
import Combine
import UniformTypeIdentifiers

/// Açılan bir resim dosyasının bulunduğu klasörü tarar ve klasördeki
/// görsel dosyalar arasında gezinmeyi sağlar.
@MainActor
final class ImageBrowser: ObservableObject {
    /// Klasördeki görsel dosyaların doğal sıralamayla sıralı listesi.
    @Published private(set) var imageURLs: [URL] = []

    /// O an gösterilen resmin `imageURLs` içindeki index'i.
    @Published var currentIndex: Int = 0

    /// O an gösterilen resmin URL'i (liste boşsa nil).
    var currentURL: URL? {
        guard imageURLs.indices.contains(currentIndex) else { return nil }
        return imageURLs[currentIndex]
    }

    /// Klasördeki görsel dosya sayısı.
    var count: Int { imageURLs.count }

    /// Bir dosya URL'i ile başlat (nil ise boş başlar).
    init(fileURL: URL?) {
        if let fileURL { load(fileURL: fileURL) }
    }

    /// Boş başlangıç (henüz resim açılmamış durum için).
    init() {}

    /// Verilen dosyanın klasörünü tarar, görselleri sıralar ve
    /// `currentIndex`'i açılan dosyaya ayarlar.
    func load(fileURL: URL) {
        let folder = fileURL.deletingLastPathComponent()
        imageURLs = Self.scanImages(in: folder)

        let standardized = fileURL.standardizedFileURL
        if let idx = imageURLs.firstIndex(where: { $0.standardizedFileURL == standardized }) {
            currentIndex = idx
        } else {
            currentIndex = 0
        }
    }

    /// Sonraki resme geç; son resimdeyken başa döner (dön-dolaş).
    func next() {
        guard count > 0 else { return }
        currentIndex = (currentIndex + 1) % count
    }

    /// Önceki resme geç; ilk resimdeyken sona gider (dön-dolaş).
    func previous() {
        guard count > 0 else { return }
        currentIndex = (currentIndex - 1 + count) % count
    }

    /// Bir klasördeki görsel dosyaları UTType.image ile filtreleyip
    /// doğal sıralamayla (localizedStandardCompare) sıralı döndürür.
    private static func scanImages(in folder: URL) -> [URL] {
        let fm = FileManager.default
        guard let contents = try? fm.contentsOfDirectory(
            at: folder,
            includingPropertiesForKeys: [.contentTypeKey, .isRegularFileKey],
            options: [.skipsHiddenFiles]
        ) else {
            return []
        }

        let images = contents.filter { url in
            guard let values = try? url.resourceValues(forKeys: [.contentTypeKey, .isRegularFileKey]),
                  values.isRegularFile == true,
                  let type = values.contentType else {
                return false
            }
            return type.conforms(to: .image)
        }

        return images.sorted { lhs, rhs in
            lhs.lastPathComponent.localizedStandardCompare(rhs.lastPathComponent) == .orderedAscending
        }
    }
}
