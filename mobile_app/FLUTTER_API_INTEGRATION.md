# Integrasi Flutter Banking App dengan FastAPI Backend

## 📁 File yang Ditambahkan

### 1. **lib/utils/api_config.dart**
Konfigurasi endpoint API untuk koneksi ke FastAPI backend.

**Base URL:** `http://localhost:8000`

**Endpoints:**
- `/internal/customer/verify` - Login/verifikasi customer
- `/internal/account/customer/{id}` - Ambil rekening Giro customer
- `/internal/account/balance/{account_number}` - Cek saldo rekening
- `/internal/transfer/local` - Transfer lokal antar rekening
- `/internal/transaction/history/{customer_id}` - Histori transaksi

### 2. **lib/utils/api_service.dart**
Service layer untuk HTTP requests ke backend.

**Methods:**
- `verifyCustomer()` - Login dengan username & PIN
- `getAccounts()` - Ambil daftar rekening Giro (hanya CA)
- `getBalance()` - Cek saldo rekening tertentu
- `localTransfer()` - Transfer uang antar rekening
- `getTransactionHistory()` - Ambil histori transaksi

## 🔧 Cara Menggunakan

### 1. Install Dependencies
```bash
cd mobile_app
flutter pub get
```

### 2. Import di File Dart
```dart
import 'package:flutter_banking_app/utils/api_service.dart';
```

### 3. Contoh Penggunaan

#### Login
```dart
final result = await ApiService.verifyCustomer(
  username: 'budi',
  pin: '123456',
);

if (result['status'] == 'success') {
  int userId = result['user_id'];
  String customerName = result['customer_name'];
}
```

#### Ambil Rekening
```dart
final result = await ApiService.getAccounts(customerId);

if (result['status'] == 'success') {
  List accounts = result['accounts'];
  // accounts hanya berisi rekening Giro (CA)
}
```

#### Transfer
```dart
final result = await ApiService.localTransfer(
  fromAccount: '1001234568',
  toAccount: '2001234568',
  amount: 100000.0,
  customerId: 1,
  description: 'Transfer ke Siti',
);

if (result['status'] == 'success') {
  String transactionId = result['transaction_id'];
}
```

## 🗄️ Test Accounts

| Username | PIN    | Customer ID | Rekening Giro      | Saldo          |
|----------|--------|-------------|--------------------|----------------|
| budi     | 123456 | 1           | 1001234568         | Rp 10.000.000  |
| siti     | 654321 | 2           | 2001234568         | Rp 8.000.000   |
| ahmad    | 111222 | 3           | 3001234568         | Rp 4.000.000   |

## ⚠️ Catatan Penting

1. **Hanya Rekening Giro (CA)** yang bisa diakses via mobile app
2. Setiap customer punya Tabungan (SA) dan Giro (CA), tapi mobile app hanya lihat Giro
3. Backend API harus berjalan di `http://localhost:8000`
4. Security: Transfer hanya bisa dari rekening milik sendiri (ada validasi customer_id)

## 🚀 Menjalankan Aplikasi

### Backend (FastAPI)
```bash
cd service
uvicorn app:app --reload --port 8000
```

### Mobile App (Flutter)
```bash
cd mobile_app
flutter run
```

## 📱 Fitur yang Tersedia

✅ Login dengan username & PIN
✅ Lihat daftar rekening Giro
✅ Cek saldo rekening
✅ Transfer lokal antar rekening
✅ Histori transaksi
✅ Security validation (ownership check)

## 🔐 Security Features

- Customer hanya bisa transfer dari rekening sendiri
- Validasi customer_id di setiap request transfer
- 403 Forbidden jika coba akses rekening orang lain
- 400 Bad Request jika data tidak lengkap
