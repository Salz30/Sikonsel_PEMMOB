import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tentang Aplikasi"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.school, size: 100, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              "SIKONSEL MOBILE",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text("Versi 1.0.0"),
            const SizedBox(height: 30),
            const Text(
              "Aplikasi Sistem Informasi Konseling Sekolah (SIKONSEL) SMPN 4 Rancaekek memudahkan siswa untuk berkonsultasi dengan Guru BK secara aman dan terpercaya.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 10),
            const Text("Dikembangkan oleh:", style: TextStyle(fontWeight: FontWeight.bold)),
            const Text("Salman Azhar Latisio - Pemula Teknologi Informasi"),
          ],
        ),
      ),
    );
  }
}