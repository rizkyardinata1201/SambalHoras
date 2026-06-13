# 🌶️ Sambal Horas Pedas - Next.js + Supabase

Website pemesanan sambal khas Batak dengan fitur rating dan komentar.

## Fitur
- ✅ Landing page dengan produk dan level pedas
- ✅ Form pemesanan (order) dengan validasi stok
- ✅ Cetak struk setelah pesan
- ✅ Rating bintang & komentar pelanggan
- ✅ Panel admin (kelola stok, pesanan, ulasan)
- ✅ Database Supabase (real-time, gratis)

---

## Cara Setup (Langkah demi Langkah)

### 1. Buat Project Supabase
1. Buka https://supabase.com dan daftar/login
2. Klik **New Project**
3. Isi nama project: `sambal-horas`
4. Pilih region terdekat (Singapore)
5. Buat password database dan simpan

### 2. Setup Database
1. Di dashboard Supabase, klik **SQL Editor**
2. Copy semua isi file `supabase-schema.sql`
3. Paste di SQL Editor dan klik **Run**

### 3. Ambil API Keys
1. Di Supabase, buka **Settings > API**
2. Copy:
   - **Project URL** → `NEXT_PUBLIC_SUPABASE_URL`
   - **anon public key** → `NEXT_PUBLIC_SUPABASE_ANON_KEY`

### 4. Setup Project Lokal
```bash
# Copy file .env
cp .env.local.example .env.local

# Edit .env.local dengan key Supabase kamu
nano .env.local

# Install dependencies
npm install

# Jalankan development server
npm run dev
```

Website akan jalan di http://localhost:3000

### 5. Upload Gambar
Upload gambar produk ke folder `public/img/`:
- `logo1.png`
- `kacepeh.jpeg`
- `teri.jpeg`
- `cumi.jpeg`
- `andaliman.jpeg`

---

## Deploy ke Vercel (Gratis)

1. Push project ke GitHub
2. Buka https://vercel.com dan login dengan GitHub
3. Klik **New Project** dan pilih repository ini
4. Di bagian **Environment Variables**, tambahkan:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
5. Klik **Deploy**

Website langsung jalan tanpa server PHP! ✨

---

## Struktur Folder
```
sambal-horas/
├── app/
│   ├── page.tsx          ← Halaman utama
│   ├── layout.tsx        ← Layout global
│   ├── globals.css       ← Styling
│   ├── order/
│   │   ├── page.tsx      ← Form pemesanan
│   │   └── struk/
│   │       └── page.tsx  ← Struk pesanan
│   ├── review/
│   │   └── page.tsx      ← Form ulasan & rating
│   └── admin/
│       └── page.tsx      ← Panel admin
├── components/
│   └── Navbar.tsx
├── lib/
│   └── supabase.ts       ← Koneksi + types
├── public/img/           ← Gambar produk
├── supabase-schema.sql   ← SQL untuk setup database
└── .env.local.example    ← Template environment variables
```

---

## Login Admin
- Akses: `/admin`
- Password default: `horas123`
- **Ganti password** di `app/admin/page.tsx` baris `handleLogin`

## Cara Akses Admin (Tersembunyi)
Klik logo Sambal Horas di navbar **5 kali berturut-turut** untuk masuk ke halaman admin.
