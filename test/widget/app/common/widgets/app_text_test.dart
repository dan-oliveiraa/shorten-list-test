import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shorten_list_test/app/common/widgets/app_text.dart';

void main() {
  group('AppText Widget', () {
    testWidgets('renders text with default styling', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppText(message: 'Test message'),
          ),
        ),
      );

      expect(find.text('Test message'), findsOneWidget);

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.fontSize, equals(16));
      expect(text.style?.fontWeight, equals(FontWeight.normal));
      expect(text.style?.color, equals(Colors.black));
    });

    testWidgets('renders text with custom fontSize', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppText(
              message: 'Large text',
              fontSize: 24,
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Large text'));
      expect(text.style?.fontSize, equals(24));
    });

    testWidgets('renders text with custom fontWeight', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppText(
              message: 'Bold text',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Bold text'));
      expect(text.style?.fontWeight, equals(FontWeight.bold));
    });

    testWidgets('renders text with custom color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppText(
              message: 'Red text',
              color: Colors.red,
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Red text'));
      expect(text.style?.color, equals(Colors.red));
    });
  });
}
