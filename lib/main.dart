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
  Widget build(BuildContext context) {
    return Scaffold(
      body: localUrl == null
          ? const Center(child: CircularProgressIndicator())
          : InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(localUrl!)),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                allowFileAccessFromFileURLs: true,
                allowUniversalAccessFromFileURLs: true,
                mediaPlaybackRequiresUserGesture: false,
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
}
