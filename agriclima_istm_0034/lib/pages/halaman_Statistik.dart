import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

import '../state/prediksi_cubit.dart';
import '../state/prediksi_state.dart';

class HalamanStatistik extends StatelessWidget {
  const HalamanStatistik({super.key});

  static const Color hijau = Color(0xFF16A34A);
  static const Color orange = Color(0xFFF59E0B);
  static const Color biru = Color(0xFF1688D4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AgriClima - Statistik',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: hijau,
        foregroundColor: Colors.white,
      ),

      body: BlocBuilder<PrediksiCubit, PrediksiState>(
        builder: (context, state) {
          // Mengambil semua data prediksi
          final data = state.daftarPrediksi;

          // Menghitung jumlah setiap status
          final kering = data.where((item) => item.status == 'Kering').length;

          final optimal = data.where((item) => item.status == 'Optimal').length;

          final lembap = data
              .where((item) => item.status == 'Terlalu Lembap')
              .length;

          final total = data.length;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // JUDUL
              const Text(
                'Jumlah Prediksi per Status Mikroklimat',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // KARTU RINGKASAN
              Row(
                children: [
                  Expanded(
                    child: _kartuStatus(
                      'Kering',
                      kering,
                      Icons.wb_sunny,
                      orange,
                      const Color(0xFFFFF0DB),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _kartuStatus(
                      'Optimal',
                      optimal,
                      Icons.check_circle,
                      hijau,
                      const Color(0xFFDFF5E5),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _kartuStatus(
                      'Terlalu Lembap',
                      lembap,
                      Icons.water_drop,
                      biru,
                      const Color(0xFFDCEEFF),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // GRAFIK BATANG
              const Text(
                'Grafik Status Mikroklimat',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              Container(
                height: 290,
                padding: const EdgeInsets.fromLTRB(8, 20, 16, 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: total == 0
                    ? const Center(child: Text('Belum ada data statistik'))
                    : BarChart(
                        BarChartData(
                          maxY:
                              ([
                                        kering,
                                        optimal,
                                        lembap,
                                      ].reduce((a, b) => a > b ? a : b) +
                                      1)
                                  .toDouble(),

                          alignment: BarChartAlignment.spaceEvenly,

                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                          ),

                          borderData: FlBorderData(show: false),

                          barTouchData: BarTouchData(enabled: true),

                          titlesData: FlTitlesData(
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 35,
                                interval: 1,
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 38,
                                getTitlesWidget: (value, meta) {
                                  const labels = [
                                    'Kering',
                                    'Optimal',
                                    'Terlalu\nLembap',
                                  ];

                                  if (value < 0 || value >= labels.length) {
                                    return const SizedBox();
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      labels[value.toInt()],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          barGroups: [
                            _barGroup(0, kering, orange),
                            _barGroup(1, optimal, hijau),
                            _barGroup(2, lembap, biru),
                          ],
                        ),
                      ),
              ),

              const SizedBox(height: 25),

              // TABEL STATISTIK
              const Text(
                'Tabel Statistik Mikroklimat',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Card(
                elevation: 2,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(
                      hijau.withValues(alpha: 0.15),
                    ),
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Status',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Jumlah',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        numeric: true,
                      ),
                      DataColumn(
                        label: Text(
                          'Keterangan',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: [
                      _barisTabel(
                        'Kering',
                        kering,
                        'Perlu penyiraman',
                        orange,
                        Icons.wb_sunny,
                      ),
                      _barisTabel(
                        'Optimal',
                        optimal,
                        'Kondisi baik',
                        hijau,
                        Icons.check_circle,
                      ),
                      _barisTabel(
                        'Terlalu Lembap',
                        lembap,
                        'Periksa drainase',
                        biru,
                        Icons.water_drop,
                      ),
                      DataRow(
                        color: WidgetStateProperty.all(
                          hijau.withValues(alpha: 0.08),
                        ),
                        cells: [
                          const DataCell(
                            Text(
                              'TOTAL',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataCell(
                            Text(
                              total.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const DataCell(Text('Semua data')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // INFORMASI
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: hijau.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, color: hijau),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Statistik menampilkan total '
                        'hasil prediksi dari Petak 1 dan Petak 2. '
                        'Data diperbarui secara otomatis '
                        'ketika terdapat perubahan riwayat prediksi.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),
            ],
          );
        },
      ),
    );
  }

  // Kartu ringkasan status
  Widget _kartuStatus(
    String judul,
    int jumlah,
    IconData icon,
    Color warna,
    Color latar,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
      decoration: BoxDecoration(
        color: latar,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: warna, size: 25),
          const SizedBox(height: 8),
          Text(
            jumlah.toString(),
            style: TextStyle(
              color: warna,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            judul,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: warna,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Membuat satu batang grafik
  BarChartGroupData _barGroup(int x, int jumlah, Color warna) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: jumlah.toDouble(),
          color: warna,
          width: 42,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        ),
      ],
    );
  }

  // Membuat baris tabel
  DataRow _barisTabel(
    String status,
    int jumlah,
    String keterangan,
    Color warna,
    IconData icon,
  ) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: warna, size: 19),
              const SizedBox(width: 6),
              Text(
                status,
                style: TextStyle(
                  color: warna,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            jumlah.toString(),
            style: TextStyle(color: warna, fontWeight: FontWeight.bold),
          ),
        ),
        DataCell(Text(keterangan, style: const TextStyle(fontSize: 12))),
      ],
    );
  }
}
