import 'package:flutter/material.dart';

import '../../core/utils/stream_emitter.dart';

abstract class BaseController<T> extends ChangeNotifier {
  Stream<T> get onState;
  StreamEmitter<T> get emitter;
}
