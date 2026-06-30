//
//  ContentView.swift
//  miViewer
//
//  Created by Metin AKSU on 30.06.2026.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @EnvironmentObject private var browser: ImageBrowser
    @FocusState private var isFocused: Bool

    /// O an gösterilen resmin yüklenmiş hali (zoom'da yeniden yüklenmesin diye cache).
    @State private var currentImage: NSImage?

    /// true ise resim pencereye sığdırılır; false ise `userScale` kullanılır.
    @State private var isFitMode: Bool = true

    /// Kullanıcının seçtiği zoom oranı (1.0 = %100, piksel boyutu).
    @State private var userScale: CGFloat = 1.0

    /// Resmin pencereye sığdığındaki oranı; "fit" modunun gösterdiği gerçek oran.
    @State private var fitScale: CGFloat = 1.0

    private let zoomStep: CGFloat = 1.25
    private let minScale: CGFloat = 0.05
    private let maxScale: CGFloat = 16.0

    /// O an ekranda görünen efektif zoom oranı.
    private var effectiveScale: CGFloat { isFitMode ? fitScale : userScale }

    var body: some View {
        VStack(spacing: 0) {
            imageArea
            Divider()
            toolbar
        }
        .frame(minWidth: 400, minHeight: 300)
        .background(WindowAccessor { window in
            window.setFrameAutosaveName("miViewerMainWindow")
        })
        .navigationTitle(browser.currentURL?.lastPathComponent ?? "miViewer")
        .focusable()
        .focusEffectDisabled()
        .focused($isFocused)
        .onAppear {
            isFocused = true
            loadCurrentImage()
        }
        .onChange(of: browser.currentURL) { _, _ in
            loadCurrentImage()
        }
        .onKeyPress(.rightArrow) { browser.next(); return .handled }
        .onKeyPress(.leftArrow) { browser.previous(); return .handled }
        .onKeyPress(.space) { browser.next(); return .handled }
        .onKeyPress(.escape) {
            NSApp.keyWindow?.performClose(nil)
            return .handled
        }
        .onKeyPress("f") {
            NSApp.keyWindow?.toggleFullScreen(nil)
            return .handled
        }
        .onKeyPress("=") { zoomIn(); return .handled }
        .onKeyPress("+") { zoomIn(); return .handled }
        .onKeyPress("-") { zoomOut(); return .handled }
        .onKeyPress("0") { fitImage(); return .handled }
        .dropDestination(for: URL.self) { urls, _ in
            guard let url = urls.first(where: { $0.isFileURL }) else { return false }
            browser.load(fileURL: url)
            return true
        }
    }

    // MARK: - Resim Alanı

    @ViewBuilder
    private var imageArea: some View {
        if let image = currentImage {
            GeometryReader { geo in
                let px = Self.pixelSize(of: image)
                let fit = min(geo.size.width / px.width, geo.size.height / px.height)
                let scale = isFitMode ? fit : userScale
                ScrollView([.horizontal, .vertical]) {
                    Image(nsImage: image)
                        .resizable()
                        .interpolation(.high)
                        .frame(width: px.width * scale, height: px.height * scale)
                        // Resim viewport'tan küçükse ortalansın.
                        .frame(minWidth: geo.size.width, minHeight: geo.size.height)
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .onAppear { fitScale = fit }
                .onChange(of: geo.size) { _, _ in fitScale = fit }
                .onChange(of: image) { _, _ in fitScale = fit }
            }
            .background(Color(nsColor: .windowBackgroundColor))
        } else {
            emptyState
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(nsColor: .windowBackgroundColor))
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No image to display")
                .foregroundStyle(.secondary)
            Button("Open Image…") { openImage() }
        }
        .padding()
    }

    // MARK: - Kontrol Çubuğu

    private var toolbar: some View {
        HStack(spacing: 8) {
            Spacer()

            Button(action: { browser.previous() }) {
                Image(systemName: "chevron.left")
            }
            .help("Previous image")

            Button(action: { browser.next() }) {
                Image(systemName: "chevron.right")
            }
            .help("Next image")

            Divider().frame(height: 16)

            Button(action: { zoomOut() }) {
                Image(systemName: "minus.magnifyingglass")
            }
            .help("Zoom out")

            Button(action: { zoom100() }) {
                Text("100%").monospacedDigit()
            }
            .help("Actual size (100%)")

            Button(action: { zoomIn() }) {
                Image(systemName: "plus.magnifyingglass")
            }
            .help("Zoom in")

            Button(action: { fitImage() }) {
                Image(systemName: "arrow.down.left.and.arrow.up.right")
            }
            .help("Fit to window")

            Spacer()
        }
        .overlay(alignment: .trailing) {
            HStack(spacing: 8) {
                Text("\(Int((effectiveScale * 100).rounded()))%")
                    .monospacedDigit()
                    .foregroundStyle(.secondary)

                if browser.count > 0 {
                    Text("\(browser.currentIndex + 1) / \(browser.count)")
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .disabled(currentImage == nil)
        .background(.bar)
    }

    // MARK: - Zoom İşlemleri

    private func zoomIn() {
        guard currentImage != nil else { return }
        let base = effectiveScale
        isFitMode = false
        userScale = min(base * zoomStep, maxScale)
    }

    private func zoomOut() {
        guard currentImage != nil else { return }
        let base = effectiveScale
        isFitMode = false
        userScale = max(base / zoomStep, minScale)
    }

    private func zoom100() {
        guard currentImage != nil else { return }
        isFitMode = false
        userScale = 1.0
    }

    private func fitImage() {
        isFitMode = true
    }

    // MARK: - Yükleme

    private func loadCurrentImage() {
        if let url = browser.currentURL {
            currentImage = NSImage(contentsOf: url)
        } else {
            currentImage = nil
        }
        // Yeni resimde her zaman pencereye sığdırarak başla.
        isFitMode = true
        userScale = 1.0
    }

    private func openImage() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.image]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        if panel.runModal() == .OK, let url = panel.url {
            browser.load(fileURL: url)
        }
    }

    /// Resmin piksel boyutu (%100'ün gerçek piksel anlamına gelmesi için).
    private static func pixelSize(of image: NSImage) -> CGSize {
        if let rep = image.representations.first {
            let w = rep.pixelsWide, h = rep.pixelsHigh
            if w > 0 && h > 0 {
                return CGSize(width: w, height: h)
            }
        }
        return image.size
    }
}

#Preview {
    ContentView()
        .environmentObject(ImageBrowser())
}
