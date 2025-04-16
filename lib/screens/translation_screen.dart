// import 'package:flutter/material.dart';
// import 'package:google_mlkit_translation/google_mlkit_translation.dart';

// class TranslationScreen extends StatefulWidget {
//   const TranslationScreen({super.key});

//   @override
//   State<TranslationScreen> createState() => _TranslationScreenState();
// }

// class _TranslationScreenState extends State<TranslationScreen> {
//   final TextEditingController _arabicTextController = TextEditingController();
//   final TranslateLanguage _sourceLanguage = TranslateLanguage.arabic;
//   final TranslateLanguage _targetLanguage = TranslateLanguage.english;
//   late OnDeviceTranslator _translator;
//   String _translatedText = '';
//   bool _isTranslating = false;
//   bool _modelDownloaded = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeTranslator();
//   }

//   Future<void> _initializeTranslator() async {
//     final modelManager = OnDeviceTranslatorModelManager();

//     // Check if models are downloaded
//     final isArabicModelDownloaded =
//         await modelManager.isModelDownloaded(_sourceLanguage.bcpCode);
//     final isEnglishModelDownloaded =
//         await modelManager.isModelDownloaded(_targetLanguage.bcpCode);

//     // Download models if needed
//     if (!isArabicModelDownloaded) {
//       setState(() => _isTranslating = true);
//       await modelManager.downloadModel(_sourceLanguage.bcpCode);
//     }

//     if (!isEnglishModelDownloaded) {
//       setState(() => _isTranslating = true);
//       await modelManager.downloadModel(_targetLanguage.bcpCode);
//     }

//     _translator = OnDeviceTranslator(
//       sourceLanguage: _sourceLanguage,
//       targetLanguage: _targetLanguage,
//     );

//     setState(() {
//       _modelDownloaded = true;
//       _isTranslating = false;
//     });
//   }

//   Future<void> _translateText() async {
//     if (_arabicTextController.text.isEmpty) return;

//     setState(() {
//       _isTranslating = true;
//     });

//     try {
//       final translatedText =
//           await _translator.translateText(_arabicTextController.text);
//       setState(() {
//         _translatedText = translatedText;
//       });
//     } catch (e) {
//       setState(() {
//         _translatedText = 'Translation error: $e';
//       });
//     } finally {
//       setState(() {
//         _isTranslating = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _arabicTextController.dispose();
//     _translator.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Arabic to English Translator'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Source language section
//             Container(
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                     decoration: const BoxDecoration(
//                       color: Colors.grey,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(7),
//                         topRight: Radius.circular(7),
//                       ),
//                     ),
//                     child: const Text(
//                       'Arabic',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   TextField(
//                     controller: _arabicTextController,
//                     maxLines: 5,
//                     textDirection: TextDirection.rtl,
//                     decoration: const InputDecoration(
//                       hintText: 'أدخل النص بالعربية',
//                       hintTextDirection: TextDirection.rtl,
//                       contentPadding: EdgeInsets.all(10),
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 12),

//             // Translate button
//             ElevatedButton(
//               onPressed:
//                   _modelDownloaded && !_isTranslating ? _translateText : null,
//               child: _isTranslating
//                   ? Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         ),
//                         const SizedBox(width: 10),
//                         Text(_modelDownloaded
//                             ? 'Translating...'
//                             : 'Downloading models...'),
//                       ],
//                     )
//                   : const Text('Translate'),
//             ),

//             const SizedBox(height: 12),

//             // Target language section
//             Container(
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                     decoration: const BoxDecoration(
//                       color: Colors.grey,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(7),
//                         topRight: Radius.circular(7),
//                       ),
//                     ),
//                     child: const Text(
//                       'English',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(10),
//                     width: double.infinity,
//                     height: 120,
//                     child: _translatedText.isEmpty
//                         ? const Text('Translation will appear here',
//                             style: TextStyle(color: Colors.grey))
//                         : Text(_translatedText),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
