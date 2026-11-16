import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'prediksi_state.dart';
import '../models/prediksi_model.dart';

class PrediksiCubit extends Cubit<PrediksiState> {
  PrediksiCubit() : super(const PrediksiState());

  // 1. Menambahkan data prediksi
  void tambahData(HasilPrediksi data) {
    final dataBaru = [...state.daftarPrediksi, data];

    emit(state.copyWith(daftarPrediksi: dataBaru));
  }

  // 2. Menghapus satu data prediksi
  void hapusData(HasilPrediksi data) {
    final dataBaru = List<HasilPrediksi>.from(state.daftarPrediksi);

    dataBaru.remove(data);

    emit(state.copyWith(daftarPrediksi: dataBaru));
  }

  // 3. Menghapus seluruh data prediksi
  void hapusSemuaData() {
    emit(state.copyWith(daftarPrediksi: []));
  }

  // 4. Filter berdasarkan petak
  void filterPetak(String petak) {
    emit(state.copyWith(filterPetak: petak));
  }

  // 5. Membuat 10 data simulasi
  void buatDataSimulasi() {
    final random = Random();

    const daftarPetak = ['Petak 1', 'Petak 2'];

    const daftarTanaman = ['Padi', 'Jagung', 'Cabai'];

    final dataSimulasi = List.generate(10, (index) {
      return HasilPrediksi(
        petak: daftarPetak[random.nextInt(daftarPetak.length)],
        tanaman: daftarTanaman[random.nextInt(daftarTanaman.length)],
        suhuUdara: (18 + random.nextInt(18)).toDouble(),
        kelembapanUdara: (40 + random.nextInt(61)).toDouble(),
        kelembapanTanah: (20 + random.nextInt(71)).toDouble(),
        namaPetugas: 'Petugas Simulasi',
        waktu: DateTime.now().subtract(Duration(hours: index)),
      );
    });

    emit(
      state.copyWith(
        daftarPrediksi: [...state.daftarPrediksi, ...dataSimulasi],
      ),
    );
  }
}
