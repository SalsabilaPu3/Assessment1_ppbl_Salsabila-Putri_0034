import 'package:flutter/material.dart';

import '../models/prediksi_model.dart';

class PrediksiCard extends StatelessWidget {
  final HasilPrediksi prediksi;
  final VoidCallback onTap;

  const PrediksiCard({super.key, required this.prediksi, required this.onTap});

  // Warna berdasarkan status mikroklimat
  Color get warnaStatus {
    if (prediksi.status == 'Kering') {
      return Colors.orange;
    } else if (prediksi.status == 'Optimal') {
      return Colors.green;
    } else {
      return Colors.blue;
    }
  }

  // Ikon berdasarkan status mikroklimat
  IconData get ikonStatus {
    if (prediksi.status == 'Kering') {
      return Icons.water_drop_outlined;
    } else if (prediksi.status == 'Optimal') {
      return Icons.check_circle_outline;
    } else {
      return Icons.water;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final warna = warnaStatus;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian petak dan tanaman
            Row(
              children: [
                Icon(Icons.eco, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${prediksi.petak} - ${prediksi.tanaman}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onTap,
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Hapus prediksi',
                ),
              ],
            ),

            // Status mikroklimat
            Row(
              children: [
                Icon(ikonStatus, color: warna),
                const SizedBox(width: 8),
                Text(
                  prediksi.status,
                  style: TextStyle(color: warna, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Kelembapan tanah
            Text(
              'Kelembapan tanah: '
              '${prediksi.kelembapanTanah.toStringAsFixed(1)}%',
            ),
            const SizedBox(height: 6),

            LinearProgressIndicator(
              value: (prediksi.kelembapanTanah / 100).clamp(0.0, 1.0),
              color: warna,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
            ),

            const SizedBox(height: 12),

            // Informasi prediksi
            Text('Suhu udara: ${prediksi.suhuUdara} °C'),
            Text('Kelembapan udara: ${prediksi.kelembapanUdara}%'),

            const SizedBox(height: 8),

            // Rekomendasi
            Text(
              'Rekomendasi:',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(prediksi.rekomendasi),

            const SizedBox(height: 8),

            // Catatan tanaman
            Text(
              'Catatan perawatan:',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(prediksi.catatanTanaman),

            const SizedBox(height: 8),

            // Waktu dan nama petugas
            Text(
              'Petugas: ${prediksi.namaPetugas}',
              style: theme.textTheme.bodySmall,
            ),
            Text(
              'Waktu prediksi: ${prediksi.waktu.day}/'
              '${prediksi.waktu.month}/${prediksi.waktu.year} '
              '${prediksi.waktu.hour.toString().padLeft(2, '0')}:'
              '${prediksi.waktu.minute.toString().padLeft(2, '0')}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
