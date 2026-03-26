import 'dart:async';

/// Базовый ViewWrapper: один [StreamController.broadcast] и текущее состояние.
abstract class BaseViewWrapper<T> {
  BaseViewWrapper(T initialState)
      : _currentState = initialState,
        _controller = StreamController<T>.broadcast() {
    _controller.add(initialState);
  }

  final StreamController<T> _controller;
  T _currentState;

  T get currentState => _currentState;

  Stream<T> get stream => _controller.stream;

  /// Обновить состояние и уведомить подписчиков [stream].
  void emit(T state) {
    _currentState = state;
    if (!_controller.isClosed) {
      _controller.add(state);
    }
  }

  void dispose() {
    _controller.close();
  }
}
