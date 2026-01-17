import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api/api_service.dart'; // Untuk ambil Base URL

class ParentReportScreen extends StatefulWidget {
  const ParentReportScreen({super.key});

  @override
  State<ParentReportScreen> createState() => _ParentReportScreenState();
}

class _ParentReportScreenState extends State<ParentReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaOrtuController = TextEditingController();
  final _namaSiswaController = TextEditingController();
  final _kelasController = TextEditingController();
  final _laporanController = TextEditingController();
  bool _isLoading = false;

  Future<void> _kirimLaporan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Endpoint API (Sesuaikan path folder Anda)
    final url = Uri.parse('${ApiService.baseUrl}/public/tambah_laporan_ortu.php');

    try {
      final response = await http.post(
        url,
        // WAJIB ADA HEADERS
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama_ortu': _namaOrtuController.text,
          'nama_siswa': _namaSiswaController.text,
          'kelas': _kelasController.text,
          'laporan': _laporanController.text, // Pastikan di PHP namanya 'laporan', bukan 'isi'
        }),
      );

      final data = jsonDecode(response.body);

      setState(() => _isLoading = false);

      if (response.statusCode == 201 || data['success'] == true) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Laporan Berhasil Dikirim!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context); // Kembali ke halaman Login
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: ${data['message']}'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Laporan Orang Tua")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("Silakan isi formulir di bawah ini untuk melapor ke Guru BK."),
              const SizedBox(height: 20),
              
              TextFormField(
                controller: _namaOrtuController,
                decoration: const InputDecoration(labelText: "Nama Orang Tua", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 15),
              
              TextFormField(
                controller: _namaSiswaController,
                decoration: const InputDecoration(labelText: "Nama Siswa", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 15),
              
              TextFormField(
                controller: _kelasController,
                decoration: const InputDecoration(labelText: "Kelas", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 15),
              
              TextFormField(
                controller: _laporanController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: "Isi Laporan / Keluhan", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: _isLoading ? null : _kirimLaporan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("KIRIM LAPORAN", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}