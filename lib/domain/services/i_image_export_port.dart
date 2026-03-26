/// Abstraction for saving and sharing an image by URL (dependency inversion).
abstract class IImageExportPort {
  Future<void> shareImageFromUrl(String imageUrl);

  Future<void> saveImageToGalleryFromUrl(String imageUrl);
}
