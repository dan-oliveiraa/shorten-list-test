import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/contracts/controller/home_controller_interface.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/home_view.dart';
import 'package:shorten_list_test/app_module.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppModule().configure();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'URL Shortener',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeView(GetIt.instance<IHomeController>()),
    );
  }
}
