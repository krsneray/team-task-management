# Team Task Manager

Kurumsal ekiplerin projelerini, görevlerini ve iş süreçlerini yönetmesini sağlayan görev yönetim sistemi. Bu repo sistemin **backend (ASP.NET Core Web API)** kısmını içerir; mobil (Flutter) ve web (React) istemcileri bu API'yi kullanır.

## Özellikler

- JWT ile kimlik doğrulama ve rol tabanlı yetkilendirme (Admin, ProjectManager, TeamMember)
- Proje ve görev yönetimi (oluşturma, güncelleme, silme, atama, durum ve öncelik takibi)
- Görev yorumları
- Görevlere dosya ekleme ve indirme
- Bildirimler (görev atama, durum değişikliği)
- Aktivite geçmişi
- Swagger arayüzü ile uç noktaları deneme

## Teknolojiler

ASP.NET Core Web API (.NET 10), Entity Framework Core, ASP.NET Core Identity, SQL Server (LocalDB), JWT Bearer, Swagger (Swashbuckle)

## Katmanlı yapı

| Proje | Görev |
|---|---|
| `TeamTaskManager.API` | Controller'lar, middleware, `Program.cs`, yapılandırma |
| `TeamTaskManager.Business` | İş kuralları ve servisler |
| `TeamTaskManager.DataAccess` | `AppDbContext` ve migration'lar |
| `TeamTaskManager.Entities` | Veritabanı varlıkları ve enum'lar |
| `TeamTaskManager.DTO` | İstek ve yanıt modelleri |
| `TeamTaskManager.Core` | Ortak altyapı için ayrılmış proje (şimdilik boş) |

## Roller

| Rol | Yetki |
|---|---|
| Admin | Her şey; kullanıcı kaydı ve rol atama |
| ProjectManager | Proje ve görev oluşturma, güncelleme, silme |
| TeamMember | Kendi görevlerini görme, durum güncelleme, yorum ve dosya ekleme |

Kullanıcı kaydı (`/api/auth/register`) yalnızca Admin tarafından yapılır. Yeni kullanıcı TeamMember rolüyle açılır; rolü `assign-role` ile değiştirilir.

## Kurulum

Gereksinimler: [.NET 10 SDK](https://dotnet.microsoft.com/download), SQL Server veya Visual Studio ile gelen LocalDB.

```bash
git clone https://github.com/krsneray/team-task-management.git
cd team-task-management
```

### 1. Gizli ayarlar

JWT anahtarı ve ilk yönetici parolası repoda tutulmaz; kendi makinenizde `user-secrets` ile verin:

```bash
dotnet user-secrets set "Jwt:Key" "en-az-32-karakterlik-rastgele-bir-deger" --project TeamTaskManager.API
dotnet user-secrets set "InitialAdmin:Password" "GucluBirParola123!" --project TeamTaskManager.API
```

`Jwt:Key` en az 32 karakter olmalıdır; aksi halde uygulama başlamaz. Parola en az 8 karakter olmalıdır. İlk yönetici hesabının e-postası `appsettings.json` içindeki `InitialAdmin:Email` değeridir.

### 2. Veritabanı

Bağlantı dizesi `appsettings.json` içindeki `ConnectionStrings:Default` alanındadır (varsayılan: LocalDB).

```bash
dotnet tool install --global dotnet-ef
dotnet ef database update --project TeamTaskManager.DataAccess --startup-project TeamTaskManager.API
```

### 3. Çalıştırma

```bash
dotnet run --project TeamTaskManager.API
```

Swagger arayüzü: `https://localhost:7109/swagger` (geliştirme ortamında). Giriş yapmak için `POST /api/auth/login` ile token alın, Swagger'daki **Authorize** düğmesine `Bearer {token}` yazın.

## İstemciler için CORS

Tarayıcıdan çalışan bir web istemcisi bağlanacaksa adresini izinli listeye ekleyin (`appsettings.json` ya da user-secrets):

```json
"Cors": { "AllowedOrigins": [ "http://localhost:5173" ] }
```

Mobil uygulamalar için CORS gerekmez.

## Dosya yükleme

Görevlere eklenen dosyalar `TeamTaskManager.API/Uploads/` klasörüne kaydedilir (repoya girmez). En fazla 10 MB; pdf, png, jpg, jpeg, gif, txt, doc/docx, xls/xlsx, ppt/pptx ve zip uzantılarına izin verilir.

## Ekran görüntüleri

(Swagger ve istemci ekranlarının görüntüleri buraya eklenecek.)

## Ekip

Backend ve entegrasyon: [Eray Kırşan](https://github.com/krsneray), [Ensar Demiroğlu](https://github.com/EnsarDemiroglu), [Ceren Kılıç](https://github.com/cerenklc)

## Lisans

[MIT](LICENSE)
