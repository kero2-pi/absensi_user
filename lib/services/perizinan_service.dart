import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/api.dart';
import '../core/storage.dart';

class PerizinanService {
  static Future<bool> store({
    required String jenis,
    required String tanggalMulai,
    required String tanggalSelesai,
    String? keterangan,
    File? lampiran,
  }) async {
    final token = await SecureStorage.getToken();

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${Api.baseUrl}/perizinan'),
    );

    request.headers.addAll(Api.authHeader(token!));

    request.fields['jenis'] = jenis;
    request.fields['tanggal_mulai'] = tanggalMulai;
    request.fields['tanggal_selesai'] = tanggalSelesai;

    if (keterangan != null) {
      request.fields['keterangan'] = keterangan;
    }

    if (lampiran != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'lampiran',
          lampiran.path,
        ),
      );
    }

    final res = await request.send();
    return res.statusCode == 200 || res.statusCode == 201;
  }
}
