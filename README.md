# miViewer

Klasör-farkındalıklı, klavye ve butonlarla gezilebilen, hızlı ve sade bir
**macOS resim görüntüleyici**. Bir resmi açtığında, o resmin bulunduğu klasördeki
tüm görseller arasında dön-dolaş (wrap-around) mantığıyla gezebilirsin.

SwiftUI ile yazıldı; native, hafif ve App Store dışı (doğrudan) dağıtım için
imzalı + notarize edilmiş bir `.app`.

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

---

## Kurulum

1. [**Releases**](https://github.com/metin-aksu/miViewer/releases) sayfasından en son `miViewer-x.y.dmg` dosyasını indir.
2. DMG'yi aç, **miViewer** uygulamasını **Applications** klasörüne sürükle.
3. Uygulamayı çalıştır.

> Uygulama Apple tarafından **notarize** edilmiştir; ilk açılışta "bilinmeyen
> geliştirici" uyarısı almazsın, normal şekilde açılır.

### Varsayılan görüntüleyici yapmak (opsiyonel)

Bir resme **sağ tık → Bilgi Al** (⌘I) → **Birlikte Aç** bölümünden **miViewer**'ı
seç → **Tümünü Değiştir…** de. Artık çift tıkladığın tüm resimler miViewer ile açılır.

---

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

---

## Gereksinimler

- macOS (Apple Silicon **ve** Intel — universal binary)

---

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

---

## Proje Hakkında

Geliştirme yol haritası ve faz notları için bkz. [ROADMAP.md](ROADMAP.md) ve
[PROGRESS.md](PROGRESS.md).
