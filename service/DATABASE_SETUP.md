# Database Setup untuk E-Banking

Script ini akan membuat database dan tabel, serta mengisi data dummy untuk testing.

## Prasyarat

1. PostgreSQL sudah terinstall dan berjalan
2. Python packages terinstall:
   ```bash
   pip install sqlalchemy psycopg2-binary
   ```

## Konfigurasi Database

Default configuration (bisa diubah via environment variables):
- **DB_USER**: postgres
- **DB_PASSWORD**: postgres
- **DB_HOST**: localhost
- **DB_PORT**: 5432
- **DB_NAME**: ebanking

## Cara Menjalankan

### 1. Pastikan PostgreSQL berjalan

### 2. Jalankan setup script:
```bash
cd service
python setup_database.py
```

Script akan:
- Membuat database `ebanking` (jika belum ada)
- Membuat tabel-tabel yang diperlukan
- Mengisi data dummy untuk testing

## Data Testing

Setelah setup selesai, Anda bisa login dengan akun berikut:

### Account 1: Budi Santoso
- **Username**: `budi`
- **PIN**: `123456`
- **Accounts**:
  - `1001234567` - Tabungan Budi (Rp 5,000,000)
  - `1001234568` - Giro Budi (Rp 10,000,000)

### Account 2: Siti Aminah
- **Username**: `siti`
- **PIN**: `654321`
- **Accounts**:
  - `2001234567` - Tabungan Siti (Rp 7,500,000)

### Account 3: Ahmad Rizki
- **Username**: `ahmad`
- **PIN**: `111222`
- **Accounts**:
  - `3001234567` - Tabungan Ahmad (Rp 3,000,000)

## Testing Transfer

Contoh transfer antar akun:
- Dari: `1001234567` (Budi)
- Ke: `2001234567` (Siti)
- Jumlah: 100000

## Troubleshooting

### Error: "could not connect to server"
- Pastikan PostgreSQL service berjalan
- Check koneksi: `psql -U postgres -h localhost`

### Error: "database already exists"
- Database sudah ada, skip create database
- Script akan tetap melanjutkan create tables

### Error: "relation already exists"
- Tabel sudah ada
- Untuk reset database, drop database dulu:
  ```sql
  DROP DATABASE ebanking;
  ```
  Kemudian jalankan ulang script setup

## Custom Configuration

Jika menggunakan password PostgreSQL berbeda:

**Windows CMD:**
```cmd
set DB_PASSWORD=your_password
python setup_database.py
```

**Windows PowerShell:**
```powershell
$env:DB_PASSWORD="your_password"
python setup_database.py
```
