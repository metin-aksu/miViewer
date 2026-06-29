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

    var body: some View {
        Group {
            if let url = browser.currentURL, let image = NSImage(contentsOf: url) {
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                emptyState
            }
        }
        .frame(minWidth: 400, minHeight: 300)
        .background(Color(nsColor: .windowBackgroundColor))
        .navigationTitle(browser.currentURL?.lastPathComponent ?? "miViewer")
        .focusable()
        .focusEffectDisabled()
        .focused($isFocused)
        .onAppear { isFocused = true }
        .onKeyPress(.rightArrow) {
            browser.next()
            return .handled
        }
        .onKeyPress(.leftArrow) {
            browser.previous()
            return .handled
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("Görüntülenecek resim yok")
                .foregroundStyle(.secondary)
            Button("Resim Aç…") { openImage() }
        }
        .padding()
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
}

#Preview {
    ContentView()
        .environmentObject(ImageBrowser())
}
