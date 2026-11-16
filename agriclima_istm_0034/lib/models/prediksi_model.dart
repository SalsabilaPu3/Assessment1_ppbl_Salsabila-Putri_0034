class HasilPrediksi {
  final String petak;
  final String tanaman;
  final double suhuUdara;
  final double kelembapanUdara;
  final double kelembapanTanah;
  final String namaPetugas;
  final DateTime waktu;

  HasilPrediksi({
    required this.petak,
    required this.tanaman,
    required this.suhuUdara,
    required this.kelembapanUdara,
    required this.kelembapanTanah,
    required this.namaPetugas,
    required this.waktu,
  });

  // Menentukan status mikroklimat berdasarkan kelembapan tanah
  String get status {
    if (kelembapanTanah < 40) {
      return 'Kering';
    } else if (kelembapanTanah <= 70) {
      return 'Optimal';
    } else {
      return 'Terlalu Lembap';
    }
  }

  // Rekomendasi berdasarkan status mikroklimat
  String get rekomendasi {
    if (kelembapanTanah < 40) {
      return 'Segera lakukan penyiraman atau irigasi';
    } else if (kelembapanTanah <= 70) {
      return 'Pertahankan pola perawatan saat ini';
    } else {
      return 'Kurangi penyiraman dan periksa drainase';
    }
  }

  // Catatan perawatan setiap tanaman sesuai Tabel B
  static const Map<String, String> catatanPerawatan = {
    'Padi': 'Jaga genangan air 2–5 cm pada fase vegetatif dan keringkan lahan menjelang panen.',
    'Jagung': 'Siram saat tanah mulai kering dan hindari genangan di sekitar perakaran.',
    'Cabai': 'Gunakan mulsa untuk menjaga kelembapan tanah dan siram pada pagi atau sore hari.',
  };

  // Mengambil catatan perawatan sesuai jenis tanaman
  String get catatanTanaman {
    return catatanPerawatan[tanaman] ?? 'Catatan perawatan tidak tersedia';
  }
}
