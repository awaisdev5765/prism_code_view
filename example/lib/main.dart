import 'package:flutter/material.dart';
import 'package:prism_code_view/prism_code_view.dart';

void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'prism_code_view demo',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    const dartCode = '''
import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Text('Hello, prism_code_view!'));
  }
}
''';
    const jsonCode = '''
{
  "name": "prism_code_view",
  "version": "0.1.0",
  "topics": ["code", "syntax-highlighting", "widget"],
  "deprecated": false
}
''';

    return Scaffold(
      appBar: AppBar(title: const Text('prism_code_view demo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Dart with line numbers'),
          const SizedBox(height: 8),
          const PrismCodeView(
            code: dartCode,
            language: PrismLanguage.dart,
            showLineNumbers: true,
          ),
          const SizedBox(height: 24),
          const Text('JSON with word wrap'),
          const SizedBox(height: 8),
          const PrismCodeView(
            code: jsonCode,
            language: PrismLanguage.json,
            wrap: true,
          ),
        ],
      ),
    );
  }
}
