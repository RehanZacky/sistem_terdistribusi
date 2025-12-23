# 🚀 PANDUAN MENJALANKAN SISTEM E-BANKING TERDISTRIBUSI

## 📋 Ringkasan Sistem

Sistem e-banking terdistribusi terdiri dari 3 komponen utama:
1. **Service API** (Backend) - Port 8000
2. **Middleware API** - Port 8001  
3. **Mobile App** (Flutter) - Chrome/Windows/Mobile

---

## ⚙️ CARA MENJALANKAN SISTEM

### 🔧 Persiapan Awal

Pastikan semua requirement sudah terinstall:
- ✅ Python 3.x
- ✅ Flutter SDK
- ✅ Dependencies Python (FastAPI, uvicorn, sqlalchemy, dll)
- ✅ Dependencies Flutter (http, provider, dll)

---

### 1️⃣ **Jalankan Service API (Backend)**

**Terminal 1:**
```bash
cd c:\Users\INFINIX\Documents\Tugas\sistem_terdistribusi\service
python -m uvicorn app:app --reload --port 8000
```

**Atau buka terminal baru:**
```bash
cd service
start "Service API" cmd /k "python -m uvicorn app:app --reload --port 8000"
```

**Verifikasi:**
- Buka browser: http://localhost:8000/docs
- Anda akan melihat Swagger UI dengan semua endpoint

**Status:** ✅ Service API Running di http://localhost:8000

---

### 2️⃣ **Jalankan Middleware API**

**Terminal 2:**
```bash
cd c:\Users\INFINIX\Documents\Tugas\sistem_terdistribusi\middleware
python -m uvicorn app:app --reload --port 8001
```

**Atau buka terminal baru:**
```bash
cd middleware
start "Middleware API" cmd /k "python -m uvicorn app:app --reload --port 8001"
```

**Verifikasi:**
- Buka browser: http://localhost:8001/docs
- Anda akan melihat Swagger UI untuk middleware

**Status:** ✅ Middleware API Running di http://localhost:8001

---

### 3️⃣ **Jalankan Flutter Mobile App**

**Terminal 3:**
```bash
cd c:\Users\INFINIX\Documents\Tugas\sistem_terdistribusi\mobile_app
flutter run -d chrome
```

**Pilihan Platform:**
```bash
# Untuk Windows Desktop
flutter run -d windows

# Untuk Chrome Browser (Recommended untuk testing)
flutter run -d chrome

# Untuk Android (jika ada device/emulator)
flutter run -d <device-id>

# List semua device yang tersedia
flutter devices
```

**Atau buka terminal baru:**
```bash
cd mobile_app
start "Flutter Mobile App" cmd /k "flutter run -d chrome"
```

**Status:** ✅ Mobile App akan terbuka di browser/windows

---

## 🎯 QUICK START (Jalankan Semua Sekaligus)

Buka **Command Prompt** dan jalankan satu per satu:

```bash
# Terminal 1 - Service API
start "Service API" cmd /k "cd c:\Users\INFINIX\Documents\Tugas\sistem_terdistribusi\service && python -m uvicorn app:app --reload --port 8000"

# Terminal 2 - Middleware API
start "Middleware API" cmd /k "cd c:\Users\INFINIX\Documents\Tugas\sistem_terdistribusi\middleware && python -m uvicorn app:app --reload --port 8001"

# Terminal 3 - Flutter Mobile App
start "Flutter Mobile App" cmd /k "cd c:\Users\INFINIX\Documents\Tugas\sistem_terdistribusi\mobile_app && flutter run -d chrome"
```

---

## 📱 CARA MENGGUNAKAN MOBILE APP

### Login
1. Buka mobile app
2. Masukkan username dan PIN:
   - **budi** / **123456** (Customer ID: 1)
   - **siti** / **654321** (Customer ID: 2)
   - **ahmad** / **111222** (Customer ID: 3)

### Fitur yang Tersedia
1. **💰 Lihat Saldo** - Menampilkan rekening Giro dengan saldo
2. **💸 Transfer Lokal** - Transfer antar rekening
3. **📜 Histori Transaksi** - Riwayat transaksi lengkap
4. **🚪 Logout** - Keluar dari aplikasi

---

## 🧪 TEST ACCOUNTS & SALDO

| Username | PIN    | Customer ID | Rekening Giro | Saldo Awal     |
|----------|--------|-------------|---------------|----------------|
| budi     | 123456 | 1           | 1001234568    | Rp 10.000.000  |
| siti     | 654321 | 2           | 2001234568    | Rp 8.000.000   |
| ahmad    | 111222 | 3           | 3001234568    | Rp 4.000.000   |

**Note:** Setiap customer juga punya rekening Tabungan, tapi tidak ditampilkan di mobile app (hanya Giro).

---

## 🔍 VERIFIKASI SISTEM BERJALAN

### Cek Service API
```bash
curl http://localhost:8000/docs
```
Atau buka browser: http://localhost:8000/docs

### Cek Middleware API
```bash
curl http://localhost:8001/docs
```
Atau buka browser: http://localhost:8001/docs

### Test Login via API
```bash
curl -X POST http://localhost:8000/internal/customer/verify ^
  -H "Content-Type: application/json" ^
  -d "{\"username\":\"budi\",\"pin\":\"123456\"}"
```

**Expected Response:**
```json
{
  "status": "success",
  "user_id": 1,
  "customer_name": "Budi Santoso",
  "username": "budi"
}
```

---

## 🛑 CARA MENGHENTIKAN SISTEM

### Stop Service API
- Tekan `Ctrl + C` di terminal Service API

### Stop Middleware API
- Tekan `Ctrl + C` di terminal Middleware API

### Stop Flutter App
- Tekan `q` di terminal Flutter
- Atau tutup browser/window aplikasi

### Stop Semua Sekaligus
- Tutup semua terminal/command prompt windows

---

## 🔧 TROUBLESHOOTING

### ❌ Port Already in Use
```
ERROR: Address already in use
```
**Solusi:**
```bash
# Cari process yang menggunakan port
netstat -ano | findstr :8000

# Kill process (ganti PID dengan nomor yang muncul)
taskkill /PID <PID> /F
```

### ❌ Module Not Found
```
ModuleNotFoundError: No module named 'fastapi'
```
**Solusi:**
```bash
cd service
pip install -r requirements.txt
```

### ❌ Flutter Command Not Found
```
'flutter' is not recognized
```
**Solusi:**
- Install Flutter SDK dari https://flutter.dev
- Tambahkan Flutter ke PATH environment variable

### ❌ Database Not Found
```
Error: No such table: m_customer
```
**Solusi:**
```bash
cd service
python setup_database_sqlite.py
```

### ❌ Mobile App Can't Connect to Backend
```
Error: Tidak dapat terhubung ke server
```
**Solusi:**
1. Pastikan Service API running di http://localhost:8000
2. Cek file `lib/utils/api_config.dart` - baseUrl harus `http://localhost:8000`
3. Restart Flutter app

---

## 📊 MONITORING & LOGS

### Service API Logs
Terminal Service API akan menampilkan:
- Request yang masuk
- Response status codes
- Errors (jika ada)

### Middleware API Logs
Terminal Middleware API akan menampilkan:
- Request dari mobile app
- Forwarded requests ke service
- Errors (jika ada)

### Flutter App Logs
Terminal Flutter akan menampilkan:
- Hot reload status
- HTTP requests
- UI errors (jika ada)

---

## 🎯 ENDPOINTS YANG TERSEDIA

### Service API (Port 8000)
- `POST /internal/customer/verify` - Login
- `GET /internal/account/customer/{id}` - Get accounts (Giro only)
- `GET /internal/account/balance/{account_number}` - Get balance
- `POST /internal/transfer/local` - Local transfer
- `GET /internal/transaction/history/{id}` - Transaction history
- `POST /internal/account/debit` - Debit account
- `POST /internal/account/credit` - Credit account

### Middleware API (Port 8001)
- `POST /interbank/transfer` - Interbank transfer
- `GET /interbank/status/{transaction_id}` - Check transfer status

---

## 📝 CATATAN PENTING

1. **Database Location**: `service/ebanking.db` (SQLite)
2. **Auto Reload**: Service & Middleware akan auto-reload saat ada perubahan kode
3. **Hot Reload Flutter**: Tekan `r` di terminal Flutter untuk hot reload
4. **Security**: Customer hanya bisa transfer dari rekening sendiri
5. **Rekening Giro Only**: Mobile app hanya menampilkan rekening dengan `account_type='CA'`

---

## 🎊 SISTEM SIAP DIGUNAKAN!

Setelah semua komponen berjalan:
1. ✅ Service API di http://localhost:8000
2. ✅ Middleware API di http://localhost:8001
3. ✅ Mobile App terbuka di browser/windows
4. ✅ Login dengan test account (budi/123456)
5. ✅ Mulai menggunakan fitur mobile banking!

---

**Happy Banking! 💳✨**

*Last Updated: December 23, 2025*
