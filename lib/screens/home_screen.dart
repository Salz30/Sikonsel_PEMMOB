import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sikonsel_mobile/screens/reservation_screen.dart';
import 'package:sikonsel_mobile/screens/history_screen.dart';
import 'package:sikonsel_mobile/screens/edit_profile_screen.dart';
import 'package:sikonsel_mobile/screens/login_screen.dart';
import 'package:sikonsel_mobile/screens/add_report_screen.dart';
import 'package:sikonsel_mobile/screens/school_info_screen.dart';
import 'package:sikonsel_mobile/screens/about_screen.dart'; // Import About Screen
import 'package:sikonsel_mobile/api/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(resetOnError: true),
  );

  String namaSiswa = "Sobat Sikonsel";
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      String? nama = await storage.read(key: 'user_nama');
      if (nama != null && mounted) {
        setState(() {
          namaSiswa = nama.split(' ')[0];
        });
      }
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  Future<void> _logout() async {
    await _apiService.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          // --- HEADER ATAS ---
          Container(
            padding: const EdgeInsets.only(top: 60, left: 25, right: 25, bottom: 30),
            decoration: BoxDecoration(
              color: const Color(0xFF4A90E2),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4A90E2).withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // BAGIAN KIRI: NAMA USER
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Halo, Selamat Pagi! 👋",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      namaSiswa,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                // BAGIAN KANAN: TOMBOL ACTION (ABOUT & PROFIL)
                Row(
                  children: [
                    // 1. TOMBOL TENTANG APLIKASI (Di Header)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2), // Transparan Putih
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.info_outline_rounded, color: Colors.white),
                        tooltip: 'Tentang Aplikasi',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AboutScreen()),
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(width: 10), // Jarak antar tombol

                    // 2. TOMBOL PROFIL
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EditProfileScreen())),
                      child: const CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Color(0xFF4A90E2), size: 30),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- KONTEN UTAMA ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Banner
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Info Sekolah",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12)),
                            SizedBox(height: 5),
                            Text(
                              "Cek jadwal ujian dan beasiswa terbaru disini!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.info_outline,
                          color: Colors.yellow.shade200, size: 40),
                    ],
                  ),
                ),

                const SizedBox(height: 25),
                const Text("Layanan Utama",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),

                // Grid Menu (Kembali ke 4 Menu agar Rapi)
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.1,
                  children: [
                    _buildMenuCard(
                      "Info Sekolah",
                      "Agenda & Beasiswa",
                      Icons.campaign_rounded,
                      Colors.blueAccent,
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SchoolInfoScreen())),
                    ),
                    _buildMenuCard(
                      "Curhat Yuk!",
                      "Cerita masalahmu",
                      Icons.chat_bubble_outline_rounded,
                      Colors.orangeAccent,
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddReportScreen())),
                    ),
                    _buildMenuCard(
                      "Janji Temu",
                      "Konseling tatap muka",
                      Icons.calendar_month_rounded,
                      Colors.purpleAccent,
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ReservationScreen())),
                    ),
                    _buildMenuCard(
                      "Riwayat",
                      "Status laporanmu",
                      Icons.history_rounded,
                      Colors.greenAccent,
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HistoryScreen())),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                TextButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout, color: Colors.redAccent),
                  label: const Text("Keluar Aplikasi",
                      style: TextStyle(color: Colors.redAccent)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(String title, String subtitle, IconData icon,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.2), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 28),
            ),
            const Spacer(),
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}