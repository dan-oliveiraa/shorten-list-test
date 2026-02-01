import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/widgets/atomic/shortened_url_tile.dart';

void main() {
  group('ShortenedUrlTile Widget', () {
    testWidgets('renders alias text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShortenedUrlTile(alias: 'my-link-123'),
          ),
        ),
      );

      expect(find.text('my-link-123'), findsOneWidget);
    });

    testWidgets('displays text with correct styling', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShortenedUrlTile(alias: 'test-alias'),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('test-alias'));
      expect(text.style?.fontSize, equals(14));
      expect(text.style?.color, equals(Colors.black87));
    });

    testWidgets('has rounded grey background', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShortenedUrlTile(alias: 'alias'),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.color, equals(Colors.grey[200]));
      expect(decoration.borderRadius, equals(BorderRadius.circular(8)));
    });

    testWidgets('handles long alias text', (tester) async {
      const longAlias = 'this-is-a-very-long-alias-name-for-testing-purposes';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShortenedUrlTile(alias: longAlias),
          ),
        ),
      );

      expect(find.text(longAlias), findsOneWidget);
    });
  });
}
