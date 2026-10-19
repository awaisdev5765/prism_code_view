/// A syntax-highlighted code viewer widget for Flutter.
///
/// The maintained companion to [prism_markdown](https://pub.dev/packages/prism_markdown).
library;

export 'src/code_view.dart' show PrismCodeView, PrismLanguage;
export 'src/style.dart' show PrismCodeViewStyle;
export 'src/tokenizer.dart'
    show CodeToken, LanguageTokenizer, TokenKind, DartTokenizer, JsonTokenizer,
    YamlTokenizer;
