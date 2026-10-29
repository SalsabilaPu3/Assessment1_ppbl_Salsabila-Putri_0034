
import 'package:flutter/material.dart';

class HalamanPrediksi extends StatefulWidget {
  const HalamanPrediksi({super.key});

  @override
  State<HalamanPrediksi> createState() => _HalamanPrediksiState();
}

class _HalamanPrediksiState extends State<HalamanPrediksi> {
  final _formKey = GlobalKey<FormState>();

  String _petak = 'Petak 1';
  String? _tanaman;
  bool _dataBenar = false;

  final TextEditingController _suhuController = TextEditingController();
  final TextEditingController _petugasController = TextEditingController();
  final TextEditingController _prediksiSuhuController =
      TextEditingController();
  final TextEditingController _kelembapanUdaraController =
      TextEditingController();
  final TextEditingController _kelembapanTanahController =
      TextEditingController();

  @override
  void dispose() {
    _suhuController.dispose();
    _petugasController.dispose();
    _prediksiSuhuController.dispose();
    _kelembapanUdaraController.dispose();
    _kelembapanTanahController.dispose();
    super.dispose();
  }

  String? _validasiAngka(
    String? value, {
    required String nama,
    required double minimum,
    required double maksimum,
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$nama harus diisi';
    }

    final angka = double.tryParse(value.trim().replaceAll(',', '.'));

    if (angka == null) {
      return 'Masukkan angka yang valid';
    }

    if (angka < minimum || angka > maksimum) {
      return 'Nilai harus antara $minimum dan $maksimum';
    }

    return null;
  }

  void _simpanPrediksi() {
    final formValid = _formKey.currentState!.validate();

    if (!formValid) return;

    if (!_dataBenar) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan konfirmasi bahwa data sudah benar.'),
        ),
      );
      return;
    }

    final suhu = double.parse(
      _suhuController.text.trim().replaceAll(',', '.'),
    );
    final prediksiSuhu = double.parse(
      _prediksiSuhuController.text.trim().replaceAll(',', '.'),
    );
    final kelembapanUdara = double.parse(
      _kelembapanUdaraController.text.trim().replaceAll(',', '.'),
    );
    final kelembapanTanah = double.parse(
      _kelembapanTanahController.text.trim().replaceAll(',', '.'),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Data prediksi $_petak berhasil divalidasi.',
        ),
      ),
    );

    // Data sudah divalidasi dan dapat dihubungkan ke model HasilPrediksi.
    debugPrint('Petak: $_petak');
    debugPrint('Tanaman: $_tanaman');
    debugPrint('Suhu saat ini: $suhu °C');
    debugPrint('Petugas: ${_petugasController.text.trim()}');
    debugPrint('Prediksi suhu: $prediksiSuhu °C');
    debugPrint('Prediksi kelembapan udara: $kelembapanUdara%');
    debugPrint('Prediksi kelembapan tanah: $kelembapanTanah%');
  }

  Widget _judulPertanyaan(String judul) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        judul,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _garisPemisah() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Divider(height: 1, thickness: 1),
    );
  }

  InputDecoration _dekorasiInput(String petunjuk) {
    return InputDecoration(
      hintText: petunjuk,
      border: InputBorder.none,
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF2E7D32), width: 2),
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    const hijau = Color.fromARGB(255, 48, 59, 182);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Prediksi Mikroklimat'),
        backgroundColor: const Color.fromARGB(255, 46, 88, 125),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pilihan petak
                _judulPertanyaan('Pilih Petak Pertanian'),
                RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Petak 1'),
                  value: 'Petak 1',
                  groupValue: _petak,
                  activeColor: const Color.fromARGB(255, 63, 46, 125),
                  onChanged: (value) {
                    setState(() {
                      _petak = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Petak 2'),
                  value: 'Petak 2',
                  groupValue: _petak,
                  activeColor: const Color.fromARGB(255, 46, 62, 125),
                  onChanged: (value) {
                    setState(() {
                      _petak = value!;
                    });
                  },
                ),

                _garisPemisah(),

                // Jenis tanaman
                _judulPertanyaan('Jenis Tanaman'),
                DropdownButtonFormField<String>(
                  value: _tanaman,
                  isExpanded: true,
                  decoration: _dekorasiInput('Pilih jenis tanaman'),
                  items: const [
                    DropdownMenuItem(
                      value: 'Padi',
                      child: Text('Padi'),
                    ),
                    DropdownMenuItem(
                      value: 'Jagung',
                      child: Text('Jagung'),
                    ),
                    DropdownMenuItem(
                      value: 'Dabai',
                      child: Text('Dabai'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _tanaman = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Pilih jenis tanaman terlebih dahulu';
                    }
                    return null;
                  },
                ),

                _garisPemisah(),

                // Suhu saat ini
                _judulPertanyaan('Suhu Saat Ini (°C)'),
                TextFormField(
                  controller: _suhuController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  decoration: _dekorasiInput('Masukkan suhu saat ini'),
                  validator: (value) => _validasiAngka(
                    value,
                    nama: 'Suhu saat ini',
                    minimum: -50,
                    maksimum: 70,
                  ),
                ),

                _garisPemisah(),

                // Nama petugas
                _judulPertanyaan('Nama Petugas'),
                TextFormField(
                  controller: _petugasController,
                  textCapitalization: TextCapitalization.words,
                  decoration: _dekorasiInput('Masukkan nama petugas'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama petugas harus diisi';
                    }
                    return null;
                  },
                ),

                _garisPemisah(),

                // Bagian tambahan prediksi
                const Text(
                  'Hasil Prediksi Mikroklimat',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 46, 53, 125),
                  ),
                ),
                const SizedBox(height: 8),

                // Prediksi suhu
                _judulPertanyaan(
                  'Prediksi Suhu Tambahan Pertanian (°C)',
                ),
                TextFormField(
                  controller: _prediksiSuhuController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  decoration: _dekorasiInput('Masukkan prediksi suhu'),
                  validator: (value) => _validasiAngka(
                    value,
                    nama: 'Prediksi suhu',
                    minimum: -50,
                    maksimum: 70,
                  ),
                ),

                _garisPemisah(),

                // Prediksi kelembapan udara
                _judulPertanyaan('Prediksi Kelembapan Udara (%)'),
                TextFormField(
                  controller: _kelembapanUdaraController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: _dekorasiInput(
                    'Masukkan prediksi kelembapan udara',
                  ),
                  validator: (value) => _validasiAngka(
                    value,
                    nama: 'Prediksi kelembapan udara',
                    minimum: 0,
                    maksimum: 100,
                  ),
                ),

                _garisPemisah(),

                // Prediksi kelembapan tanah
                _judulPertanyaan('Prediksi Kelembapan Tanah (%)'),
                TextFormField(
                  controller: _kelembapanTanahController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: _dekorasiInput(
                    'Masukkan prediksi kelembapan tanah',
                  ),
                  validator: (value) => _validasiAngka(
                    value,
                    nama: 'Prediksi kelembapan tanah',
                    minimum: 0,
                    maksimum: 100,
                  ),
                ),

                _garisPemisah(),

                // Konfirmasi data
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Data sudah benar'),
                  value: _dataBenar,
                  activeColor: const Color.fromARGB(255, 59, 46, 125),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    setState(() {
                      _dataBenar = value ?? false;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // Tombol simpan
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _simpanPrediksi,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 68, 46, 125),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text('Simpan Prediksi'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
