import '../../enum/global_error_types.dart';

class GlobalErrorDTO {
  GlobalErrorTypes type;
  String message;
  GlobalErrorDTO({
    required this.type,
    required this.message,
  });

  @override
  String toString() {
    return message;
  }
}
