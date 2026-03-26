/// Абстракция для сохранения и шеринга изображения по URL (инверсия зависимостей).
abstract class IImageExportPort {
  Future<void> shareImageFromUrl(String imageUrl);

  Future<void> saveImageToGalleryFromUrl(String imageUrl);
}
