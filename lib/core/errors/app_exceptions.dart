/// Базовая ошибка приложения.
class AppException implements Exception {
  const AppException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => 'AppException: $message';
}

/// Ошибка сети или транспорта.
class NetworkException extends AppException {
  const NetworkException(super.message, [super.cause]);
}
