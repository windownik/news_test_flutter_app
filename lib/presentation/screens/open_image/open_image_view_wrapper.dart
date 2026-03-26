import '../../../domain/services/i_image_export_port.dart';
import '../../base/base_view_wrapper.dart';
import 'open_image_state.dart';

/// Handles saving and sharing a news image via [IImageExportPort].
class OpenImageViewWrapper extends BaseViewWrapper<OpenImageState> {
  OpenImageViewWrapper(this._imageExport) : super(const OpenImageIdle());

  final IImageExportPort _imageExport;

  Future<void> shareImage(String imageUrl) async {
    emit(const OpenImageBusy());
    try {
      await _imageExport.shareImageFromUrl(imageUrl);
      emit(const OpenImageMessage('Shared'));
    } catch (e) {
      emit(OpenImageMessage('Share failed: $e'));
    }
  }

  Future<void> saveImage(String imageUrl) async {
    emit(const OpenImageBusy());
    try {
      await _imageExport.saveImageToGalleryFromUrl(imageUrl);
      emit(const OpenImageMessage('Saved to gallery'));
    } catch (e) {
      emit(OpenImageMessage('Save failed: $e'));
    }
  }

  void resetMessage() => emit(const OpenImageIdle());
}
