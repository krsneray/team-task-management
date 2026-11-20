# Team Task Manager - Mobil Uygulama

Team Task Manager sisteminin Flutter ile geliştirilmiş mobil istemcisi. Backend API'sine (`../TeamTaskManager.API`) bağlanır.

## Özellikler

- E-posta ve parola ile giriş (JWT, token güvenli depoda saklanır)
- Ana sayfada açık görev, geciken görev ve okunmamış bildirim özeti
- Görev listesi ve görev detayı ekranı (detay ekranı şimdilik statik arayüz; API'ye bağlanması planlanıyor)
- Bildirimler
- Profil ekranı
- Açık ve koyu tema

> Kullanıcı kaydı mobil uygulamadan yapılmaz; hesaplar yönetici tarafından oluşturulur.

## Teknolojiler

Flutter (Dart ^3.12), `dio` (HTTP ve interceptor), `provider` (durum yönetimi), `flutter_secure_storage` (token), `go_router` (yönlendirme)

## Klasör yapısı

```
lib/
  models/      # API yanıt modelleri
  providers/   # Durum yönetimi (auth, görev, bildirim...)
  services/    # API istemcisi ve servisler
  views/       # Ekranlar
  themes/      # Renk paleti ve tema
  utils/       # Yardımcı fonksiyonlar (enum eşlemeleri vb.)
```

## Kurulum

1. [Flutter SDK](https://docs.flutter.dev/get-started/install) kurulu olmalı.
2. Backend'i çalıştırın (kök dizindeki README'ye bakın). Varsayılan adres: `http://localhost:5052`.
3. Bağımlılıkları yükleyin ve çalıştırın:

```bash
cd mobile
flutter pub get
flutter run
```

## API adresi

Adres `lib/services/api_service.dart` içindeki `baseUrl` alanındadır.

| Çalıştığı yer | Adres |
|---|---|
| Android emülatörü | `http://10.0.2.2:5052` (varsayılan) |
| iOS simülatörü | `http://localhost:5052` |
| Gerçek telefon | `http://<bilgisayarınızın-yerel-IP-adresi>:5052` (aynı Wi-Fi ağında olmalı) |

Gerçek telefonda `http` kullanıldığı için Android'de açık metin trafiğine izin vermek gerekebilir.

## Test girişi

Backend'i ilk kez çalıştırırken `InitialAdmin` ayarlarıyla oluşan yönetici hesabıyla giriş yapabilirsiniz (ayrıntılar kök README'de).
