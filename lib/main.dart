import 'package:flutter/material.dart';
import 'package:shorten_list_test/app/router/app_router.dart';
import 'package:shorten_list_test/app_module.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppDI().configure();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'URL Shortener',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router,
    );
  }
}
