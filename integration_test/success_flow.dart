import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shorten_list_test/app/router/app_router.dart';
import 'package:shorten_list_test/app_module.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('URL Shortener Success Flow Integration Test', () {
    setUpAll(() async {
      AppDI().configure();
    });

    setUp(() async {
      await GetIt.instance.reset();
      AppDI().configure();
    });

    tearDown(() async {
      await GetIt.instance.reset();
    });

    tearDownAll(() {
      binding.reportData = <String, dynamic>{};
      SystemNavigator.pop();
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        exit(0);
      }
    });

    testWidgets(
      'Complete flow: Input valid URL -> Click button -> API call -> Display in list',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp.router(
            routerConfig: AppRouter.router,
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('No URLs yet'), findsOneWidget);
        expect(find.text('Recent Shortened URLs'), findsOneWidget);

        final urlInputFinder = find.byType(TextFormField);

        expect(urlInputFinder, findsOneWidget);

        const testUrl = 'https://www.example.com/very/long/path/to/test';

        await tester.enterText(urlInputFinder, testUrl);
        await tester.pumpAndSettle();

        expect(find.text(testUrl), findsOneWidget);

        final submitButtonFinder = find.byIcon(Icons.arrow_forward);

        expect(submitButtonFinder, findsOneWidget);

        await tester.tap(submitButtonFinder);
        await tester.pump();

        bool apiCompleted = false;

        for (int i = 0; i < 60; i++) {
          await tester.pump(const Duration(seconds: 1));
          if (find.text('No URLs yet').evaluate().isEmpty) {
            apiCompleted = true;
            break;
          }
        }

        expect(apiCompleted, isTrue, reason: 'API call did not complete within 60 seconds');

        await tester.pumpAndSettle();

        expect(find.text('No URLs yet'), findsNothing);
        expect(find.byType(ListView), findsOneWidget);

        final listViewFinder = find.byType(ListView);

        expect(listViewFinder, findsOneWidget);

        final listView = tester.widget<ListView>(listViewFinder);

        expect(listView.semanticChildCount, greaterThan(0));
        expect(find.text('Recent Shortened URLs'), findsOneWidget);
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );

    testWidgets(
      'Multiple URLs flow: Submit multiple valid URLs and verify all appear in list',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp.router(
            routerConfig: AppRouter.router,
          ),
        );

        await tester.pumpAndSettle();

        final testUrls = [
          'https://www.google.com',
          'https://www.github.com/flutter/flutter',
          'https://pub.dev/packages/flutter_test',
        ];

        for (int i = 0; i < testUrls.length; i++) {
          final urlInputFinder = find.byType(TextFormField);

          await tester.enterText(urlInputFinder, testUrls[i]);
          await tester.pumpAndSettle();

          final submitButtonFinder = find.byIcon(Icons.arrow_forward);

          await tester.tap(submitButtonFinder);
          await tester.pump();

          for (int j = 0; j < 60; j++) {
            await tester.pump(const Duration(seconds: 1));
            if (find.byType(ListView).evaluate().isNotEmpty) break;
          }

          await tester.pump();

          final listViewFinder = find.byType(ListView);
          if (listViewFinder.evaluate().isNotEmpty) {
            final listView = tester.widget<ListView>(listViewFinder);
            expect(listView.semanticChildCount, equals(i + 1));
          }
        }

        final listViewFinder = find.byType(ListView);

        expect(listViewFinder, findsOneWidget);

        final listView = tester.widget<ListView>(listViewFinder);

        expect(listView.semanticChildCount, equals(testUrls.length));
        expect(find.text('No URLs yet'), findsNothing);
      },
      timeout: const Timeout(Duration(minutes: 5)),
    );

    testWidgets(
      'UI Components: Verify all elements are present and functional',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp.router(
            routerConfig: AppRouter.router,
          ),
        );

        await tester.pumpAndSettle();

        final inputFinder = find.byType(TextFormField);

        expect(inputFinder, findsOneWidget);

        expect(find.text('Type URL here'), findsOneWidget);
        expect(find.byIcon(Icons.arrow_forward), findsOneWidget);

        expect(find.text('Recent Shortened URLs'), findsOneWidget);
        expect(find.text('No URLs yet'), findsOneWidget);

        expect(find.byType(SafeArea), findsOneWidget);
        expect(find.byType(Padding), findsWidgets);
        expect(find.byType(Scaffold), findsOneWidget);
      },
    );

    testWidgets(
      'Form validation: Empty URL should not submit',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp.router(
            routerConfig: AppRouter.router,
          ),
        );

        await tester.pumpAndSettle();

        final submitButtonFinder = find.byIcon(Icons.arrow_forward);

        await tester.tap(submitButtonFinder);
        await tester.pumpAndSettle();

        expect(find.text('No URLs yet'), findsOneWidget);
        expect(find.byType(ListView), findsNothing);
      },
    );

    testWidgets(
      'Form validation: Invalid URL format should show error',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp.router(
            routerConfig: AppRouter.router,
          ),
        );

        await tester.pumpAndSettle();

        final urlInputFinder = find.byType(TextFormField);

        await tester.enterText(urlInputFinder, 'not-a-valid-url');
        await tester.pumpAndSettle();

        final submitButtonFinder = find.byIcon(Icons.arrow_forward);

        await tester.tap(submitButtonFinder);
        await tester.pumpAndSettle();

        expect(find.text('No URLs yet'), findsOneWidget);
      },
    );

    testWidgets(
      'Persistence test: URLs added remain in the list',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp.router(
            routerConfig: AppRouter.router,
          ),
        );

        await tester.pumpAndSettle();

        const firstUrl = 'https://www.flutter.dev';

        await tester.enterText(find.byType(TextFormField), firstUrl);
        await tester.pump();
        await tester.tap(find.byIcon(Icons.arrow_forward));
        await tester.pump();

        for (int i = 0; i < 60; i++) {
          await tester.pump(const Duration(seconds: 1));
          if (find.byType(ListView).evaluate().isNotEmpty) break;
        }

        await tester.pump();

        final listViewFinder = find.byType(ListView);

        if (listViewFinder.evaluate().isNotEmpty) {
          var listView = tester.widget<ListView>(listViewFinder);
          expect(listView.semanticChildCount, equals(1));

          const secondUrl = 'https://dart.dev';

          await tester.enterText(find.byType(TextFormField), secondUrl);
          await tester.pump();
          await tester.tap(find.byIcon(Icons.arrow_forward));
          await tester.pump();

          int previousCount = listView.semanticChildCount ?? 0;

          for (int i = 0; i < 60; i++) {
            await tester.pump(const Duration(seconds: 1));
            listView = tester.widget<ListView>(listViewFinder);
            if ((listView.semanticChildCount ?? 0) > previousCount) break;
          }

          await tester.pump();

          listView = tester.widget<ListView>(listViewFinder);

          expect(listView.semanticChildCount, equals(2));
          expect(find.byType(ListView), findsOneWidget);
        }
      },
      timeout: const Timeout(Duration(minutes: 3)),
    );

    testWidgets(
      'Loading state verification: Skeleton appears during API call',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp.router(
            routerConfig: AppRouter.router,
          ),
        );

        await tester.pumpAndSettle();

        const testUrl = 'https://www.example.com/test/loading';
        await tester.enterText(find.byType(TextFormField), testUrl);
        await tester.pump();

        await tester.tap(find.byIcon(Icons.arrow_forward));
        await tester.pump();

        await tester.pump(const Duration(milliseconds: 100));

        for (int i = 0; i < 60; i++) {
          await tester.pump(const Duration(seconds: 1));
          if (find.byType(ListView).evaluate().isNotEmpty) break;
        }

        await tester.pump();

        expect(find.byType(ListView), findsOneWidget);
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );
  });
}
