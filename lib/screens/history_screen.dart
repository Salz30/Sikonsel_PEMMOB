import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Import plugin animasi
import '../api/api_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _riwayatFuture;

  @override
  void initState() {
    super.initState();
    _riwayatFuture = _apiService.getRiwayat();
  }

  // Fungsi untuk refresh (tarik layar ke bawah)
  Future<void> _refreshData() async {
    setState(() {
      _riwayatFuture = _apiService.getRiwayat();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Laporan"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<List<dynamic>>(
          future: _riwayatFuture,
          builder: (context, snapshot) {
            // 1. Kondisi Loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } 
            // 2. Kondisi Error
            else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } 
            // 3. Kondisi Kosong (Tampilkan Animasi Lottie)
            else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: SingleChildScrollView( // Agar aman di layar kecil
                  physics: const AlwaysScrollableScrollPhysics(), // Agar tetap bisa ditarik refresh
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animasi Lottie dari Internet
                      Lottie.network(
                        'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json',
                        width: 200,
                        height: 200,
                        fit: BoxFit.fill,
                        // Jika mau pakai aset lokal (offline): Lottie.asset('assets/empty.json')
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Belum ada riwayat laporan.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }

            // 4. Kondisi Ada Data (Tampilkan List)
            final data = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                
                // Cek status untuk warna ikon
                String status = item['status'] ?? 'Menunggu'; 
                Color statusColor = status == 'Selesai' ? Colors.green : Colors.orange;

                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    leading: CircleAvatar(
                      backgroundColor: statusColor.withValues(alpha: 0.2),
                      child: Icon(Icons.history, color: statusColor),
                    ),
                    title: Text(
                      item['judul'] ?? "Tanpa Judul",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          item['isi'] ?? "-", 
                          maxLines: 2, 
                          overflow: TextOverflow.ellipsis
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Status: $status",
                          style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Text(
                          "Tgl: ${item['tanggal']}",
                          style: const TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}