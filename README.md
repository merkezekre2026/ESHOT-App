# ESHOT Saatleri (SwiftUI)

İzmir ESHOT hat/durak/saat odaklı, SwiftUI + MVVM mimarili iOS uygulaması.

## Mimari Özeti

- **UI:** SwiftUI (Home, Hat Arama, Durak Arama, Yakındaki Duraklar, Favoriler)
- **Mimari:** MVVM + Repository
- **Ağ:** `URLSession` tabanlı `NetworkManager`
- **Veri Katmanı:**
  - `GTFSService` (GTFS zip indirme + parse)
  - `StopsService` (resmî durak CSV)
  - `TimetableService` (saat verisi birleşimi)
  - `LiveArrivalService` (durağa yaklaşan otobüsler)
  - `LocationService` (yakın durak)
  - `FavoritesService` (SwiftData kalıcılık)
- **Kalıcı Veri:** SwiftData (favoriler) + dosya tabanlı cache (statik dataset)
- **Asenkron:** async/await
- **Arama:** Türkçe karakter normalize + debounce

## Dizin Yapısı

```text
ESHOTSaatleri/
  App/
  Core/
    Networking/
    Persistence/
    Extensions/
    Utilities/
  Domain/
    Models/
    Repositories/
  Data/
    DTOs/
    Parsers/
    Services/
    Repositories/
  Features/
    Home/
    Lines/
    Stops/
    Nearby/
    Favorites/
    Shared/
ESHOTSaatleriTests/
```

## Resmî Veri Kaynakları ve Endpoint Ayarları

`ESHOTSaatleri/Core/Networking/Endpoint.swift` içinde merkezi olarak tutulur:

- ESHOT GTFS ZIP
- Otobüs Durakları CSV
- Otobüs Hareket Saatleri CSV
- Durağa Yaklaşan Otobüsler API

> Not: Açık veri portallarında zamanla URL değişebildiğinden, üretim öncesi bu URL’leri güncelleyin.

## Çalıştırma

1. Xcode 15.3+ ile proje açın.
2. iOS target için aşağıdakileri ekleyin:
   - `NSLocationWhenInUseUsageDescription`
3. Gerekliyse `ZIPFoundation` paketini ekleyin (GTFS zip açma için).
4. Uygulamayı çalıştırın.

## Veri Akışı

1. App açılışında repository `refreshIfNeeded` tetiklenir (24 saat kuralı).
2. Statik veriler cache’e yazılır.
3. Arama ekranları yerel bellekteki indekslerden sonuç döndürür.
4. Durak detayında canlı veri endpoint’i çağrılır; başarısızsa boş durum gösterilir.

## Offline Davranış

- Statik GTFS/CSV veriler cache’teyse offline modda listelenir.
- Canlı varış endpoint’i başarısızsa ekran “canlı veri yok” mesajına düşer.
- Favoriler cihazda kalıcıdır.

## Varsayımlar

- GTFS dosyasında `routes.txt`, `stops.txt`, `trips.txt`, `stop_times.txt` bulunur.
- Durak CSV şeması en az `id;code;name;lat;lon` sütunlarını içerir.
- Canlı varış API’si stop kodu/query param ile çalışır.

## Fallback Stratejileri

- Canlı endpoint yok/hata: boş arrival listesi + kullanıcı dostu durum metni.
- GTFS erişilemiyor ve cache yok: ekran hata/yeniden dene durumu.
- Konum yok: yakın durak ekranında hata durumu + izin yönlendirmesi.


## GitHub Actions: İmzasız IPA Build

Repo içinde `.github/workflows/build-unsigned-ipa.yml` ile imzasız IPA üretimi tanımlıdır.

- Tetikleme: `workflow_dispatch` (manuel) veya ilgili dosyalarda `push`
- Derleme: `xcodebuild archive` + `CODE_SIGNING_ALLOWED=NO`
- Paketleme: archive içindeki `.app` → `Payload/` → `*.ipa`
- Çıktı: Actions artifact olarak `unsigned-ipa`

> Not: Workflow'un çalışması için repoda bir `.xcodeproj` veya `.xcworkspace` bulunmalıdır.

## Sonraki İyileştirmeler

1. GTFS `trips + stop_times` ile tam yön bazlı sefer gruplanması.
2. Yerel full-text indeks (SQLite FTS) ile çok hızlı arama.
3. Background App Refresh ile sessiz dataset güncelleme.
4. Widget/Live Activity ile favori durak canlı varış.
5. Snapshot/UI testleri ve kapsamlı parser edge-case testleri.
