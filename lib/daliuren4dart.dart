import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

Future<String> _enginePath(String? explicitPath) async {
  if (explicitPath != null) return explicitPath;
  final uri = await Isolate.resolvePackageUri(
    Uri.parse('package:daliuren4dart/engine.cjs'),
  );
  if (uri == null || uri.scheme != 'file') {
    throw StateError('Unable to locate the bundled daliuren engine');
  }
  return uri.toFilePath();
}

Future<Map<String, dynamic>> _run(
  Map<String, dynamic> input,
  String? enginePath,
) async {
  final process = await Process.start('node', [await _enginePath(enginePath)]);
  process.stdin.write(jsonEncode(input));
  await process.stdin.close();
  final stdout = await utf8.decoder.bind(process.stdout).join();
  final stderr = await utf8.decoder.bind(process.stderr).join();
  final code = await process.exitCode;
  final envelope = jsonDecode(stdout) as Map<String, dynamic>;
  if (code != 0 || envelope['ok'] != true) {
    throw StateError((envelope['error'] ?? stderr).toString());
  }
  return envelope;
}

Future<Map<String, dynamic>> calculateDaliuren(
  Map<String, dynamic> input, {
  String? enginePath,
}) async =>
    (await _run(input, enginePath))['data'] as Map<String, dynamic>;

Future<Map<String, dynamic>> canonicalDaliuren(
  Map<String, dynamic> input, {
  String? enginePath,
}) async =>
    (await _run(input, enginePath))['canonical'] as Map<String, dynamic>;
