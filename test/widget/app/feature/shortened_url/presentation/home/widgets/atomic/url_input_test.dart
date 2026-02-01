import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/value_objects/shorten_url_input.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/widgets/atomic/url_input.dart';

void main() {
  group('UrlInput Widget', () {
    testWidgets('renders AppInput with hint', (tester) async {
      final controller = TextEditingController();
      final input = ShortenUrlInput.empty();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UrlInput(
              urlController: controller,
              input: input,
            ),
          ),
        ),
      );

      expect(find.text('Type URL here'), findsOneWidget);
    });

    testWidgets('saves URL to input value object when valid', (tester) async {
      final controller = TextEditingController();
      final input = ShortenUrlInput.empty();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: UrlInput(
                urlController: controller,
                input: input,
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'https://example.com');
      Form.of(tester.element(find.byType(UrlInput))).save();

      expect(input.url.value, equals('https://example.com'));
    });

    testWidgets('validates URL format', (tester) async {
      final controller = TextEditingController();
      final input = ShortenUrlInput.empty();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: UrlInput(
                urlController: controller,
                input: input,
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'invalid-url');
      final isValid = Form.of(tester.element(find.byType(UrlInput))).validate();

      expect(isValid, isFalse);
    });

    testWidgets('accepts valid URL', (tester) async {
      final controller = TextEditingController();
      final input = ShortenUrlInput.empty();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: UrlInput(
                urlController: controller,
                input: input,
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'https://valid.com');
      final isValid = Form.of(tester.element(find.byType(UrlInput))).validate();

      expect(isValid, isTrue);
    });

    testWidgets('uses provided controller', (tester) async {
      final controller = TextEditingController(text: 'https://initial.com');
      final input = ShortenUrlInput.empty();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UrlInput(
              urlController: controller,
              input: input,
            ),
          ),
        ),
      );

      expect(find.text('https://initial.com'), findsOneWidget);
    });
  });
}
