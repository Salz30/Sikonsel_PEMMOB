# 📱 SIKONSEL Mobile (Sistem Informasi Konseling Sekolah)

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg) ![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-green) ![Backend](https://img.shields.io/badge/backend-PHP%20Native-purple)

**Sikonsel Mobile** adalah ekstensi aplikasi berbasis smartphone dari ekosistem Sikonsel. Aplikasi ini dirancang untuk memberikan aksesibilitas *real-time* bagi Siswa, Guru BK, dan Orang Tua dalam melakukan layanan bimbingan konseling tanpa terikat lokasi dan waktu (24/7), melengkapi versi Web yang digunakan di lingkungan sekolah.

---

## 🚀 Latar Belakang & Tujuan
Dalam era digital, masalah kesehatan mental dan akademik siswa bisa terjadi kapan saja. Sikonsel Mobile hadir sebagai solusi **"Counseling in Your Pocket"** dengan tujuan:
1.  **Respon Cepat:** Guru BK mendapatkan notifikasi instan saat ada laporan masuk.
2.  **Privasi Terjamin:** Siswa dapat bercerita di ruang privat tanpa harus terlihat masuk ke ruang BK.
3.  **Integrasi Orang Tua:** Memudahkan wali murid memantau/melapor tanpa prosedur administrasi yang rumit.
4.  **Single Source of Truth:** Menggunakan database yang sama dengan Sikonsel Web, sehingga data selalu sinkron.

---

## 🌟 Fitur Unggulan (Berdasarkan Role)

### 🎓 1. Role Siswa
Akses personal bagi siswa untuk mendapatkan bantuan mental dan akademik.
* **🔐 Curhat Online Terenkripsi:** Mengirim laporan masalah (Bullying, Akademik, Keluarga) dengan keamanan enkripsi AES-256. Isi curhatan tidak bisa dibaca oleh siapapun kecuali Guru BK.
* **📅 Reservasi Konseling:** Mengajukan jadwal temu tatap muka dengan Guru BK secara digital (pilih tanggal & jam).
* **📂 Riwayat & Status:** Memantau status laporan (*Pending* ➔ *Diproses* ➔ *Selesai*) secara real-time.
* **🔔 Push Notification:** Notifikasi saat jadwal disetujui atau laporan ditanggapi.

### 👩‍🏫 2. Role Guru BK (Admin)
Alat manajemen konseling mobile untuk Guru yang dinamis.
* **📱 Dashboard Monitoring:** Melihat ringkasan laporan masuk hari ini di HP.
* **⚡ Quick Action:** Menyetujui jadwal temu atau mengubah status laporan (Tindak Lanjut) dengan satu sentuhan.
* **📞 One-Tap Contact:** Menghubungi siswa atau orang tua via WhatsApp langsung dari aplikasi.
* **📊 Manajemen Data Siswa:** Melihat profil singkat siswa saat melakukan *home visit*.

### 👨‍👩‍👧 3. Role Orang Tua (Public Access)
Fitur khusus untuk menjembatani komunikasi rumah dan sekolah.
* **📝 Pelaporan Wali:** Form khusus untuk melaporkan masalah anak di rumah.
* **🛡️ Verifikasi Data:** Tanpa perlu Login/Registrasi rumit. Cukup verifikasi menggunakan **NISN + Tanggal Lahir Anak** + Data Wali.
* **🔒 Sesi Aman:** Sistem keamanan *Auto-Destroy Session* untuk mencegah data tertinggal di perangkat umum.

---

## 🏗️ Arsitektur Teknis

Project ini menggunakan konsep **Hybrid Architecture**. Web dan Mobile berbagi Database dan Logika Bisnis yang sama.

### Tech Stack
| Komponen | Teknologi | Keterangan |
| :--- | :--- | :--- |
| **Mobile App** | Flutter | Antarmuka Pengguna (Web/Android) |
| **Backend API** | PHP Native | RESTful API (JSON Response) |
| **Database** | MySQL | Penyimpanan Data Terpusat |
| **Security** | OpenSSL (AES-256) | Enkripsi Database |

### Topologi Sistem
```text
[📱 HP Siswa]      [📱 HP Guru BK]      [💻 Web Sekolah]
      ⬇️                 ⬇️                   ⬇️
[ REST API (JSON) ] [ REST API (JSON) ]   [ HTML Views ]
      ⬇️                 ⬇️                   ⬇️
------------------------------------------------------
|           🔥 BACKEND CORE (PHP Native)             |
|   (Auth, Encryption Logic, Controller Logic)       |
------------------------------------------------------
                     ⬇️
              [ 🗄️ MySQL Database ]
