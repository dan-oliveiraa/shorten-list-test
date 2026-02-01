import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shorten_list_test/app/common/widgets/empty_data.dart';

void main() {
  group('EmptyData Widget', () {
    testWidgets('renders message in center', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyData(message: 'No data available'),
          ),
        ),
      );

      expect(find.text('No data available'), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('displays grey text with size 14', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyData(message: 'Empty state'),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Empty state'));
      expect(text.style?.fontSize, equals(14));
      expect(text.style?.color, equals(Colors.grey[400]));
    });
  });
}
