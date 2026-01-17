import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Import baru

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  // Fungsi Utama Inisialisasi
  Future<void> initNotification() async {
    // 1. Minta Izin Notifikasi (Wajib untuk Android 13+)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ Izin notifikasi diberikan!');

      // 2. Setup Notifikasi Lokal (Agar bisa Pop-up)
      // '@mipmap/ic_launcher' adalah icon bawaan flutter (logo robot android / logo app anda)
      const AndroidInitializationSettings androidSettings = 
          AndroidInitializationSettings('@mipmap/ic_launcher');
      
      const InitializationSettings initSettings = 
          InitializationSettings(android: androidSettings);

      await _localNotifications.initialize(initSettings);

      // 3. Ambil Token (Untuk Tes)
      String? token = await _firebaseMessaging.getToken();
      print('=== TOKEN ANDA (Copy untuk Tes) ===');
      print(token);
      print('===================================');

      // 4. DENGARKAN PESAN SAAT APLIKASI AKTIF (FOREGROUND)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('📩 Pesan masuk: ${message.notification?.title}');
        
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        // Jika ada notifikasi, paksa munculkan Pop-up
        if (notification != null && android != null) {
          _showLocalNotification(notification);
        }
      });
      
    } else {
      print('❌ Izin notifikasi ditolak.');
    }
  }

  // Fungsi Helper untuk Menampilkan Pop-up
  Future<void> _showLocalNotification(RemoteNotification notification) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_sikonsel_1',       // ID unik channel
      'Notifikasi Penting',       // Nama channel (muncul di pengaturan HP)
      importance: Importance.max, // PENTING: Max agar muncul Pop-up (Heads-up)
      priority: Priority.high,    // PENTING: High agar bunyi dan getar
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      notification.hashCode,  // ID Notifikasi
      notification.title,     // Judul
      notification.body,      // Isi Pesan
      details,
    );
  }
}