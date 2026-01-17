import 'package:flutter/material.dart';
import '../api/api_service.dart';
import 'add_reservation_screen.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _reservasiFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _reservasiFuture = _apiService.getReservasi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jadwal Konseling")),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          // Pindah ke halaman tambah, tunggu sampai kembali
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddReservationScreen()),
          );
          _refreshData(); // Refresh list setelah tambah data
        },
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _reservasiFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada janji temu."));
          }

          final data = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              
              // Logika Warna Status
              String status = item['status'] ?? 'Menunggu';
              Color colorStatus = Colors.orange;
              if (status == 'Disetujui') colorStatus = Colors.green;
              if (status == 'Ditolak') colorStatus = Colors.red;

              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                child: ListTile(
                  leading: Icon(Icons.calendar_today, color: colorStatus),
                  title: Text(
                    "${item['tgl_temu']} (${item['jam_temu']})",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Keperluan: ${item['keperluan']}"),
                      const SizedBox(height: 5),
                      // Tampilkan catatan guru jika ada
                      if (item['catatan_guru'] != null && item['catatan_guru'] != '')
                        Text("Jawab Guru: ${item['catatan_guru']}", 
                             style: const TextStyle(color: Colors.blueGrey, fontStyle: FontStyle.italic)),
                      
                      Text(status, style: TextStyle(color: colorStatus, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}