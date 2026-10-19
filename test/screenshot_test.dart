import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' show ImageByteFormat;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';
import 'package:prism_code_view/prism_code_view.dart';

/// Screenshot generator — renders the showcase into `doc/screenshot.png`.
/// Run with: `SCREENSHOTS=1 flutter test test/screenshot_test.dart`
void main() {
  const key = ValueKey('screenshot');

  Future<void> loadFonts() async {
    // Fonts live in prism_markdown's repo; fall back to the sibling path so
    // each package doesn't need its own font copy. (Repo-only: pub-ignored.)
    var dir = Directory('test/fonts');
    if (!dir.existsSync()) {
      dir = Directory('../prism_markdown/test/fonts');
    }
    if (!dir.existsSync()) return;
    final families = <String, List<Uint8List>>{};
    for (final file in dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.ttf'))) {
      final name = file.uri.pathSegments.last.replaceAll('.ttf', '');
      final family = name.startsWith('RobotoMono')
          ? 'monospace'
          : name.substring(0, name.indexOf('-'));
      (families[family] ??= []).add(file.readAsBytesSync());
    }
    for (final entry in families.entries) {
      final loader = FontLoader(entry.key);
      for (final bytes in entry.value) {
        loader.addFont(Future.value(bytes.buffer.asByteData()));
      }
      await loader.load();
    }
    final flutterRoot = File(Platform.resolvedExecutable)
        .parent
        .parent
        .parent
        .parent
        .parent
        .path;
    final iconFont = File(
      '$flutterRoot/bin/cache/artifacts/material_fonts/'
      'MaterialIcons-Regular.otf',
    );
    if (iconFont.existsSync()) {
      final loader = FontLoader('MaterialIcons')
        ..addFont(
          Future.value(iconFont.readAsBytesSync().buffer.asByteData()),
        );
      await loader.load();
    }
  }

  const dartCode = '''
import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Syntax highlighting, built in.
    return const MaterialApp(home: Text('Hello, Prism!'));
  }
}
''';

  const jsonCode = '''
{
  "name": "prism_code_view",
  "version": "0.1.0",
  "topics": ["code", "syntax-highlighting", "widget"],
  "maintained": true
}
''';

  testWidgets(
    'capture showcase screenshot',
    (tester) async {
      await loadFonts();
      tester.view.physicalSize = const Size(900, 1000);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Roboto',
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0B57D0),
            ),
          ),
          home: RepaintBoundary(
            key: key,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text('prism_code_view'),
              ),
              body: ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  Text(
                    'Dart — with line numbers',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  PrismCodeView(
                    code: dartCode,
                    language: PrismLanguage.dart,
                    showLineNumbers: true,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'JSON — with word wrap',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  PrismCodeView(
                    code: jsonCode,
                    language: PrismLanguage.json,
                    wrap: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.runAsync(() async {
        final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(key),
        );
        final image = await boundary.toImage(pixelRatio: 2.0);
        final byteData =
            await image.toByteData(format: ImageByteFormat.png);
        final file = File('doc/screenshot.png');
        await file.create(recursive: true);
        await file.writeAsBytes(byteData!.buffer.asUint8List());
      });
    },
    skip: !Platform.environment.containsKey('SCREENSHOTS'),
  );
}
