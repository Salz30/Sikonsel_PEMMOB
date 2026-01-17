import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  
  // --- KONFIGURASI URL ---
  // Sesuai konfirmasi Anda: File ada langsung di public_html/api
  static const String baseUrl = "https://sikonsel-espar.my.id/api";

  // --- KONFIGURASI PENYIMPANAN (ANTI-CRASH) ---
  // resetOnError: true -> Mencegah aplikasi force close jika data penyimpanan rusak
  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(resetOnError: true),
  );

  // ===========================================================================
  // 1. FUNGSI LOGIN (Dengan Debugging & Pembersih Respon)
  // ===========================================================================
  Future<Map<String, dynamic>> login(String username, String password, String? fcmToken) async {
    final url = Uri.parse('$baseUrl/login.php');
    
    print("--- MULAI LOGIN ---");
    print("Target URL: $url");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'fcm_token': fcmToken ?? '',
        }),
      );

      print("Status Server: ${response.statusCode}");
      print("Respon Mentah: '${response.body}'");

      // 1. BERSIHKAN RESPON (Hapus spasi/enter di awal & akhir)
      String cleanBody = response.body.trim();

      // 2. CEK APAKAH HTML (Tanda Error Server / URL Salah)
      if (cleanBody.isEmpty || cleanBody.startsWith("<")) {
         print("ERROR: Server mengirim HTML atau Kosong. Cek URL/Permission Hosting.");
         return {'success': false, 'message': 'Server Error (Cek Debug Console)'};
      }

      // 3. DECODE JSON
      final data = jsonDecode(cleanBody);

      if (response.statusCode == 200 && data['success'] == true) {
        print("Login Sukses. Menyimpan Sesi...");
        
        // Simpan Data Sesi
        await storage.write(key: 'auth_token', value: data['data']['token']);
        await storage.write(key: 'user_nama', value: data['data']['nama']);
        await storage.write(key: 'user_nisn', value: data['data']['nisn']);
        await storage.write(key: 'id_siswa', value: data['data']['id_siswa'].toString());

        return {'success': true, 'message': 'Login Berhasil'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login gagal'};
      }
    } catch (e) {
      print("Error Login Exception: $e");
      return {'success': false, 'message': 'Koneksi Error: $e'};
    }
  }

  // ===========================================================================
  // 2. FUNGSI LOGOUT
  // ===========================================================================
  Future<void> logout() async {
    try {
      await storage.deleteAll();
      print("Berhasil Logout & Hapus Sesi.");
    } catch (e) {
      print("Gagal Logout: $e");
    }
  }

  // ===========================================================================
  // 3. FUNGSI INFO SEKOLAH (Agenda & Beasiswa)
  // ===========================================================================
  Future<List<dynamic>> getInfoSekolah() async {
    try {
      final url = Uri.parse('$baseUrl/siswa/list_info.php');
      final response = await http.get(url);
      
      String cleanBody = response.body.trim();
      if (cleanBody.startsWith("<")) return [];

      final data = jsonDecode(cleanBody);
      if (response.statusCode == 200 && data['success'] == true) {
        return data['data'];
      }
    } catch (e) {
      print("Error Info Sekolah: $e");
    }
    return [];
  }

  // ===========================================================================
  // 4. FUNGSI RIWAYAT LAPORAN
  // ===========================================================================
  Future<List<dynamic>> getRiwayat() async {
    try {
      String? idSiswa = await storage.read(key: 'id_siswa'); 
      if (idSiswa == null) return [];

      final url = Uri.parse('$baseUrl/siswa/riwayat.php');
      final response = await http.post(url, body: {'id_siswa': idSiswa});
      
      String cleanBody = response.body.trim();
      if (cleanBody.startsWith("<")) return [];

      final data = jsonDecode(cleanBody);
      if (response.statusCode == 200 && data['success'] == true) {
        return data['data']; 
      }
    } catch (e) {
      print("Error Riwayat: $e");
    }
    return [];
  }

  // ===========================================================================
  // 5. FUNGSI LIST RESERVASI
  // ===========================================================================
  Future<List<dynamic>> getReservasi() async {
    try {
      String? idSiswa = await storage.read(key: 'id_siswa');
      if (idSiswa == null) return [];

      final url = Uri.parse('$baseUrl/siswa/reservasi_list.php');
      final response = await http.post(url, body: {'id_siswa': idSiswa});
      
      String cleanBody = response.body.trim();
      if (cleanBody.startsWith("<")) return [];

      final data = jsonDecode(cleanBody);
      if (response.statusCode == 200 && data['success'] == true) {
        return data['data'];
      }
    } catch (e) {
      print("Error Reservasi: $e");
    }
    return [];
  }

  // ===========================================================================
  // 6. FUNGSI TAMBAH RESERVASI
  // ===========================================================================
  Future<bool> tambahReservasi(String tgl, String jam, String keperluan) async {
    try {
      String? idSiswa = await storage.read(key: 'id_siswa');
      final url = Uri.parse('$baseUrl/siswa/tambah_reservasi.php');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_siswa': idSiswa,
          'tgl_temu': tgl,
          'jam_temu': jam,
          'keperluan': keperluan,
        }),
      );
      
      String cleanBody = response.body.trim();
      if (cleanBody.startsWith("<")) return false;

      final data = jsonDecode(cleanBody);
      return data['success'] ?? false;
    } catch (e) {
      return false;
    }
  }

  // ===========================================================================
  // 7. FUNGSI UPDATE DATA ORTU
  // ===========================================================================
  Future<bool> updateDataOrtu(String namaOrtu, String noWa) async {
    try {
      String? idSiswa = await storage.read(key: 'id_siswa');
      final url = Uri.parse('$baseUrl/siswa/update_profile.php'); 

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_siswa': idSiswa,
          'nama_ortu': namaOrtu,
          'no_whatsapp_ortu': noWa,
        }),
      );

      String cleanBody = response.body.trim();
      if (cleanBody.startsWith("<")) return false;

      final data = jsonDecode(cleanBody);
      return (response.statusCode == 200 && data['status'] == 'success');
    } catch (e) {
      return false;
    }
  }

  // ===========================================================================
  // 8. FUNGSI GET PROFIL ORTU
  // ===========================================================================
  Future<Map<String, dynamic>?> getProfilOrtu() async {
    try {
      String? idSiswa = await storage.read(key: 'id_siswa');
      if (idSiswa == null) return null; 

      final url = Uri.parse('$baseUrl/siswa/get_profile.php?id_siswa=$idSiswa');
      final response = await http.get(url);

      String cleanBody = response.body.trim();
      if (cleanBody.startsWith("<")) return null;

      if (response.statusCode == 200) {
        final data = jsonDecode(cleanBody);
        if (data['success'] == true && data['data'] is Map) {
          return data['data'];
        }
      }
    } catch (e) {
      print("Error Get Profil: $e");
    }
    return null;
  }
}