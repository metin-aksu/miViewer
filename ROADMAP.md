# macOS Resim Görüntüleyici — Yol Haritası

Klasör-farkındalıklı, klavyeyle gezilebilen, dön-dolaş (wrap-around) navigasyonlu
native bir macOS resim görüntüleyici. SwiftUI + Xcode ile yazılacak, GitHub
üzerinden dağıtılacak.

> Placeholder uygulama adı: **FlipView** (kendi adınla değiştir).

---

## Teknoloji ve Gerekçe

**Native SwiftUI + Xcode** macOS uygulaması.

- Resim açma hızı, klavye tepkisi ve "varsayılan uygulama" entegrasyonu ancak
  gerçek bir `.app` paketiyle düzgün olur.
- Electron/web tabanlı bir çözüm hem ağır olurdu hem de dosya ilişkilendirme
  tarafında sürtünmeli olurdu.

---

## Başlamadan Bilinmesi Gereken 3 Kritik Nokta

1. **App Sandbox kapalı kalacak (dağıtım kararı).**
   App Sandbox yalnızca Mac App Store için zorunludur. GitHub'dan dağıtım = App
   Store dışı dağıtım, dolayısıyla Sandbox'a hiç gerek yok. Sandbox'sız uygulama,
   kullanıcının hesabının okuyabildiği her dosyayı okur. Kullanıcı bir resmi
   açtığında, uygulama o klasördeki diğer resimleri **hiçbir ek izin olmadan**
   okur. Son kullanıcının Sandbox veya Full Disk Access ile ilgili hiçbir şey
   yapmasına gerek yoktur. (Full Disk Access bu iş için yanlış ve aşırı bir
   izindir — kullanılmayacak.)

2. **Dosya ilişkilendirmesi Info.plist üzerinden olur.**
   "Bir resme tıklayınca bu açılsın" işi, `CFBundleDocumentTypes` içinde
   `public.image` türünü açabildiğini belirtmenle çalışır.

3. **Ok tuşları için macOS 14+ gerekir** (`.onKeyPress` API'si).
   Daha eski sürümde `NSEvent` monitörü gerekir; güncel sürümde modern yol
   kullanılacak.

---

## Faz 0 — Hazırlık

- [x] App Store'dan Xcode kurulu olsun. (Xcode 26.5)
- [x] Uygulama adı seç (placeholder: `FlipView`). → **miViewer**

---

## Faz 1 — Boş Proje (elle, ~2 dk)

Xcode → New Project → **macOS** → **App**
- Interface: **SwiftUI**
- Language: **Swift**
- İsim ver, testleri kapatabilirsin.

Bu, iskeleti verir; gerisini Claude Code dolduracak.

---

## Faz 2 — Çekirdek: Klasör Tarama + Resmi Gösterme ✅

> Tamamlandı: `ImageBrowser.swift` (UTType.image filtresi + localizedStandardCompare
> doğal sıralama), `ContentView` resmi aspect-fit gösteriyor, pencere başlığı dosya adı.

**Claude Code prompt:**

```
Bu bir macOS SwiftUI uygulaması. Bir resim görüntüleyici yazıyorum.

ImageBrowser adında bir ObservableObject sınıfı oluştur:
- Başlangıç parametresi olarak bir dosya URL'i (açılan resim) alsın.
- O dosyanın bulunduğu klasörü FileManager ile tarasın.
- Sadece görsel dosyaları filtrelesin. Filtrelemeyi uzantı listesi yerine
  UTType ile yap: her dosyanın type'ı UTType.image'e conform ediyor mu diye kontrol et.
- Dosyaları doğal sıralamayla sırala (image2, image10'dan önce gelmeli) —
  localizedStandardCompare kullan.
- @Published currentIndex tut. Başlangıçta açılan dosyanın index'ine ayarla.
- currentURL hesaplanmış property'si olsun.

ContentView'de ImageBrowser'ı @StateObject olarak kullan ve currentURL'deki
resmi pencereye sığacak şekilde göster (aspect ratio korunarak, fit). Pencere
başlığı dosya adı olsun.
```

**Commit:** `feat: folder scan + image display`

---

## Faz 3 — Ok Tuşlarıyla Gezinme (Dön-Dolaş Mantığı) ✅

> Tamamlandı: `next()`/`previous()` dön-dolaş, `ContentView`'de `.onKeyPress`
> (sağ/sol ok) + `.focusable()` ve `@FocusState` ile klavye odağı.

Dön-dolaş (wrap-around) basit modüler aritmetiktir:
- İleri: `(currentIndex + 1) % count`
- Geri: `(currentIndex - 1 + count) % count`

**Claude Code prompt:**

```
ImageBrowser'a next() ve previous() metodları ekle. Son resimdeyken next()
ilk resme dönsün, ilk resimdeyken previous() son resme gitsin (dön-dolaş):
  next:     currentIndex = (currentIndex + 1) % count
  previous: currentIndex = (currentIndex - 1 + count) % count

ContentView'e .onKeyPress(.rightArrow) ve .onKeyPress(.leftArrow) ekle;
sağ ok next(), sol ok previous() çağırsın. Görünümün klavye odağını
alabildiğinden emin ol (gerekiyorsa focusable() kullan).
```

**Commit:** `feat: arrow-key navigation with wrap-around`

> Bu faz çalıştığında elinde zaten kullanılabilir bir görüntüleyici var.

---

## Faz 4 — Resme Tıklayınca Uygulamanın Açılması + Sandbox'sız Yapı ✅

> Tamamlandı: `AppDelegate` + `@NSApplicationDelegateAdaptor`, `application(_:open:)`
> gelen URL'i paylaşılan `ImageBrowser`'a (environmentObject) aktarıyor; `Info.plist`
> içinde `CFBundleDocumentTypes` (public.image, Viewer rolü); `ENABLE_APP_SANDBOX = NO`.

**Claude Code prompt:**

```
Uygulamanın, bir resme çift tıklandığında o resimle açılmasını istiyorum.

1. @NSApplicationDelegateAdaptor ile bir AppDelegate ekle ve
   application(_:open:) metodunu uygula. Gelen URL'i ImageBrowser'a aktar
   (örneğin paylaşılan bir state üzerinden ContentView'e ulaştır).

2. Info.plist'e CFBundleDocumentTypes ekle: public.image türünü "Viewer"
   rolüyle handle ettiğini belirt. Böylece macOS bu uygulamayı resimler için
   "Birlikte Aç" listesinde gösterir.

3. App Sandbox'ı KAPALI tut (Signing & Capabilities'te App Sandbox capability'si
   EKLENMESİN). GitHub'dan dağıtacağım için App Store kısıtı yok; sandbox'sız
   uygulama, açılan resmin klasöründeki diğer resimleri ek izin olmadan okur.
```

**Commit:** `feat: file association + non-sandboxed file access`

---

## Faz 5 — Cilalama (opsiyonel)

Temel sürüm çalıştıktan sonra tek tek eklenebilir:

- [x] `Esc` ile pencereyi kapatma
- [x] `Space` ile ileri gitme
- [x] Zoom kontrolleri — resim alanının altındaki çubukta: ◀ ▶ (önceki/sonraki),
      uzaklaştır, %100, yakınlaştır, pencereye sığdır + zoom oranı ve sayfa sayacı.
      (Fareyle pan, zoom'da ScrollView ile.)
- [x] Pencere boyutunu hatırlama (`WindowAccessor` + `setFrameAutosaveName`)
- [x] Tam ekran (`f` tuşu → `toggleFullScreen`)
- [x] Sürükle-bırak ile resim açma (`dropDestination`)

---

## Faz 6 — Yerel Test: Varsayılan Görüntüleyici Yapma

- [ ] Xcode'da **Product → Build** (Release).
- [ ] `.app`'i `/Applications`'a kopyala.
- [ ] Bir resme sağ tık → **Bilgi Al** → **Birlikte Aç** → uygulamanı seç →
      **Tümünü Değiştir**.

Artık çift tıkladığın her resim seninkiyle açılır.

---

## Faz 7 — GitHub'dan Dağıtım (code sign + notarization)

Amaç: Başkaları indirip "uygulama hasarlı / açılamıyor" uyarısı almadan
çalıştırabilsin.

### 7a. Code Signing
- [ ] Apple Developer hesabı (yıllık ~99 USD).
- [ ] Xcode'da "Developer ID Application" sertifikasıyla imzala
      (App Store değil, doğrudan dağıtım için olan sertifika).

### 7b. Notarization
- [ ] Release build al, `.app`'i bir `.zip` veya `.dmg` içine koy.
- [ ] `notarytool` ile Apple'a gönder, onaylanınca `stapler` ile bileti
      uygulamaya iliştir:
  ```
  xcrun notarytool submit FlipView.zip --keychain-profile "AC_PASSWORD" --wait
  xcrun stapler staple FlipView.app
  ```

### 7c. Yayınlama
- [ ] `.dmg` (veya `.zip`) dosyasını GitHub Releases'e yükle.
- [ ] README'ye kurulum adımlarını yaz (sürükle → /Applications'a bırak).

> **Notarization'ı atlarsan:** Yine dağıtabilirsin ama README'de kullanıcılara
> "sağ tık → Aç" adımını anlatman gerekir. Hobi projesi için kabul edilebilir,
> profesyonel görünüm için 7a/7b önerilir.

---

## Genel Prensip

Her fazdan sonra çalışan halini test et ve commit at. Özellikle Faz 2 ve 3
çalıştığında elinde zaten kullanılabilir bir görüntüleyici olur; dosya
ilişkilendirmesi (Faz 4) ve dağıtım (Faz 7) onun üstüne eklenir.