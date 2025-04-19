import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class TranslationScreenUsingDeepSeek extends StatefulWidget {
  const TranslationScreenUsingDeepSeek({super.key});

  @override
  State<TranslationScreenUsingDeepSeek> createState() =>
      _TranslationScreenUsingDeepSeekState();
}

class _TranslationScreenUsingDeepSeekState
    extends State<TranslationScreenUsingDeepSeek> {
  final TextEditingController _arabicTextController = TextEditingController();
  String _translatedText = '';
  bool _isTranslating = false;
  bool _isOnline = true;

  // You need to replace this with your actual DeepSeek API key
  final String _apiKey = '';
  final String _apiUrl = 'https://api.deepseek.com/v1/chat/completions';

  @override
  void initState() {
    super.initState();
    _checkConnectivity();

    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _isOnline = result != ConnectivityResult.none;
      });
    });
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isOnline = connectivityResult != ConnectivityResult.none;
    });
  }

  Future<void> _translateText() async {
    final textToTranslate = _arabicTextController.text.trim();
    if (textToTranslate.isEmpty) return;

    setState(() {
      _isTranslating = true;
    });

    // If offline, show error message
    if (!_isOnline) {
      setState(() {
        _translatedText =
            'You are offline. Connect to the internet to translate new text.';
        _isTranslating = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          'model': 'deepseek-chat', // Use appropriate DeepSeek model
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a translator that translates Arabic to English. Provide only the translated text without any additional information or commentary.'
            },
            {'role': 'user', 'content': textToTranslate}
          ],
          'temperature': 0.2,
          'max_tokens': 1024
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final translatedText =
            jsonResponse['choices'][0]['message']['content'].toString().trim();

        setState(() {
          _translatedText = translatedText;
        });
      } else {
        setState(() {
          _translatedText =
              'Error: ${response.statusCode} - ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _translatedText = 'Error: $e';
      });
    } finally {
      setState(() {
        _isTranslating = false;
      });
    }
  }

  @override
  void dispose() {
    _arabicTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DeepSeek AI Translator'),
        actions: [
          // Connection status indicator
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              _isOnline ? Icons.cloud_done : Icons.cloud_off,
              color: _isOnline ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Source language section
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(7),
                        topRight: Radius.circular(7),
                      ),
                    ),
                    child: const Text(
                      'Arabic',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextField(
                    controller: _arabicTextController,
                    maxLines: 5,
                    textDirection: TextDirection.rtl,
                    decoration: const InputDecoration(
                      hintText: 'أدخل النص بالعربية',
                      hintTextDirection: TextDirection.rtl,
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Translate button
            ElevatedButton(
              onPressed: _isTranslating ? null : _translateText,
              child: _isTranslating
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 10),
                        Text('Translating...'),
                      ],
                    )
                  : const Text('Translate with DeepSeek AI'),
            ),

            const SizedBox(height: 12),

            // Target language section
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(7),
                        topRight: Radius.circular(7),
                      ),
                    ),
                    child: const Text(
                      'English',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    height: 120,
                    child: _translatedText.isEmpty
                        ? const Text('Translation will appear here',
                            style: TextStyle(color: Colors.grey))
                        : Text(_translatedText),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Additional features section
            const Text(
              'Benefits of DeepSeek AI Translation:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                      'High-quality translations with neural machine learning'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                      'Accurate handling of Arabic dialects and expressions'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                      'Fast, real-time translation from Arabic to English'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
