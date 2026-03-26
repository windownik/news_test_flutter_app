import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/errors/app_exceptions.dart';
import '../../domain/services/i_image_export_port.dart';

class ImageExportServiceImpl implements IImageExportPort {
  ImageExportServiceImpl({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  @override
  Future<void> shareImageFromUrl(String imageUrl) async {
    final bytes = await _downloadBytes(imageUrl);
    final file = await _writeTempFile(bytes);
    await Share.shareXFiles([XFile(file.path)]);
  }

  @override
  Future<void> saveImageToGalleryFromUrl(String imageUrl) async {
    final bytes = await _downloadBytes(imageUrl);
    await Gal.putImageBytes(bytes);
  }

  Future<Uint8List> _downloadBytes(String url) async {
    try {
      final response = await _dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      final data = response.data;
      if (data == null) {
        throw const AppException('Empty image response');
      }
      return Uint8List.fromList(data);
    } on DioException catch (e) {
      throw NetworkException(e.message ?? 'Download failed', e);
    }
  }

  Future<File> _writeTempFile(Uint8List bytes) async {
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/news_share_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await file.writeAsBytes(bytes);
    return file;
  }
}
