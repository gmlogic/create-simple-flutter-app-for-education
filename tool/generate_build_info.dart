import 'dart:io';

void main() {
  final now = DateTime.now().toIso8601String();

  final content = '''
class BuildInfo {
  static const String buildDate = "$now";
}
''';

  final file = File('lib/build_info.dart');
  file.writeAsStringSync(content);

  // ignore: avoid_print
  print("Build info generated: $now");
}
