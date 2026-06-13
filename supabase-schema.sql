-- ============================================================
-- SAMBAL HORAS PEDAS - Supabase Database Schema
-- Jalankan di: Supabase Dashboard > SQL Editor
-- ============================================================

-- Tabel Produk
CREATE TABLE IF NOT EXISTS produk (
  id SERIAL PRIMARY KEY,
  nama TEXT NOT NULL,
  harga INTEGER NOT NULL,
  stok INTEGER NOT NULL DEFAULT 0,
  gambar TEXT,
  deskripsi TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Insert produk awal
INSERT INTO produk (nama, harga, stok, gambar, deskripsi) VALUES
  ('Sambal Original', 18000, 10, 'kacepeh.jpeg', 'Sambal kecepeh khas Batak, pedas gurih bikin nagih!'),
  ('Sambal Teri', 20000, 10, 'teri.jpeg', 'Perpaduan teri medan dan sambal pedas yang sempurna.'),
  ('Sambal Cumi', 25000, 10, 'cumi.jpeg', 'Cumi segar dengan bumbu sambal khas Horas.'),
  ('Sambal Andaliman', 32000, 10, 'andaliman.jpeg', 'Rempah khas Batak dengan sensasi pedas yang unik.')
ON CONFLICT DO NOTHING;

-- Tabel Pesanan
CREATE TABLE IF NOT EXISTS pesanan (
  id SERIAL PRIMARY KEY,
  nama_pembeli TEXT NOT NULL,
  hp TEXT NOT NULL,
  alamat TEXT NOT NULL,
  produk_id INTEGER REFERENCES produk(id),
  nama_produk TEXT NOT NULL,
  harga INTEGER NOT NULL,
  jumlah INTEGER NOT NULL,
  level_pedas TEXT NOT NULL,
  pembayaran TEXT NOT NULL,
  total INTEGER NOT NULL,
  status TEXT DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabel Rating & Komentar
CREATE TABLE IF NOT EXISTS ulasan (
  id SERIAL PRIMARY KEY,
  produk_id INTEGER REFERENCES produk(id),
  nama_reviewer TEXT NOT NULL,
  rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
  komentar TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- Row Level Security (RLS) - Aktifkan akses publik untuk read
-- ============================================================

ALTER TABLE produk ENABLE ROW LEVEL SECURITY;
ALTER TABLE pesanan ENABLE ROW LEVEL SECURITY;
ALTER TABLE ulasan ENABLE ROW LEVEL SECURITY;

-- Produk: siapa saja bisa baca
CREATE POLICY "produk_read_all" ON produk FOR SELECT USING (true);
-- Produk: hanya service_role yang bisa write (via API route)
CREATE POLICY "produk_write_service" ON produk FOR ALL USING (auth.role() = 'service_role');

-- Pesanan: siapa saja bisa insert (buat pesanan)
CREATE POLICY "pesanan_insert_all" ON pesanan FOR INSERT WITH CHECK (true);
-- Pesanan: hanya service_role yang bisa baca semua (admin)
CREATE POLICY "pesanan_read_service" ON pesanan FOR SELECT USING (auth.role() = 'service_role');

-- Ulasan: siapa saja bisa baca dan insert
CREATE POLICY "ulasan_read_all" ON ulasan FOR SELECT USING (true);
CREATE POLICY "ulasan_insert_all" ON ulasan FOR INSERT WITH CHECK (true);

-- ============================================================
-- Fungsi helper untuk rata-rata rating per produk
-- ============================================================
CREATE OR REPLACE VIEW produk_dengan_rating AS
SELECT 
  p.*,
  COALESCE(AVG(u.rating), 0)::NUMERIC(3,1) AS avg_rating,
  COUNT(u.id) AS jumlah_ulasan
FROM produk p
LEFT JOIN ulasan u ON u.produk_id = p.id
GROUP BY p.id;
