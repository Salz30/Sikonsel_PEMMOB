# 📱 SIKONSEL Mobile (Sistem Informasi Konseling Sekolah)

![Version](https://img.shields.io/badge/version-1.0.0--stable-blue.svg) ![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-green) ![Backend](https://img.shields.io/badge/backend-PHP%20Native-purple)

**Sikonsel Mobile** adalah ekstensi aplikasi berbasis smartphone dari ekosistem Sikonsel. Aplikasi ini dirancang untuk memberikan aksesibilitas *real-time* bagi Siswa, Guru BK, dan Orang Tua dalam melakukan layanan bimbingan konseling tanpa terikat lokasi dan waktu (24/7), melengkapi versi Web yang digunakan di lingkungan sekolah.

---

## 🚀 Latar Belakang & Tujuan
Dalam era digital, masalah kesehatan mental dan akademik siswa bisa terjadi kapan saja. Sikonsel Mobile hadir sebagai solusi **"Counseling in Your Pocket"** dengan tujuan:
1.  **Respon Cepat:** Guru BK mendapatkan notifikasi instan saat ada laporan masuk.
2.  **Privasi Terjamin:** Siswa dapat bercerita di ruang privat tanpa harus terlihat masuk ke ruang BK.
3.  **Integrasi Orang Tua:** Memudahkan wali murid memantau/melapor tanpa prosedur administrasi yang rumit.
4.  **Single Source of Truth:** Menggunakan database yang sama dengan Sikonsel Web, sehingga data selalu sinkron.

---

## 🆕 Pembaruan Terkini (v1.0.0)
Pembaruan terbaru mencakup peningkatan stabilitas dan penambahan fitur UI:
* ✅ **Menu "Tentang Aplikasi":** Akses informasi versi dan pengembang melalui Header Dashboard & Grid Menu.
* ✅ **Enhanced Login Security:** Perbaikan manajemen sesi menggunakan `flutter_secure_storage` dengan enkripsi Android yang lebih stabil.
* ✅ **Robust API Handling:** Penanganan respon server yang lebih baik (Auto-trim JSON & Error Catching) untuk mencegah aplikasi *force close*.
* ✅ **UI/UX Refresh:** Penambahan tombol pintas (shortcut) di header dashboard untuk akses cepat.

---

## 🌟 Fitur Unggulan (Berdasarkan Role)

### 🎓 1. Role Siswa
Akses personal bagi siswa untuk mendapatkan bantuan mental & akademik.
* **📅 Reservasi Online:** Janji temu dengan Guru BK tanpa antre manual.
* **📩 e-Curhat (Pengaduan):** Kirim cerita/masalah secara privat.
* **📜 Riwayat Konseling:** Memantau status laporan (Diterima/Diproses/Selesai).
* **📢 Info Sekolah:** Update agenda sekolah dan info beasiswa terbaru.

### 🏫 2. Role Guru BK (Admin)
*Fitur Admin dikelola utama melalui Web.*
* **🔔 Notifikasi Real-time:** Notifikasi masuk saat ada siswa melapor.
* **📊 Monitoring Siswa:** Melihat profil singkat siswa saat melakukan *home visit*.

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
| **Mobile App** | Flutter (Dart) | Antarmuka Pengguna (Web/Android) |
| **State Mgt** | Native SetState | Manajemen state ringan & cepat |
| **Storage** | Flutter Secure Storage | Penyimpanan Token & Sesi Terenkripsi |
| **Backend API** | PHP Native | RESTful API (JSON Response) |
| **Database** | MySQL | Penyimpanan Data Terpusat |

### Topologi Sistem
```text
[📱 HP Siswa]                          [💻 Web Sekolah]
      ⬇️                                       ⬇️
[ REST API (JSON) ]                      [ HTML Views ]
      ⬇️                                       ⬇️
------------------------------------------------------
|           🔥 BACKEND CORE (PHP Native)             |
|   (Authentication, Logic, Notification System)     |
------------------------------------------------------
                      ⬇️
              [ 🗄️ MySQL Database ]
