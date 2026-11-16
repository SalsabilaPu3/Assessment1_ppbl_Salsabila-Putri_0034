import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/prediksi_cubit.dart';
import '../state/prediksi_state.dart';
import '../models/prediksi_model.dart';
import '../widgets/prediksi_card.dart';
import 'halaman_input_prediksi.dart';

class HalamanPrediksi extends StatelessWidget {
  const HalamanPrediksi({super.key});

  static const Color hijau = Color(0xFF2E7D32);

  void _hapusPrediksi(BuildContext context, HasilPrediksi data) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Prediksi'),
          content: const Text(
            'Apakah kamu yakin ingin menghapus data prediksi ini?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                context.read<PrediksiCubit>().hapusData(data);
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data berhasil dihapus')),
                );
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _bukaFormPrediksi(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HalamanInputPrediksi()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AgriClima - Prediksi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: hijau,
        foregroundColor: Colors.white,
      ),

      body: BlocBuilder<PrediksiCubit, PrediksiState>(
        builder: (context, state) {
          final daftar = state.prediksiTerfilter;

          final total = daftar.length;

          final optimal = daftar
              .where((data) => data.status == 'Optimal')
              .length;

          final perluTindakan = daftar
              .where((data) => data.status != 'Optimal')
              .length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul riwayat
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: Text(
                  'Riwayat Prediksi',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Filter petak
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(
                        value: 'Semua',
                        label: Text('Semua'),
                        icon: Icon(Icons.check),
                      ),
                      ButtonSegment(value: 'Petak 1', label: Text('Petak 1')),
                      ButtonSegment(value: 'Petak 2', label: Text('Petak 2')),
                    ],
                    selected: {state.filterPetak},
                    onSelectionChanged: (selection) {
                      context.read<PrediksiCubit>().filterPetak(
                        selection.first,
                      );
                    },
                    showSelectedIcon: false,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith((
                        states,
                      ) {
                        if (states.contains(WidgetState.selected)) {
                          return hijau.withValues(alpha: 0.15);
                        }
                        return theme.colorScheme.surface;
                      }),
                      foregroundColor: WidgetStateProperty.resolveWith((
                        states,
                      ) {
                        if (states.contains(WidgetState.selected)) {
                          return hijau;
                        }
                        return theme.colorScheme.onSurface;
                      }),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Tiga kartu statistik
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        icon: Icons.analytics,
                        judul: 'Total',
                        jumlah: total,
                        warna: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _statCard(
                        icon: Icons.check_circle,
                        judul: 'Optimal',
                        jumlah: optimal,
                        warna: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _statCard(
                        icon: Icons.warning_amber_rounded,
                        judul: 'Perlu Tindakan',
                        jumlah: perluTindakan,
                        warna: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Daftar riwayat prediksi
              Expanded(
                child: daftar.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.folder_open,
                              size: 65,
                              color: theme.colorScheme.outline,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Belum ada data',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Tekan Prediksi Baru untuk menambahkan data',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 110, top: 4),
                        itemCount: daftar.length,
                        itemBuilder: (context, index) {
                          final data = daftar[index];

                          return PrediksiCard(
                            prediksi: data,
                            onTap: () {
                              _hapusPrediksi(context, data);
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),

      // Tombol Prediksi Baru
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _bukaFormPrediksi(context),
        backgroundColor: hijau,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'Prediksi Baru',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Widget kartu statistik
  Widget _statCard({
    required IconData icon,
    required String judul,
    required int jumlah,
    required Color warna,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
        child: Column(
          children: [
            Icon(icon, color: warna, size: 25),
            const SizedBox(height: 5),
            Text(
              jumlah.toString(),
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: warna,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              judul,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
  