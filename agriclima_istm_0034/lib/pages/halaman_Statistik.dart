
import 'package:flutter/material.dart';

class HalamanStatistik extends StatelessWidget {
  const HalamanStatistik({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AgriClima - Statistik'),
        backgroundColor: const Color.fromARGB(255, 129, 21, 127),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Jumlah Prediksi per Status Mikroklimat',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(12),
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomPaint(
                painter: GrafikBatangPainter(),
                child: const SizedBox.expand(),
              ),
            ),

            const SizedBox(height: 12),

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Kering'),
                Text('Optimal'),
                Text('Terlalu Lembap'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GrafikBatangPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final garis = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;

    for (int i = 0; i <= 6; i++) {
      final y = size.height * i / 6;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        garis,
      );
    }

    final nilai = [30.0, 20.0, 10.0];
    final warna = [
      Colors.orange,
      Colors.green,
      Colors.blue,
    ];

    final lebar = size.width / 5;

    for (int i = 0; i < nilai.length; i++) {
      final tinggi = (nilai[i] / 30) * size.height;
      final x = size.width / 6 * (i * 2 + 1);

      final rect = Rect.fromLTWH(
        x - lebar / 2,
        size.height - tinggi,
        lebar,
        tinggi,
      );

      final batang = Paint()..color = warna[i];

      canvas.drawRect(rect, batang);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
