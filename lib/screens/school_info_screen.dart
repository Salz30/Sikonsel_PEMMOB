import 'package:flutter/material.dart';
import 'package:sikonsel_mobile/api/api_service.dart';

class SchoolInfoScreen extends StatefulWidget {
  const SchoolInfoScreen({super.key});

  @override
  State<SchoolInfoScreen> createState() => _SchoolInfoScreenState();
}

class _SchoolInfoScreenState extends State<SchoolInfoScreen> {
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agenda & Beasiswa"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        child: FutureBuilder<List<dynamic>>(
          future: _apiService.getInfoSekolah(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_busy, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 10),
                    const Text("Belum ada informasi terbaru", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            }

            final listInfo = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: listInfo.length,
              itemBuilder: (context, index) {
                final info = listInfo[index];
                bool isBeasiswa = info['kategori'] == 'Beasiswa';
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isBeasiswa ? Colors.green.shade50 : Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isBeasiswa ? Colors.green.shade200 : Colors.blue.shade200
                                ),
                              ),
                              child: Text(
                                info['kategori'],
                                style: TextStyle(
                                  color: isBeasiswa ? Colors.green.shade700 : Colors.blue.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12
                                ),
                              ),
                            ),
                            Text(
                              info['tgl_posting'],
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          info['judul'],
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          info['isi_info'],
                          style: TextStyle(color: Colors.grey.shade700, height: 1.5),
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