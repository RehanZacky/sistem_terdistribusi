# 🔧 FIX: Mobile App Tidak Dapat Terhubung ke Server

## ❌ Problem
```
Error: Tidak dapat terhubung ke server: ClientException: Failed to connect
uri=http://localhost:8000/internal/customer/verify
```

## ✅ Solusi

### 1. Ubah API Configuration

File: `mobile_app/lib/utils/api_config.dart`

**Sebelum:**
```dart
static const String baseUrl = 'http://localhost:8000';
```

**Sesudah:**
```dart
static const String baseUrl = 'http://127.0.0.1:8000';
```

**Kenapa?**
- `localhost` tidak selalu resolve dengan benar di Flutter web/mobile
- `127.0.0.1` adalah IP address yang lebih reliable
- Untuk mobile device fisik, gunakan IP komputer (misal: `192.168.1.10:8000`)

---

### 2. Jalankan Service API dengan Host 0.0.0.0

**Command:**
```bash
cd service
python -m uvicorn app:app --reload --host 0.0.0.0 --port 8000
```

**Kenapa `--host 0.0.0.0`?**
- Membuat API bisa diakses dari mana saja (tidak hanya localhost)
- Diperlukan untuk Flutter web dan mobile device
- Secara default uvicorn hanya listen di `127.0.0.1`

---

### 3. Hot Restart Flutter App

Setelah ubah `api_config.dart`:

**Option 1: Hot Restart**
- Tekan `R` (uppercase) di terminal Flutter
- Atau tekan `Ctrl + R` di IDE

**Option 2: Stop & Run Ulang**
```bash
# Stop: tekan 'q' di terminal Flutter
# Run ulang:
flutter run -d chrome
```

---

## 🧪 Verifikasi

### Test Service API
```bash
curl -X POST http://127.0.0.1:8000/internal/customer/verify ^
  -H "Content-Type: application/json" ^
  -d "{\"username\":\"budi\",\"pin\":\"123456\"}"
```

**Expected Response:**
```json
{
  "status": "success",
  "user_id": 1,
  "customer_name": "Budi Santoso",
  "message": "Login verified"
}
```

### Cek CORS di Service API
File `service/app.py` harus punya:
```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

---

## 📱 Platform-Specific Configuration

### Windows Desktop / Chrome Browser
```dart
static const String baseUrl = 'http://127.0.0.1:8000';
```

### Android Emulator
```dart
static const String baseUrl = 'http://10.0.2.2:8000';
```

### Android/iOS Physical Device
Cari IP komputer Anda:
```bash
ipconfig  # Windows
ifconfig  # Mac/Linux
```

Gunakan IP lokal (misal):
```dart
static const String baseUrl = 'http://192.168.1.10:8000';
```

---

## 🔥 Quick Fix Commands

```bash
# 1. Fix API config (sudah dilakukan)

# 2. Restart Service API
cd service
python -m uvicorn app:app --reload --host 0.0.0.0 --port 8000

# 3. Hot restart Flutter (di terminal Flutter tekan 'R')

# 4. Atau restart Flutter
cd mobile_app
flutter run -d chrome
```

---

## ✅ Status Setelah Fix

- ✅ API Config: `http://127.0.0.1:8000`
- ✅ Service API running di `0.0.0.0:8000`
- ✅ CORS enabled
- ✅ Import issues fixed (relative → absolute)
- ✅ Login API tested: SUCCESS

**Mobile app sekarang bisa connect ke backend!** 🎉

---

## 🐛 Troubleshooting Lanjutan

### Masih Error Connection?

1. **Check Service API Running**
   ```bash
   curl http://127.0.0.1:8000/
   ```

2. **Check Port Blocked**
   ```bash
   netstat -ano | findstr :8000
   ```

3. **Check Firewall**
   - Windows Firewall mungkin block port 8000
   - Allow Python through firewall

4. **Try Different Port**
   - Change to port 8080 or 5000
   - Update both Service API dan api_config.dart

### Browser Console Errors?

Buka DevTools (F12) di Chrome:
- Tab Console: lihat error JavaScript
- Tab Network: lihat HTTP requests
- Check apakah ada CORS errors

---

**Last Updated: December 23, 2025**
