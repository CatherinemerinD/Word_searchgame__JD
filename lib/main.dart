/*import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WebViewScreen(),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  InAppWebViewController? webViewController;
  String? localUrl;

  @override
  void initState() {
    super.initState();
    prepareLocalHtml();
  }

  Future<void> prepareLocalHtml() async {
    try {
      final tempDir = await getApplicationDocumentsDirectory();
      final folderPath = '${tempDir.path}/www';
      await Directory(folderPath).create(recursive: true);

      await _copyAssetToFile('assets/www/index.html', '$folderPath/index.html');
      await _copyAssetFolder('assets/www/css', '$folderPath/css');
      await _copyAssetFolder('assets/www/js', '$folderPath/js');
      await _copyAssetFolder('assets/www/sounds', '$folderPath/sounds');
      await _copyAssetFolder('assets/www/sprites', '$folderPath/sprites');
      await _copyAssetToFile(
        'assets/www/favicon.ico',
        '$folderPath/favicon.ico',
      );
      setState(() {
        localUrl = 'file://$folderPath/index.html';
      });
    } catch (e) {
      debugPrint('Error copying files: $e');
    }
  }

  Future<void> _copyAssetToFile(String assetPath, String filePath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final buffer = data.buffer;
    await File(filePath).writeAsBytes(
      buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      flush: true,
    );
  }

  Future<void> _copyAssetFolder(String assetFolder, String targetFolder) async {
    final manifestJson = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifest = json.decode(manifestJson);
    final files = manifest.keys
        .where((path) => path.startsWith(assetFolder))
        .toList();

    for (final assetPath in files) {
      final relativePath = assetPath.replaceFirst(assetFolder, '');
      final filePath = '$targetFolder$relativePath';
      await Directory(File(filePath).parent.path).create(recursive: true);
      await _copyAssetToFile(assetPath, filePath);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (webViewController != null && localUrl != null) {
      webViewController!.loadUrl(
        urlRequest: URLRequest(url: WebUri(localUrl!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: localUrl == null
        ? const Center(child: CircularProgressIndicator())
        : InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(localUrl!)),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              allowFileAccessFromFileURLs: true,
              allowUniversalAccessFromFileURLs: true,
              mediaPlaybackRequiresUserGesture: false,
              domStorageEnabled: true, // required by many HTML5 games
              databaseEnabled: true, // some JS libs use WebSQL/IndexedDB
              mixedContentMode: MixedContentMode
                  .MIXED_CONTENT_ALWAYS_ALLOW, //fixes http/https mismatch
              cacheEnabled: true,
            ),
            onWebViewCreated: (controller) {
              webViewController = controller;

              controller.addJavaScriptHandler(
                handlerName: 'scoreUpdate',
                callback: (args) {
                  final data = args.first;
                  final score = data['score'];
                  final level = data['level'];

                  debugPrint('Game Score: $score | Level: $level');

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Game Over'),
                      content: Text('Level $level\nYour Score: $score'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
  );
}*/

import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WebViewScreen(),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  InAppWebViewController? webViewController;
  String? localUrl;

  @override
  void initState() {
    super.initState();
    prepareLocalHtml();
  }

  Future<void> prepareLocalHtml() async {
    try {
      final tempDir = await getApplicationDocumentsDirectory();
      final folderPath = '${tempDir.path}/www';
      await Directory(folderPath).create(recursive: true);

      debugPrint("Preparing local HTML in: $folderPath");

      await _copyAssetToFile('assets/www/index.html', '$folderPath/index.html');
      await _copyAssetFolder('assets/www/css', '$folderPath/css');
      await _copyAssetFolder('assets/www/js', '$folderPath/js');
      await _copyAssetFolder('assets/www/sounds', '$folderPath/sounds');
      await _copyAssetFolder('assets/www/sprites', '$folderPath/sprites');
      await _copyAssetToFile(
        'assets/www/favicon.ico',
        '$folderPath/favicon.ico',
      );

      setState(() {
        localUrl = 'file://$folderPath/index.html';
      });

      debugPrint("Local URL set: $localUrl");
    } catch (e) {
      debugPrint('Error copying files: $e');
    }
  }

  Future<void> _copyAssetToFile(String assetPath, String filePath) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      final buffer = data.buffer;
      await File(filePath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        flush: true,
      );
      debugPrint("Copied asset file: $assetPath -> $filePath");
    } catch (e) {
      debugPrint("FAILED to copy $assetPath -> $filePath | Error: $e");
    }
  }

  Future<void> _copyAssetFolder(String assetFolder, String targetFolder) async {
    final manifestJson = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifest = json.decode(manifestJson);
    final files = manifest.keys
        .where((path) => path.startsWith(assetFolder))
        .toList();

    if (files.isEmpty) {
      debugPrint(
        "WARNING: No files found for $assetFolder in AssetManifest.json",
      );
    }

    for (final assetPath in files) {
      final relativePath = assetPath.replaceFirst(assetFolder, '');
      final filePath = '$targetFolder$relativePath';
      await Directory(File(filePath).parent.path).create(recursive: true);
      await _copyAssetToFile(assetPath, filePath);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (webViewController != null && localUrl != null) {
      webViewController!.loadUrl(
        urlRequest: URLRequest(url: WebUri(localUrl!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: localUrl == null
        ? const Center(child: CircularProgressIndicator())
        : InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(localUrl!)),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              allowFileAccessFromFileURLs: true,
              allowUniversalAccessFromFileURLs: true,
              mediaPlaybackRequiresUserGesture: false,
              domStorageEnabled: true,
              databaseEnabled: true,
              mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
              cacheEnabled: true,
            ),
            onWebViewCreated: (controller) {
              webViewController = controller;

              controller.addJavaScriptHandler(
                handlerName: 'scoreUpdate',
                callback: (args) {
                  final data = args.first;
                  final score = data['score'];
                  final level = data['level'];

                  debugPrint('Game Score: $score | Level: $level');

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Game Over'),
                      content: Text('Level $level\nYour Score: $score'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
  );
}
