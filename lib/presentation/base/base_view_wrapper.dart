import 'dart:async';

/// Base view wrapper with one [StreamController.broadcast] and the current state.
abstract class BaseViewWrapper<T> {
  BaseViewWrapper(T initialState) {
    _currentState = initialState;
    _controller = StreamController<T>.broadcast();
    _controller.add(initialState);
  }

  late final StreamController<T> _controller;
  late T _currentState;

  T get currentState => _currentState;

  Stream<T> get stream => _controller.stream;

  /// Updates the state and notifies [stream] subscribers.
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
