import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/theme_cubit.dart';
import '../state/prediksi_cubit.dart';

class HalamanPengaturan extends StatelessWidget {
  const HalamanPengaturan({super.key});

  static const Color hijau = Color(0xFF2E7D32);
  static const Color merah = Color(0xFFE53935);
  static const Color orange = Color(0xFFF59E0B);

  // Konfirmasi hapus semua data
  Future<void> konfirmasiHapus(BuildContext context) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: merah),
              SizedBox(width: 10),
              Expanded(child: Text('Hapus Semua Data')),
            ],
          ),
          content: const Text(
            'Apakah kamu yakin ingin menghapus seluruh '
            'riwayat prediksi?\n\n'
            'Data yang sudah dihapus tidak dapat dikembalikan.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              icon: const Icon(Icons.delete),
              label: const Text('Ya, Hapus'),
              style: ElevatedButton.styleFrom(
                backgroundColor: merah,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );

    if (konfirmasi == true && context.mounted) {
      context.read<PrediksiCubit>().hapusSemuaData();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua data berhasil dihapus'),
          backgroundColor: merah,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Memuat data simulasi
  void muatDataSimulasi(BuildContext context) {
    context.read<PrediksiCubit>().buatDataSimulasi();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('10 data simulasi berhasil dimuat'),
        backgroundColor: hijau,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil state tema dari ThemeCubit
    final mode = context.watch<ThemeCubit>().state;
    final gelap = mode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: hijau,
        foregroundColor: Colors.white,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // HEADER PENGATURAN
          const Text(
            'Pengaturan Aplikasi',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          Text(
            'Atur tampilan aplikasi sesuai kenyamanan kamu.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 20),

          // PENGATURAN TEMA
          Card(
            elevation: 2,
            child: SwitchListTile(
              secondary: Icon(
                gelap ? Icons.dark_mode : Icons.light_mode,
                color: hijau,
                size: 30,
              ),
              title: const Text(
                'Dark Mode',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                gelap ? 'Mode gelap sedang aktif' : 'Mode terang sedang aktif',
              ),
              value: gelap,
              activeThumbColor: hijau,
              onChanged: (_) {
                context.read<ThemeCubit>().toggle();
              },
            ),
          ),

          const SizedBox(height: 24),

          // PENGELOLAAN DATA
          const Text(
            'Pengelolaan Data Prediksi',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          Text(
            'Kelola data prediksi untuk pengujian aplikasi AgriClima.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 16),

          // TOMBOL MUAT DATA SIMULASI
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.cloud_download, color: hijau, size: 30),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Data Simulasi',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Tambahkan 10 data prediksi secara otomatis '
                    'dengan nilai suhu dan kelembapan yang acak.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        muatDataSimulasi(context);
                      },
                      icon: const Icon(Icons.add_chart),
                      label: const Text(
                        'Muat Data Simulasi',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: hijau,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // TOMBOL HAPUS SEMUA DATA
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.delete_forever, color: merah, size: 30),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Hapus Riwayat Prediksi',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Hapus seluruh data prediksi yang tersimpan '
                    'pada aplikasi.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        konfirmasiHapus(context);
                      },
                      icon: const Icon(Icons.delete_outline),
                      label: const Text(
                        'Hapus Semua Data',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: merah,
                        side: const BorderSide(color: merah),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // INFORMASI APLIKASI
          const Text(
            'Tentang Aplikasi',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          Card(
            elevation: 2,
            child: const ListTile(
              leading: Icon(Icons.eco, color: hijau, size: 30),
              title: Text(
                'AgriClima LSTM',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Aplikasi pencatatan prediksi mikroklimat '
                'tanaman berbasis LSTM.',
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
