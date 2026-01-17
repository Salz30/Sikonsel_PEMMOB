import 'package:flutter/material.dart';
import '../api/api_service.dart';

class AddReservationScreen extends StatefulWidget {
  const AddReservationScreen({super.key});

  @override
  State<AddReservationScreen> createState() => _AddReservationScreenState();
}

class _AddReservationScreenState extends State<AddReservationScreen> {
  final _keperluanController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final ApiService _apiService = ApiService();
  
  bool _isLoading = false;

  // Fungsi Pilih Tanggal
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        // Format ke YYYY-MM-DD
        _dateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  // Fungsi Pilih Jam
  Future<void> _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        // Format ke HH:mm
        _timeController.text = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  void _submit() async {
    if (_dateController.text.isEmpty || _timeController.text.isEmpty || _keperluanController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Semua data wajib diisi")));
      return;
    }

    setState(() => _isLoading = true);

    bool success = await _apiService.tambahReservasi(
      _dateController.text,
      _timeController.text,
      _keperluanController.text,
    );

    setState(() => _isLoading = false);

    if (success) {
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Janji temu berhasil diajukan!"), backgroundColor: Colors.green));
      Navigator.pop(context); // Tutup halaman
    } else {
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal mengajukan janji."), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajukan Janji Temu")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: const InputDecoration(labelText: "Tanggal Temu", icon: Icon(Icons.calendar_month)),
              onTap: _selectDate,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _timeController,
              readOnly: true,
              decoration: const InputDecoration(labelText: "Jam Temu", icon: Icon(Icons.access_time)),
              onTap: _selectTime,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _keperluanController,
              decoration: const InputDecoration(labelText: "Keperluan Konseling", icon: Icon(Icons.note)),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15)
              ),
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : 
                const Text("AJUKAN SEKARANG", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}