import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/value_objects/shorten_url_input.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/widgets/molecules/url_search.dart';

void main() {
  group('UrlSearch Widget', () {
    testWidgets('renders form with input and button', (tester) async {
      final controller = TextEditingController();
      final input = ShortenUrlInput.empty();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UrlSearch(
              urlController: controller,
              shortenUrl: () {},
              input: input,
            ),
          ),
        ),
      );

      expect(find.text('Type URL here'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testWidgets('calls shortenUrl when button tapped with valid form', (tester) async {
      final controller = TextEditingController();
      final input = ShortenUrlInput.empty();
      var submitCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UrlSearch(
              urlController: controller,
              shortenUrl: () => submitCalled = true,
              input: input,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'https://test.com');
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pump();

      expect(submitCalled, isTrue);
      expect(input.url.value, equals('https://test.com'));
    });

    testWidgets('does not call shortenUrl when form is invalid', (tester) async {
      final controller = TextEditingController();
      final input = ShortenUrlInput.empty();
      var submitCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UrlSearch(
              urlController: controller,
              shortenUrl: () => submitCalled = true,
              input: input,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'invalid');
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pump();

      expect(submitCalled, isFalse);
    });

    testWidgets('has proper layout with row and expanded input', (tester) async {
      final controller = TextEditingController();
      final input = ShortenUrlInput.empty();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UrlSearch(
              urlController: controller,
              shortenUrl: () {},
              input: input,
            ),
          ),
        ),
      );

      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Expanded), findsOneWidget);
    });
  });
}
