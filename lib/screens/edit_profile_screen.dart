import 'package:flutter/material.dart';
import '../api/api_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaOrtuController = TextEditingController();
  final TextEditingController _noWaController = TextEditingController();
  
  bool _isLoading = false;      // Loading saat menyimpan data
  bool _isInitLoading = true;   // Loading awal saat mengambil data lama

  @override
  void initState() {
    super.initState();
    _loadDataAwal(); // Panggil fungsi ambil data saat layar dibuka
  }

  // --- Fungsi Baru: Ambil data lama agar form tidak kosong ---
  Future<void> _loadDataAwal() async {
    // Pastikan Anda sudah menambahkan getProfilOrtu() di api_service.dart
    final data = await ApiService().getProfilOrtu();
    
    if (mounted) {
      if (data != null) {
        setState(() {
          // Isi form dengan data dari database
          _namaOrtuController.text = data['nama_ortu'] ?? '';
          _noWaController.text = data['no_hp_ortu'] ?? '';
        });
      }
      // Hentikan loading awal
      setState(() => _isInitLoading = false);
    }
  }

  // Fungsi untuk Simpan Data
  Future<void> _simpanData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Panggil API Service untuk update
    bool success = await ApiService().updateDataOrtu(
      _namaOrtuController.text,
      _noWaController.text,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data Orang Tua berhasil disimpan!"), 
          backgroundColor: Colors.green
        ),
      );
      Navigator.pop(context); // Kembali ke Home setelah simpan
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal menyimpan data. Cek koneksi internet."), 
          backgroundColor: Colors.red
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lengkapi Data Wali"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      // Tampilkan Loading putar-putar jika data sedang diambil
      body: _isInitLoading 
          ? const Center(child: CircularProgressIndicator()) 
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Data Orang Tua / Wali",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Data ini diperlukan agar Guru BK dapat menghubungi wali jika ada keadaan darurat.",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 20),

                    // Input Nama Orang Tua
                    TextFormField(
                      controller: _namaOrtuController,
                      decoration: InputDecoration(
                        labelText: "Nama Lengkap Orang Tua",
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) => value!.isEmpty ? "Nama wajib diisi" : null,
                    ),
                    const SizedBox(height: 15),

                    // Input No WA
                    TextFormField(
                      controller: _noWaController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "No. WhatsApp (Gunakan 62..)",
                        hintText: "Contoh: 628123456789",
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) => value!.isEmpty ? "Nomor WA wajib diisi" : null,
                    ),
                    const SizedBox(height: 30),

                    // Tombol Simpan
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _simpanData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: _isLoading 
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("SIMPAN DATA", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}