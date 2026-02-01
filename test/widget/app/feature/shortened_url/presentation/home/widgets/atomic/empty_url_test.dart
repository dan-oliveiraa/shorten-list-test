import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/widgets/atomic/empty_url.dart';

void main() {
  group('EmptyUrl Widget', () {
    testWidgets('renders "No URLs yet" message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyUrl(),
          ),
        ),
      );

      expect(find.text('No URLs yet'), findsOneWidget);
    });

    testWidgets('displays message in center', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyUrl(),
          ),
        ),
      );

      expect(find.byType(Center), findsOneWidget);
    });
  });
}
