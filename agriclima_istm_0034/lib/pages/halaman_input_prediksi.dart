import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/prediksi_model.dart';
import '../state/prediksi_cubit.dart';

class HalamanInputPrediksi extends StatefulWidget {
  const HalamanInputPrediksi({super.key});

  @override
  State<HalamanInputPrediksi> createState() => _HalamanInputPrediksiState();
}

class _HalamanInputPrediksiState extends State<HalamanInputPrediksi> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk setiap input
  final _suhuController = TextEditingController();
  final _kelembapanUdaraController = TextEditingController();
  final _kelembapanTanahController = TextEditingController();
  final _petugasController = TextEditingController();

  // State lokal form
  String petak = 'Petak 1';
  String tanaman = 'Padi';
  bool sudahBenar = false;

  static const Color hijau = Color(0xFF2E7D32);

  @override
  void dispose() {
    _suhuController.dispose();
    _kelembapanUdaraController.dispose();
    _kelembapanTanahController.dispose();
    _petugasController.dispose();
    super.dispose();
  }

  // Menentukan status mikroklimat
  String get statusPrediksi {
    final nilai = double.tryParse(_kelembapanTanahController.text);

    if (nilai == null) {
      return '-';
    } else if (nilai < 40) {
      return 'Kering';
    } else if (nilai <= 70) {
      return 'Optimal';
    } else {
      return 'Terlalu Lembap';
    }
  }

  // Validasi angka
  String? validasiAngka(String? value, {bool persentase = false}) {
    if (value == null || value.trim().isEmpty) {
      return 'Bagian ini wajib diisi';
    }

    final angka = double.tryParse(value);

    if (angka == null) {
      return 'Masukkan angka yang valid';
    }

    if (persentase && (angka < 0 || angka > 100)) {
      return 'Nilai harus antara 0 sampai 100%';
    }

    return null;
  }

  // Menampilkan dialog konfirmasi dan menyimpan data
  Future<void> konfirmasiSimpan() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);

    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Konfirmasi',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Simpan prediksi $tanaman di $petak?\n'
            'Status: $statusPrediksi',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: hijau,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Ya, Simpan'),
            ),
          ],
        );
      },
    );

    if (konfirmasi != true || !mounted) {
      return;
    }

    // Membuat objek hasil prediksi
    final data = HasilPrediksi(
      petak: petak,
      tanaman: tanaman,
      suhuUdara: double.parse(_suhuController.text),
      kelembapanUdara: double.parse(_kelembapanUdaraController.text),
      kelembapanTanah: double.parse(_kelembapanTanahController.text),
      namaPetugas: _petugasController.text.trim(),
      waktu: DateTime.now(),
    );

    // Menyimpan data menggunakan PrediksiCubit
    context.read<PrediksiCubit>().tambahData(data);

    // Kembali ke halaman riwayat prediksi
    Navigator.pop(context);

    // Menampilkan pesan berhasil
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Data tersimpan'),
        backgroundColor: hijau,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gelap = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Input Prediksi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: hijau,
        foregroundColor: Colors.white,
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // PILIH PETAK
            const Text(
              'Petak',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            RadioGroup<String>(
              groupValue: petak,
              onChanged: (value) {
                setState(() {
                  petak = value!;
                });
              },
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Petak 1'),
                    value: 'Petak 1',
                    activeColor: hijau,
                    contentPadding: EdgeInsets.zero,
                  ),
                  RadioListTile<String>(
                    title: const Text('Petak 2'),
                    value: 'Petak 2',
                    activeColor: hijau,
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // PILIH TANAMAN
            DropdownButtonFormField<String>(
              initialValue: tanaman,
              decoration: InputDecoration(
                labelText: 'Nama Tanaman',
                prefixIcon: const Icon(Icons.eco, color: hijau),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'Padi', child: Text('Padi')),
                DropdownMenuItem(value: 'Jagung', child: Text('Jagung')),
                DropdownMenuItem(value: 'Cabai', child: Text('Cabai')),
              ],
              onChanged: (value) {
                setState(() {
                  tanaman = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            // PREDIKSI SUHU UDARA
            _fieldInput(
              controller: _suhuController,
              label: 'Prediksi Suhu Udara (°C)',
              hint: 'Masukkan prediksi suhu udara',
              icon: Icons.thermostat,
              validator: (value) => validasiAngka(value),
            ),

            const SizedBox(height: 18),

            // PREDIKSI KELEMBAPAN UDARA
            _fieldInput(
              controller: _kelembapanUdaraController,
              label: 'Prediksi Kelembapan Udara (%)',
              hint: 'Masukkan prediksi kelembapan udara',
              icon: Icons.water_drop_outlined,
              validator: (value) => validasiAngka(value, persentase: true),
            ),

            const SizedBox(height: 18),

            // PREDIKSI KELEMBAPAN TANAH
            _fieldInput(
              controller: _kelembapanTanahController,
              label: 'Prediksi Kelembapan Tanah (%)',
              hint: 'Masukkan prediksi kelembapan tanah',
              icon: Icons.grass,
              validator: (value) => validasiAngka(value, persentase: true),
            ),

            const SizedBox(height: 18),

            // NAMA PETUGAS
            TextFormField(
              controller: _petugasController,
              decoration: InputDecoration(
                labelText: 'Nama Petugas',
                hintText: 'Masukkan nama petugas',
                prefixIcon: const Icon(Icons.person_outline, color: hijau),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama petugas wajib diisi';
                }
                return null;
              },
            ),

            const SizedBox(height: 12),

            // CHECKBOX DATA SUDAH BENAR
            CheckboxListTile(
              value: sudahBenar,
              activeColor: hijau,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text(
                'Data sudah benar',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onChanged: (value) {
                setState(() {
                  sudahBenar = value ?? false;
                });
              },
            ),

            const SizedBox(height: 20),

            // TOMBOL SIMPAN
            SizedBox(
              height: 54,
              child: ElevatedButton.icon(
                onPressed: sudahBenar ? konfirmasiSimpan : null,
                icon: const Icon(Icons.save),
                label: const Text(
                  'Simpan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: hijau,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: gelap
                      ? Colors.grey.shade800
                      : Colors.grey.shade300,
                  disabledForegroundColor: gelap
                      ? Colors.white54
                      : Colors.grey.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  // Widget untuk input angka
  Widget _fieldInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: hijau),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator,
    );
  }
}
