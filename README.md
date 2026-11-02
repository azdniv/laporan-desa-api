# API Portal Lapor Desa

REST API untuk Portal Kanal Aspirasi dan Lapor Desa. Warga mengirim laporan, mendapat nomor tiket, dan memantau status penanganan. Perangkat desa menanggapi laporan dan memperbarui statusnya.

## Teknologi
Node.js, Express.js, PostgreSQL

## Cara menjalankan
1. Pasang Node.js dan PostgreSQL.
2. Buat database `laporan_desa`, lalu jalankan `database/schema.sql`. Data contoh opsional: `database/seed.sql`.
3. Salin `.env.example` menjadi `.env`, lalu isi `DB_PASSWORD`.
4. Install dan jalankan:
   ```
   npm install
   npm run dev
   ```
5. Buka `http://localhost:3000`.

## Struktur tabel
`users`, `reports`, `responses` (lihat `database/schema.sql`).

## Endpoint
| Method | Endpoint | Fungsi |
| :- | :- | :- |
| GET | /reports | Menampilkan semua laporan. Filter: `?ticket_number=...` |
| POST | /reports | Mengirim laporan baru |
| PUT | /reports/:id | Admin menanggapi laporan dan memperbarui status |
| DELETE | /reports/:id | Menghapus laporan |

## Contoh body
POST /reports
```json
{ "user_id": 1, "category": "Penerangan", "title": "Lampu jalan mati",
  "description": "Lampu jalan di gang masjid mati.", "location": "Gang Masjid" }
```
PUT /reports/:id
```json
{ "admin_id": 2, "response_text": "Sudah dilaporkan.", "new_status": "diproses" }
```

## Keterbatasan
Belum ada autentikasi. `user_id` dan `admin_id` dikirim lewat body request.