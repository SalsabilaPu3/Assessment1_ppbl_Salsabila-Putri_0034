
import 'package:flutter/material.dart';

import 'kerangka_navigasi.dart';
import '../pages/halaman_pengaturan.dart';
import '../pages/halaman_prediksi.dart';

class AppRoutes {
  static const beranda = '/';
  static const tentang = '/tentang';
  static const inputPrediksi = '/input-prediksi';

  static Map<String, WidgetBuilder> daftarRoute() => {
        beranda: (_) => const KerangkaNavigasi(),
        tentang: (_) => const HalamanPengaturan(),
        inputPrediksi: (_) => const HalamanPrediksi(),
      };
}
