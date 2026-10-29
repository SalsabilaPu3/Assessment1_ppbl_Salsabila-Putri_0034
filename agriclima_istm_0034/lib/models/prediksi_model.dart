class PrediksiModel {
  PrediksiModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.umur,
    required this.kategori,
    required this.sesi,
    required this.catatan,
    required this.disetujui,
    required this.tanggal,
    this.selesai = false,
  });

  final String id;
  final String nama;
  final String email;
  final int umur;
  final String kategori;
  final String sesi;
  final String catatan;
  final bool disetujui;
  final DateTime tanggal;
  bool selesai;

  String get status => selesai ? 'Selesai' : 'Diproses';

  Map<String, dynamic> toMap() => {
        'id': id,
        'nama': nama,
        'email': email,
        'umur': umur,
        'kategori': kategori,
        'sesi': sesi,
        'catatan': catatan,
        'disetujui': disetujui,
        'tanggal': tanggal.toIso8601String(),
        'selesai': selesai,
      };
}
