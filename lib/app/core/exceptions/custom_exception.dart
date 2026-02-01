import 'package:shorten_list_test/app/core/enum/global_error_types.dart';

class CustomException implements Exception {
  final String message;
  GlobalErrorTypes type;

  CustomException({
    required this.message,
    required this.type,
  });

  @override
  String toString() {
    return message;
  }
}
