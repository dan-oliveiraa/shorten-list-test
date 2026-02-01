import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/widgets/atomic/url_button.dart';

void main() {
  group('UrlButton Widget', () {
    testWidgets('renders with forward arrow icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UrlButton(shortenUrl: () {}),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testWidgets('calls shortenUrl when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UrlButton(shortenUrl: () => tapped = true),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      expect(tapped, isTrue);
    });

    testWidgets('has grey background with rounded border', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UrlButton(shortenUrl: () {}),
          ),
        ),
      );

      final material = tester.widget<Material>(
        find
            .descendant(
              of: find.byType(UrlButton),
              matching: find.byType(Material),
            )
            .first,
      );

      expect(material.color, equals(Colors.grey[300]));
      expect(material.borderRadius, equals(BorderRadius.circular(8)));
    });

    testWidgets('has proper padding', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UrlButton(shortenUrl: () {}),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.padding, equals(const EdgeInsets.all(14)));
    });
  });
}
