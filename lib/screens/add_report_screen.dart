import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../api/api_service.dart';


class AddReportScreen extends StatefulWidget {
  const AddReportScreen({super.key});

  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _isiController = TextEditingController();
  
  // Kategori sesuai Database Anda
  String? _selectedKategori;
  final List<String> _kategoriList = ['Pribadi', 'Sosial', 'Belajar', 'Karir', 'Lainnya'];
  
  bool _isLoading = false;
  final storage = const FlutterSecureStorage();

  Future<void> _kirimCurhat() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Ambil ID Siswa yang disimpan saat Login
    String? idSiswa = await storage.read(key: 'id_siswa');

    // Validasi Sesi
    if (idSiswa == null || idSiswa == "null") {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesi Error: ID Siswa tidak ditemukan. Silakan Login Ulang.'), backgroundColor: Colors.red),
      );
      return;
    }

    final url = Uri.parse('${ApiService.baseUrl}/siswa/tambah_pengaduan.php');

    try {
      final response = await http.post(
        url,
        // WAJIB ADA HEADERS INI AGAR PHP MENGENALI JSON
        headers: {'Content-Type': 'application/json'}, 
        body: jsonEncode({
          'id_siswa': idSiswa,
          'judul': _judulController.text,
          'isi': _isiController.text, // Pastikan di PHP namanya 'isi', bukan 'laporan'
          'kategori': _selectedKategori ?? 'Lainnya',
        }),
      );

      final data = jsonDecode(response.body);

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (response.statusCode == 201 || data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Curhat berhasil dikirim!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context); // Kembali ke Dashboard
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: ${data['message']}'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Koneksi: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buat Laporan Baru")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("Ceritakan masalahmu, privasi aman terjaga.", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                initialValue: _selectedKategori,
                hint: const Text("Pilih Kategori Masalah"),
                items: _kategoriList.map((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
                onChanged: (newValue) => setState(() => _selectedKategori = newValue),
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (value) => value == null ? "Pilih kategori dulu" : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(labelText: "Judul Singkat", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _isiController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: "Isi Curhat / Laporan", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: _isLoading ? null : _kirimCurhat,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("KIRIM SEKARANG", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}