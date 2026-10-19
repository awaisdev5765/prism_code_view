# prism_code_view

A **syntax-highlighted code viewer widget for Flutter** — the companion to
[`prism_markdown`](https://pub.dev/packages/prism_markdown). Built-in Dart,
JSON, and YAML tokenizers, copy-to-clipboard button, line numbers, and word
wrap. Pure Flutter — no platform channels, works on all six platforms.

## Features

- ✅ Built-in **Dart**, **JSON**, and **YAML** syntax highlighting
- ✅ Pluggable `LanguageTokenizer` — bring your own language
- ✅ Copy-to-clipboard button (one flag to disable)
- ✅ Line numbers gutter
- ✅ Word-wrap toggle
- ✅ Adaptive light/dark color palettes
- ✅ Max-height scrolling for long code
- ✅ Pure Flutter: Android, iOS, macOS, Windows, Linux, Web

## Installation

```yaml
dependencies:
  prism_code_view: ^0.1.0
```

## Usage

### Basic

```dart
import 'package:prism_code_view/prism_code_view.dart';

PrismCodeView(
  code: 'void main() => print("Hello, world!");',
  language: PrismLanguage.dart,
)
```

### Line numbers + wrap + max height

```dart
PrismCodeView(
  code: longSourceCode,
  language: PrismLanguage.dart,
  showLineNumbers: true,
  wrap: false,
  maxHeight: 400,
)
```

### Custom tokenizer

Implement `LanguageTokenizer` to support any language:

```dart
class GoTokenizer extends LanguageTokenizer {
  @override
  List<CodeToken> tokenize(String code) {
    // Your tokenizing logic here.
    return [CodeToken(code, TokenKind.plain)];
  }
}

PrismCodeView(
  code: goSource,
  tokenizer: GoTokenizer(),
)
```

### Custom style

```dart
PrismCodeView(
  code: code,
  style: const PrismCodeViewStyle(
    background: Color(0xFF1E1E2E),
    textStyle: TextStyle(fontFamily: 'JetBrains Mono'),
  ),
)
```

## Use with prism_markdown

Pair it with the markdown renderer's `highlighter` callback:

```dart
PrismMarkdown(
  markdownSource,
  highlighter: (code, language) {
    final lang = switch (language) {
      'dart' => PrismLanguage.dart,
      'json' => PrismLanguage.json,
      'yaml' => PrismLanguage.yaml,
      _ => PrismLanguage.other,
    };
    final tokens = lang.tokenizer?.tokenize(code);
    return TextSpan(
      children: [
        for (final t in tokens ?? <CodeToken>[])
          TextSpan(text: t.text, style: /* map TokenKind → TextStyle */),
      ],
    );
  },
)
```

## License

MIT — see [LICENSE](LICENSE).
