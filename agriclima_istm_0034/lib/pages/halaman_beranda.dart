
import 'package:flutter/material.dart';

class HalamanBeranda extends StatelessWidget {
  const HalamanBeranda({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 179, 174, 222),
      appBar: AppBar(
        title: const Text(
          'AgriClima LSTM',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 109, 22, 185),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.home,
                size: 90,
                color: Color.fromARGB(255, 70, 30, 138),
              ),
              const SizedBox(height: 24),
              const Text(
                'Selamat Datang di AgriClima LSTM',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 45, 8, 93),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Aplikasi untuk mencatat hasil prediksi '
                'mikroklimat tanaman di lahan Kelompok Tani '
                'Sri Mulya, agar kebutuhan penyiraman tiap '
                'petak mudah dipantau.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
