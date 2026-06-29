//
//  WindowAccessor.swift
//  miViewer
//
//  Created by Metin AKSU on 30.06.2026.
//

import SwiftUI
import AppKit

/// SwiftUI view ağacına yerleştirilen, ait olduğu NSWindow'a erişip
/// üzerinde yapılandırma yapmayı sağlayan görünmez yardımcı.
struct WindowAccessor: NSViewRepresentable {
    let onResolve: (NSWindow) -> Void

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        // Pencere, view hiyerarşiye eklendikten sonra erişilebilir olur.
        DispatchQueue.main.async {
            if let window = view.window {
                onResolve(window)
            }
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}
