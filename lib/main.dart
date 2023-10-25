import 'package:flutter/material.dart';
import 'package:app_contatos/pages/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: const Color.fromRGBO(223, 59, 87, 1.0)),
        home: const HomePage());
  }
}
