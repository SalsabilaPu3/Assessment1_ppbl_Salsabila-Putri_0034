import 'package:flutter/material.dart';

class HalamanBeranda extends StatelessWidget {
  const HalamanBeranda({super.key});

  static const Color hijau = Color(0xFF2E7D32);
  static const Color hijauTua = Color(0xFF1B5E20);

  void _tentangAplikasi(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tentang AgriClima LSTM'),
          content: const Text(
            'AgriClima LSTM merupakan aplikasi untuk '
            'mencatat hasil prediksi mikroklimat tanaman '
            'pada lahan Kelompok Tani Sri Mulya.\n\n'
            'Aplikasi ini membantu petugas memantau '
            'kondisi tanaman melalui tiga parameter, '
            'yaitu suhu udara, kelembapan udara, dan '
            'kelembapan tanah.\n\n'
            'Hasil prediksi digunakan sebagai informasi '
            'pendukung untuk menentukan kebutuhan '
            'penyiraman tanaman.',
            textAlign: TextAlign.justify,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup', style: TextStyle(color: hijau)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gelap = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AgriClima LSTM',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: hijau,
        foregroundColor: Colors.white,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Sambutan
              Text(
                'Selamat Datang di\nAgriClima LSTM',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: gelap ? const Color(0xFF81C784) : hijauTua,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 12),

              // Deskripsi aplikasi
              Text(
                'Aplikasi untuk mencatat hasil prediksi '
                'mikroklimat tanaman di lahan Kelompok '
                'Tani Sri Mulya, agar kebutuhan '
                'penyiraman tiap petak mudah dipantau.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 24),

              // Kartu informasi LSTM
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gelap
                        ? [const Color(0xFF1B5E20), const Color(0xFF263D2A)]
                        : [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: hijau.withValues(alpha: 0.25)),
                  boxShadow: [
                    BoxShadow(
                      color: hijau.withValues(alpha: 0.10),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Row(
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: gelap ? Colors.white12 : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(Icons.memory, color: hijau, size: 32),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Model: LSTM (Deep Learning)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: gelap ? Colors.white : hijauTua,
                            ),
                          ),

                          const SizedBox(height: 8),

                          _informasiModel(
                            Icons.access_time,
                            'Prediksi 24 jam ke depan',
                            gelap,
                          ),

                          const SizedBox(height: 7),

                          _informasiModel(
                            Icons.thermostat,
                            '3 parameter: suhu udara, '
                            'kelembapan udara, '
                            'kelembapan tanah',
                            gelap,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Tombol tentang aplikasi
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () => _tentangAplikasi(context),
                  icon: const Icon(Icons.info_outline),
                  label: const Text(
                    'Tentang Aplikasi',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: hijau,
                    side: const BorderSide(color: hijau, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _informasiModel(IconData icon, String teks, bool gelap) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 19, color: gelap ? Colors.white70 : hijauTua),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            teks,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: gelap ? Colors.white70 : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
