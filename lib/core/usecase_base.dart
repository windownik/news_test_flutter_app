/// Base use case contract without Flutter dependencies.
abstract class UseCase<T, Params> {
  Future<T> call(Params params);
}

/// Use case without parameters.
abstract class UseCaseNoParams<T> {
  Future<T> call();
}
