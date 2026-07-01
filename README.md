<p align="center">
  <img src="icon.png" alt="miViewer" width="160">
</p>

# miViewer

A fast, minimal, folder-aware **macOS image viewer** you can navigate with the
keyboard and on-screen buttons. Open one image and browse through every picture
in the same folder with wrap-around navigation.

Built with SwiftUI; a native, lightweight, signed + notarized `.app` for direct
(non-App-Store) distribution.

*[Türkçe için aşağı kaydır ↓](#miviewer-türkçe)*

---

## Features

- 📂 **Folder awareness** — opening one image automatically lists every image in the same folder.
- 🔁 **Wrap-around navigation** — after the last image it loops to the first, and vice versa.
- 🔢 **Natural sorting** — `img2` comes before `img10` (numeric / natural order).
- 🔍 **Zoom controls** — zoom in / out / 100% (actual pixels) / fit to window; pan when zoomed in.
- ⌨️ **Keyboard + buttons** — both a bottom control bar and keyboard shortcuts.
- 🖼️ **Wide format support** — every image type the system recognizes (`public.image`: JPEG, PNG, HEIC, GIF, TIFF, WebP…).
- 🪟 **Remembers window size**, full screen, open via drag-and-drop.
- 🚫 **No sandbox** — reads the other images in the opened folder without extra permissions.

## Installation

### With Homebrew

```bash
brew tap metin-aksu/tap
brew trust metin-aksu/tap
brew install --cask miviewer
```

`brew trust` is required once because this is a third-party tap. The app installs
directly into **Applications**.

### Manual (DMG)

1. Download the latest `miViewer-x.y.dmg` from the [**Releases**](https://github.com/metin-aksu/miViewer/releases) page.
2. Open the DMG and drag **miViewer** into your **Applications** folder.
3. Launch the app.

> ⚠️ **First launch:** the app is signed with a Developer ID but not yet notarized,
> so macOS may block it the first time. To open it: **right-click (Control-click) the
> app → Open**, then confirm in the dialog. If macOS still refuses, open
> **System Settings → Privacy & Security**, scroll down and click **"Open Anyway"**.
> You only need to do this once.

### Set as default viewer (optional)

Right-click any image → **Get Info** (⌘I) → under **Open with** choose **miViewer**
→ click **Change All…**. From now on every image you double-click opens in miViewer.

## Usage

### Keyboard shortcuts

| Key | Action |
|-----|--------|
| `→` / `Space` | Next image |
| `←` | Previous image |
| `+` / `=` | Zoom in |
| `-` | Zoom out |
| `0` | Fit to window |
| `f` | Toggle full screen |
| `Esc` | Close window |

### Bottom control bar

`◀ ▶`  previous/next · `🔍−` zoom out · `100%` actual size · `🔍+` zoom in · `⤢` fit to window

The current zoom level (%) and a `index / total` counter are shown on the right edge.

### Other

- Open an image by **dragging and dropping** it onto the window.
- When zoomed in past the window size, **pan** by scrolling.

## Requirements

- **macOS 14.0 (Sonoma) or later**
- Apple Silicon **and** Intel (universal binary)

## Building from source

```bash
git clone https://github.com/metin-aksu/miViewer.git
cd miViewer
open miViewer.xcodeproj   # open in Xcode, run with ⌘R
```

or from the command line:

```bash
xcodebuild -project miViewer.xcodeproj -scheme miViewer -configuration Release build
```

## Author

Metin Aksu — [github.com/metin-aksu/miViewer](https://github.com/metin-aksu/miViewer)

---
---

# miViewer (Türkçe)

Klasör-farkındalıklı, klavye ve butonlarla gezilebilen, hızlı ve sade bir
**macOS resim görüntüleyici**. Bir resmi açtığında, o resmin bulunduğu klasördeki
tüm görseller arasında dön-dolaş (wrap-around) mantığıyla gezebilirsin.

SwiftUI ile yazıldı; native, hafif ve App Store dışı (doğrudan) dağıtım için
imzalı + notarize edilmiş bir `.app`.

*[Scroll up for English ↑](#miviewer)*

---

## Özellikler

- 📂 **Klasör farkındalığı** — bir resmi açınca aynı klasördeki tüm görseller otomatik listelenir.
- 🔁 **Dön-dolaş navigasyon** — son resimden sonra başa, ilk resimden önce sona döner.
- 🔢 **Doğal sıralama** — `img2`, `img10`'dan önce gelir (sayısal/doğal sıra).
- 🔍 **Zoom kontrolleri** — yakınlaştır / uzaklaştır / %100 (gerçek piksel) / pencereye sığdır; yakınlaşınca kaydırma (pan).
- ⌨️ **Klavye + buton** — hem alt kontrol çubuğu hem klavye kısayolları.
- 🖼️ **Geniş format desteği** — sistemin tanıdığı tüm görsel türleri (`public.image`: JPEG, PNG, HEIC, GIF, TIFF, WebP…).
- 🪟 **Pencere boyutunu hatırlar**, tam ekran, sürükle-bırak ile açma.
- 🚫 **Sandbox'sız** — açılan klasördeki resimleri ek izin istemeden okur.

## Kurulum

### Homebrew ile

```bash
brew tap metin-aksu/tap
brew trust metin-aksu/tap
brew install --cask miviewer
```

`brew trust` bir kez gereklidir (bu üçüncü taraf bir tap olduğu için). Uygulama
doğrudan **Applications** klasörüne kurulur.

### Elle (DMG)

1. [**Releases**](https://github.com/metin-aksu/miViewer/releases) sayfasından en son `miViewer-x.y.dmg` dosyasını indir.
2. DMG'yi aç, **miViewer** uygulamasını **Applications** klasörüne sürükle.
3. Uygulamayı çalıştır.

> ⚠️ **İlk açılış:** Uygulama Developer ID ile imzalı ama henüz notarize edilmedi;
> bu yüzden macOS ilk seferde engelleyebilir. Açmak için: uygulamaya **sağ tık
> (Control-tık) → Aç** de ve çıkan uyarıda onayla. Yine açılmazsa **Sistem Ayarları
> → Gizlilik ve Güvenlik**'e gir, aşağı in ve **"Yine de Aç"** butonuna bas. Bunu
> sadece bir kez yapman yeterli.

### Varsayılan görüntüleyici yapmak (opsiyonel)

Bir resme **sağ tık → Bilgi Al** (⌘I) → **Birlikte Aç** bölümünden **miViewer**'ı
seç → **Tümünü Değiştir…** de. Artık çift tıkladığın tüm resimler miViewer ile açılır.

## Kullanım

### Klavye Kısayolları

| Tuş | İşlev |
|-----|-------|
| `→` / `Space` | Sonraki resim |
| `←` | Önceki resim |
| `+` / `=` | Yakınlaştır |
| `-` | Uzaklaştır |
| `0` | Pencereye sığdır |
| `f` | Tam ekran aç/kapat |
| `Esc` | Pencereyi kapat |

### Alt Kontrol Çubuğu

`◀ ▶`  önceki/sonraki · `🔍−` uzaklaştır · `100%` gerçek boyut · `🔍+` yakınlaştır · `⤢` pencereye sığdır

Sağ kenarda o anki zoom oranı (%) ve `sıra / toplam` sayacı gösterilir.

### Diğer

- Bir resmi pencereye **sürükle-bırak** ederek açabilirsin.
- Yakınlaştırınca resim pencereye sığmazsa **kaydırarak (pan)** gezebilirsin.

## Gereksinimler

- **macOS 14.0 (Sonoma) veya üzeri**
- Apple Silicon **ve** Intel (universal binary)

## Kaynaktan Derleme

```bash
git clone https://github.com/metin-aksu/miViewer.git
cd miViewer
open miViewer.xcodeproj   # Xcode'da aç, ⌘R ile çalıştır
```

veya komut satırından:

```bash
xcodebuild -project miViewer.xcodeproj -scheme miViewer -configuration Release build
```

## Yazar

Metin Aksu — [github.com/metin-aksu/miViewer](https://github.com/metin-aksu/miViewer)
