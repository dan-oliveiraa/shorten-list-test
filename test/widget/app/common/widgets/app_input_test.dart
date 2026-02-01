import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shorten_list_test/app/common/widgets/app_input.dart';

void main() {
  group('AppInput Widget', () {
    testWidgets('renders TextFormField with hint text', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppInput(
              inputController: controller,
              hintText: 'Enter text',
            ),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Enter text'), findsOneWidget);
    });

    testWidgets('controller updates when text is entered', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppInput(
              inputController: controller,
              hintText: 'Enter text',
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'test input');

      expect(controller.text, equals('test input'));
    });

    testWidgets('calls onSaved when form is saved', (tester) async {
      final controller = TextEditingController();
      String? savedValue;
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: AppInput(
                inputController: controller,
                hintText: 'Enter text',
                onSaved: (value) => savedValue = value,
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'saved text');
      formKey.currentState?.save();

      expect(savedValue, equals('saved text'));
    });

    testWidgets('validator returns error message for invalid input', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: AppInput(
                inputController: controller,
                hintText: 'Enter text',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Field cannot be empty';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      );

      final field = tester.widget<TextFormField>(find.byType(TextFormField));
      final error = field.validator?.call('');

      expect(error, equals('Field cannot be empty'));
    });

    testWidgets('validator returns null for valid input', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: AppInput(
                inputController: controller,
                hintText: 'Enter text',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Field cannot be empty';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      );

      final field = tester.widget<TextFormField>(find.byType(TextFormField));
      final error = field.validator?.call('valid input');

      expect(error, isNull);
    });
  });
}
