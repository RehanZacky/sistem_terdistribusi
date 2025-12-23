# Mobile Banking App - Flutter Version

Mobile banking application yang dibangun dengan Flutter, menggantikan versi Streamlit sebelumnya dengan fitur yang sama.

## 🎯 Fitur Utama

Sama seperti versi Streamlit sebelumnya:

1. **Login** - Autentikasi dengan username & PIN
2. **Lihat Saldo** - Menampilkan rekening Giro dengan saldo
3. **Transfer Lokal** - Transfer antar rekening dengan dropdown pilih sumber
4. **Histori Transaksi** - Menampilkan riwayat transaksi lengkap

## 📱 Screenshots Fitur

### 1. Login Page
- Username & PIN input
- Test accounts info
- Error handling

### 2. Dashboard
- Bottom navigation (Saldo, Transfer, Histori)
- Welcome message dengan nama customer
- Logout button

### 3. Lihat Saldo
- List rekening Giro (hanya CA)
- Tampilan saldo dengan format Rupiah
- Pull to refresh

### 4. Transfer Lokal
- Dropdown pilih rekening sumber (dengan info saldo)
- Input rekening tujuan
- Input jumlah transfer
- Input deskripsi
- Validasi lengkap (saldo cukup, rekening berbeda, dll)
- Success/error message

### 5. Histori Transaksi
- List semua transaksi
- Status icon (✅ success / ❌ failed)
- Detail lengkap (dari, ke, jumlah, waktu)
- Total count transaksi

## 🗄️ Test Accounts

| Username | PIN    | Customer ID | Rekening Giro | Saldo         |
|----------|--------|-------------|---------------|---------------|
| budi     | 123456 | 1           | 1001234568    | Rp 10.000.000 |
| siti     | 654321 | 2           | 2001234568    | Rp 8.000.000  |
| ahmad    | 111222 | 3           | 3001234568    | Rp 4.000.000  |

## 🚀 Cara Menjalankan

### 1. Pastikan Backend Running
```bash
cd service
uvicorn app:app --reload --port 8000
```

### 2. Jalankan Flutter App
```bash
cd mobile_app
flutter pub get
flutter run
```

Atau untuk platform spesifik:
```bash
flutter run -d windows    # Windows
flutter run -d chrome     # Web
flutter run -d <device>   # Android/iOS
```

## 📁 Struktur File Baru

```
mobile_app/lib/
├── main.dart                          # Entry point dengan session management
├── models/
│   └── user_session.dart              # Data models (UserSession, Account, Transaction)
├── providers/
│   └── session_provider.dart          # State management untuk login session
├── screens/
│   ├── login_page.dart                # Halaman login
│   ├── dashboard_page.dart            # Dashboard dengan bottom nav
│   ├── balance_page.dart              # Halaman cek saldo
│   ├── transfer_page.dart             # Halaman transfer lokal
│   └── history_page.dart              # Halaman histori transaksi
└── utils/
    ├── api_config.dart                # Konfigurasi endpoint API
    └── api_service.dart               # HTTP service layer
```

## 🔄 Perbandingan dengan Versi Streamlit

| Fitur | Streamlit (Lama) | Flutter (Baru) |
|-------|-----------------|----------------|
| Login | ✅ | ✅ |
| Lihat Saldo | ✅ | ✅ dengan pull-to-refresh |
| Transfer Lokal | ✅ | ✅ dengan validasi lebih lengkap |
| Histori | ✅ | ✅ dengan UI lebih baik |
| Session Management | st.session_state | Provider pattern |
| UI/UX | Web-based | Native mobile app |
| Responsiveness | Limited | Full responsive |
| Error Handling | Basic | Comprehensive |

## 🎨 Design System

- **Primary Color**: `#1E1E2C` (Dark blue-grey)
- **Secondary Color**: `#2A2A3C` (Lighter dark)
- **Accent Color**: `#2196F3` (Blue accent)
- **Success Color**: `#4CAF50` (Green)
- **Error Color**: `#F44336` (Red)

## 🔐 Security Features

- ✅ Customer ID validation pada setiap transfer
- ✅ Hanya bisa transfer dari rekening sendiri
- ✅ Session-based authentication
- ✅ Auto logout button
- ✅ Input validation

## 📡 API Integration

Menggunakan backend yang sama dengan versi Streamlit:
- Base URL: `http://localhost:8000`
- Endpoints:
  - `POST /internal/customer/verify` - Login
  - `GET /internal/account/customer/{id}` - Get accounts (Giro only)
  - `POST /internal/transfer/local` - Transfer
  - `GET /internal/transaction/history/{id}` - Get history

## 🐛 Troubleshooting

### Backend tidak bisa diakses
```
Error: Tidak dapat terhubung ke server
```
**Solusi**: Pastikan Service API berjalan di http://localhost:8000

### Tidak ada rekening Giro
```
Error: No giro accounts found
```
**Solusi**: Pastikan database memiliki rekening dengan `account_type='CA'`

### Transfer gagal 403
```
Error: Unauthorized: You can only transfer from your own accounts
```
**Solusi**: Ini fitur security, hanya bisa transfer dari rekening sendiri

## 📝 Notes

- App ini menggantikan versi Streamlit sebelumnya (`app.py` dan `utils.py` sudah dihapus)
- Hanya menampilkan rekening **Giro (CA)**, tabungan tidak ditampilkan
- Menggunakan Provider pattern untuk state management
- Fully responsive dan native mobile experience
- Format currency otomatis (Rp xxx.xxx)
- Pull-to-refresh di halaman saldo dan histori

## 🎯 Next Steps (Optional)

Fitur tambahan yang bisa ditambahkan:
- [ ] Biometric login (fingerprint/face ID)
- [ ] Push notifications
- [ ] QR code transfer
- [ ] Dark/Light theme toggle
- [ ] Multi-language support
- [ ] Offline mode dengan cache
- [ ] Transaction receipts (PDF/Image)

---

**Developed with Flutter & ❤️**
