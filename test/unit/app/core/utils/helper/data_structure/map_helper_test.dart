import 'package:flutter_test/flutter_test.dart';
import 'package:shorten_list_test/app/core/utils/helper/data_structure/map_helper.dart';

void main() {
  test('mergeMaps merges maps and handles nulls', () {
    final result = MapHelper.mergeMaps([
      {'a': '1'},
      null,
      {'b': '2'},
      {'a': '2'},
    ]);

    expect(result, {'a': '2', 'b': '2'});
  });
}
