/// Базовый контракт use case (без зависимостей от Flutter).
abstract class UseCase<T, Params> {
  Future<T> call(Params params);
}

/// Use case без параметров.
abstract class UseCaseNoParams<T> {
  Future<T> call();
}
