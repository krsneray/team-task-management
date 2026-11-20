# Team Task Manager – Web

React 18 + TypeScript + Vite + Tailwind. Durum yönetimi TanStack Query, formlar React Hook Form + Zod.

## Çalıştırma
1. Backend'i başlat (`TeamTaskManager.API`, varsayılan `http://localhost:5052`).
2. `cp .env.example .env` ve gerekirse `VITE_API_URL` değerini değiştir.
3. `npm install && npm run dev`

## Komutlar
`npm run dev` · `npm run build` · `npm test` · `npm run typecheck`

## Notlar
- Oturum bilgisi `localStorage` içinde (`ttm_auth`) tutulur; token süresi dolunca otomatik çıkış yapılır.
- Filtre/sıralama/sayfa bilgisi URL'de tutulur, bağlantı paylaşılabilir.
- Proje durumu API'de güncellenemediği için görev ilerlemesinden türetilir.
- Rol ekleme yalnızca rol ekler (API rol kaldırmayı desteklemez).
