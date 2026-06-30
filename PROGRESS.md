# miViewer — İlerleme Notları

Son güncelleme: 2026-06-30

Bu dosya, oturumlar arası devamlılık için yapılanların ve kalan işlerin özetidir.
Detaylı yol haritası için bkz. [ROADMAP.md](ROADMAP.md).

---

## Genel Durum

Klasör-farkındalıklı, klavye + buton ile gezilebilen, dön-dolaş navigasyonlu,
zoom kontrollü native macOS resim görüntüleyici. SwiftUI + Xcode 26.5.
**Kullanılabilir durumda** — çekirdek, cila ve ikon tamamlandı. Kalan: yerel
kurulum (Faz 6) ve GitHub dağıtımı (Faz 7).

- Uygulama adı: **miViewer** (ROADMAP'teki `FlipView` placeholder yerine)
- Bundle ID: `com.metinaksu.miViewer`
- Deployment target: **macOS 26.5** (`.onKeyPress` modern API kullanılabiliyor)
- App Sandbox: **KAPALI** (`ENABLE_APP_SANDBOX = NO`) — GitHub'dan dağıtım kararı
- Git branch: `main`

---

## Tamamlanan Fazlar

### Faz 0–1 — Hazırlık + Boş Proje ✅
- Xcode 26.5, `miViewer` SwiftUI macOS App projesi (zaten mevcuttu).

### Faz 2 — Klasör tarama + resim gösterme ✅
- `miViewer/ImageBrowser.swift`: `ObservableObject`.
  - `UTType.image` ile filtreleme (uzantı listesi değil).
  - `localizedStandardCompare` ile doğal sıralama (img2 < img10).
  - `@Published currentIndex`, hesaplanmış `currentURL`, `count`.
  - `load(fileURL:)` klasörü tarar, index'i açılan dosyaya ayarlar.
- `ContentView`: resmi aspect-fit gösterir, pencere başlığı = dosya adı.

### Faz 3 — Ok tuşlarıyla dön-dolaş navigasyon ✅
- `ImageBrowser.next()` / `previous()` modüler aritmetikle wrap-around.
- `ContentView`: `.onKeyPress(.rightArrow/.leftArrow)` + `.focusable()` / `@FocusState`.

### Faz 4 — Dosya ilişkilendirme + sandbox'sız yapı ✅
- `miViewer/AppDelegate.swift`: `@NSApplicationDelegateAdaptor`,
  `application(_:open:)` gelen URL'i paylaşılan `ImageBrowser`'a aktarır
  (henüz hazır değilse `pendingURL`'de bekletir).
- `miViewerApp.swift`: `@StateObject ImageBrowser` + `.environmentObject(...)`,
  `onAppear`'da `appDelegate.browser = browser`.
- `Info.plist` (proje kökünde): `CFBundleDocumentTypes` → `public.image`,
  rol `Viewer`, `LSHandlerRank = Alternate`.
  - pbxproj'da `INFOPLIST_FILE = Info.plist` (senkronize klasör dışında,
    "Copy Bundle Resources" uyarısını önlemek için kökte tutuldu).
- `ENABLE_APP_SANDBOX = NO` (her iki config).

### Faz 5 — Cila ✅
- `Esc` → pencereyi kapat, `Space` → sonraki, `f` → tam ekran toggle.
- Sürükle-bırak ile resim açma (`dropDestination(for: URL.self)`).
- Pencere boyutu/konumu hatırlama: `miViewer/WindowAccessor.swift`
  (`NSViewRepresentable`) + `setFrameAutosaveName("miViewerMainWindow")`.

### Faz 5+ — Alt kontrol çubuğu (kullanıcı isteği) ✅
- Resim alanının altında **ortalanmış** buton grubu:
  ◀ ▶ (önceki/sonraki) | 🔍− (uzaklaştır) · 100% · 🔍+ (yakınlaştır) · ⤢ (sığdır)
- Sağ kenarda (`overlay(alignment: .trailing)`): zoom oranı % + `index / count` sayacı.
- Zoom mantığı: `isFitMode` + `userScale` + `fitScale`; `effectiveScale` hesaplanır.
  - Yakınlaşınca taşan resim `ScrollView([.horizontal,.vertical])` ile pan edilebilir.
  - Küçükse viewport içinde ortalanır (`.frame(minWidth/minHeight:)`).
  - %100 = gerçek piksel boyutu (`representations.first.pixelsWide/High`).
  - Yeni resme geçince otomatik fit moduna döner.
  - Klavye: `+`/`=` yakınlaştır, `-` uzaklaştır, `0` fit.
- **Karar:** Fareyle serbest zoom EKLENMEDİ (kullanıcı istemedi); zoom yalnız butonlardan.

### İkon ✅
- Kök dizindeki `icon.png` (1254×1254, zaten yuvarlatılmış/squircle tasarım).
- `sips` ile 16/32/64/128/256/512/1024 px üretildi →
  `miViewer/Assets.xcassets/AppIcon.appiconset/` + `Contents.json` bağlandı.
- Build `AppIcon.icns` + `Assets.car` üretiyor; Info.plist `CFBundleIconName=AppIcon`.
- **Cache notu:** Dock eski/boş ikon gösterirse (özellikle Xcode debug run'da),
  sistem ikon cache'i temizlenmeli (sudo gerekir):
  ```
  sudo rm -rf /Library/Caches/com.apple.iconservices.store
  sudo find /private/var/folders -name com.apple.dock.iconcache -delete
  killall iconservicesagent iconservicesd Dock
  ```
  Bu yapıldı ve ikon Dock'ta doğru göründü.

---

## Commit Geçmişi (main)

```
99ad789 feat: app icon from icon.png
c0b88db style: center toolbar button group; keep zoom %/counter at trailing edge
80f3b9b feat: bottom toolbar with zoom controls + prev/next buttons
3488b7d feat: polish — Esc/Space keys, fullscreen, drag-drop, window size persistence
b691f84 docs: mark phases 0-4 done; add .gitignore
385a7b9 feat: file association + non-sandboxed file access
5e12d69 feat: arrow-key navigation with wrap-around
e78f510 feat: folder scan + image display
f060764 Initial Commit
```

Çalışan ağaç temiz, son Debug build başarılı.

---

## Proje Dosya Yapısı (önemli olanlar)

```
miViewer/
├── ImageBrowser.swift     # Klasör tarama + navigasyon + dön-dolaş
├── ContentView.swift      # Görüntüleme + zoom + alt toolbar + klavye/drag-drop
├── AppDelegate.swift      # application(_:open:) dosya ilişkilendirme
├── WindowAccessor.swift    # NSWindow erişimi (boyut hatırlama)
├── miViewerApp.swift       # App giriş, environmentObject bağlama
└── Assets.xcassets/AppIcon.appiconset/   # icon_16..1024.png + Contents.json
Info.plist                  # CFBundleDocumentTypes (public.image / Viewer)
icon.png                    # Kaynak ikon (1254×1254)
ROADMAP.md / PROGRESS.md
```

---

## KALAN İŞLER (sonraki oturum)

### Faz 6 — Yerel test: varsayılan görüntüleyici yapma ⏳
- [ ] Xcode'da **Product → Build** (Release) veya `xcodebuild -configuration Release`.
- [ ] `.app`'i `/Applications`'a kopyala.
- [ ] Bir resme sağ tık → Bilgi Al → Birlikte Aç → miViewer → **Tümünü Değiştir**.
- Not: Release build alıp `.app`'i hazırlamak Claude tarafından yapılabilir;
  `/Applications`'a kopyalama ve "Tümünü Değiştir" adımı kullanıcıda.

### Faz 7 — GitHub'dan dağıtım ⏳ (büyük ölçüde kullanıcının manuel/hesap adımları)
- [ ] 7a. Code signing: Apple Developer hesabı (~99 USD/yıl) + "Developer ID Application" sertifikası.
- [ ] 7b. Notarization: Release build → `.zip`/`.dmg` → `notarytool submit ... --wait` → `stapler staple`.
- [ ] 7c. GitHub Releases'e `.dmg`/`.zip` yükle + README kurulum adımları.
- Notarization atlanırsa: README'de "sağ tık → Aç" talimatı gerekir (hobi için kabul edilebilir).

### Opsiyonel / ertelenen
- [ ] Fareyle serbest zoom/pan (şimdilik bilinçli olarak eklenmedi).
- [ ] (Düşük öncelik) Xcode konsolunda görülen SwiftUI uyarısı:
      "Publishing changes from within view updates is not allowed" — zoom/state
      güncellemelerinden kaynaklanıyor olabilir; davranışı etkilemiyor ama
      ileride `onChange`/state güncellemeleri gözden geçirilebilir.

---

## Hızlı Komutlar

```bash
# Debug build
xcodebuild -project miViewer.xcodeproj -scheme miViewer -configuration Debug build

# Build edilmiş .app'i bir resimle aç (DerivedData yolu makineye göre değişir)
open -a ".../DerivedData/miViewer-.../Build/Products/Debug/miViewer.app" /yol/resim.jpg
```
