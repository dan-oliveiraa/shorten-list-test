import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shorten_list_test/app/core/contracts/service/global_error_interface.dart';
import 'package:shorten_list_test/app/core/enum/global_error_types.dart';
import 'package:shorten_list_test/app/core/service/dto/global_error_dto.dart';
import 'package:shorten_list_test/app/core/utils/safe_executor.dart';

class MockGlobalErrorService extends Mock implements IGlobalErrorService {}

class MockGlobalErrorCallback extends Mock {
  void call(GlobalErrorDTO globalError);
}

void main() {
  late MockGlobalErrorService errorService;
  late SafeExecutor executor;

  setUp(() {
    errorService = MockGlobalErrorService();
    executor = SafeExecutor(errorService);
  });

  test('guard returns action result on success', () async {
    final result = await executor.guard(
      () async => 10,
      contextErrorMessage: 'context',
      onError: (_) {},
    );

    expect(result, 10);
  });

  test('guard handles exception and triggers onError', () async {
    final callback = MockGlobalErrorCallback();
    final dto = GlobalErrorDTO(
      type: GlobalErrorTypes.exception,
      message: 'error',
    );

    when(() => errorService.exceptionHandling(
          any(),
          exception: any(named: 'exception'),
          stackTrace: any(named: 'stackTrace'),
        )).thenReturn(dto);

    await executor.guard<void>(
      () async => throw Exception('fail'),
      contextErrorMessage: 'context',
      onError: callback.call,
    );

    verify(() => callback.call(dto)).called(1);
  });
}
