import 'package:rxdart/rxdart.dart';

class StreamEmitter<T> {
  final BehaviorSubject<T> _controller;

  StreamEmitter(this._controller);

  void emit(T state) => _controller.add(state);
  void emitError(Object error) => _controller.addError(error);
  void close() => _controller.close();
}
