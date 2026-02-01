import '../../core/utils/stream_emitter.dart';

abstract class BaseController<T> {
  Stream<T> get onState;
  StreamEmitter<T> get emitter;
}
