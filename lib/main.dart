import 'package:flutter/material.dart';
import 'package:translate_ai/screens/translation_screen_using_deepseek.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TranslationScreenUsingDeepSeek(),
    );
  }
}
