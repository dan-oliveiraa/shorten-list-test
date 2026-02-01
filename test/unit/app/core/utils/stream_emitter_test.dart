import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shorten_list_test/app/core/utils/stream_emitter.dart';

void main() {
  test('StreamEmitter emits values, errors, and closes correctly', () async {
    final subject = BehaviorSubject<int>();
    final emitter = StreamEmitter(subject);

    final values = <int>[];
    Object? error;

    final sub = subject.stream.listen(
      values.add,
      onError: (e) => error = e,
    );

    emitter.emit(1);
    emitter.emit(2);
    emitter.emitError('err');

    await Future<void>.delayed(Duration.zero);

    expect(values, [1, 2]);
    expect(error, 'err');

    await sub.cancel();
    emitter.close();
    expect(subject.isClosed, isTrue);
  });
}
