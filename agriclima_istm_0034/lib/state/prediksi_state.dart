import '../models/prediksi_model.dart';

class PrediksiState {
  final List<HasilPrediksi> daftarPrediksi;
  final String filterPetak;

  const PrediksiState({
    this.daftarPrediksi = const [],
    this.filterPetak = 'Semua',
  });

  // Data yang sudah difilter
  List<HasilPrediksi> get prediksiTerfilter {
    if (filterPetak == 'Petak 1') {
      return daftarPrediksi.where((data) => data.petak == 'Petak 1').toList();
    }

    if (filterPetak == 'Petak 2') {
      return daftarPrediksi.where((data) => data.petak == 'Petak 2').toList();
    }

    return daftarPrediksi;
  }

  // Menghitung total prediksi
  int get total => daftarPrediksi.length;

  // Menghitung prediksi optimal
  int get jumlahOptimal =>
      daftarPrediksi.where((data) => data.status == 'Optimal').length;

  // Menghitung prediksi perlu tindakan
  int get perluTindakan =>
      daftarPrediksi.where((data) => data.status != 'Optimal').length;

  // Menghitung status kering
  int get jumlahKering =>
      daftarPrediksi.where((data) => data.status == 'Kering').length;

  // Menghitung status terlalu lembap
  int get jumlahTerlaluLembap =>
      daftarPrediksi.where((data) => data.status == 'Terlalu Lembap').length;

  // Mengubah state
  PrediksiState copyWith({
    List<HasilPrediksi>? daftarPrediksi,
    String? filterPetak,
  }) {
    return PrediksiState(
      daftarPrediksi: daftarPrediksi ?? this.daftarPrediksi,
      filterPetak: filterPetak ?? this.filterPetak,
    );
  }
}
