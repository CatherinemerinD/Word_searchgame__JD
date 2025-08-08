// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final wwwDir = Directory("${dir.path}/www");
  if (!wwwDir.existsSync()) {
    wwwDir.createSync(recursive: true);

    // Copy each folder/file from assets manually
    await _copyAssetFolder('www/assets', wwwDir.path);
    await _copyAssetFolder('www/css', wwwDir.path);
    await _copyAssetFolder('www/js', wwwDir.path);
    await _copyAssetFolder('www', wwwDir.path); // main html/js/css
  }

  runApp(const MyApp());
}

Future<void> _copyAssetFolder(String assetPath, String targetPath) async {
  final manifestContent = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = {};
  manifestMap.addAll(
    Map<String, dynamic>.from(manifestContent.isNotEmpty ? {} : {}),
  ); // just placeholder map
  // This approach is simplified — assuming manual list in pubspec.yaml
  // If needed, copy per known files

  final fileData = await rootBundle.load(assetPath);
  final file = File("$targetPath/${assetPath.split('/').last}");
  await file.writeAsBytes(fileData.buffer.asUint8List());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WebViewScreen(),
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
    _prepareLocalUrl();
  }

  Future<void> _prepareLocalUrl() async {
    final dir = await getApplicationDocumentsDirectory();
    final indexPath = "${dir.path}/www/index.html";
    final file = File(indexPath);
    if (file.existsSync()) {
      localUrl = Uri.file(indexPath).toString();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (localUrl == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(localUrl!)),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            javaScriptEnabled: true,
            allowFileAccessFromFileURLs: true,
            allowUniversalAccessFromFileURLs: true,
            useShouldOverrideUrlLoading: false,
          ),
          android: AndroidInAppWebViewOptions(
            useHybridComposition: true,
            allowFileAccess: true,
          ),
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;

          controller.addJavaScriptHandler(
            handlerName: 'scoreUpdate',
            callback: (args) {
              final data = args.isNotEmpty ? args.first : null;
              if (data != null && data is Map) {
                try {
                  final score = data['score'];
                  final level = data['level'];
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Game Over'),
                      content: Text('Level $level\nScore: $score'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  debugPrint('scoreUpdate handler error: $e');
                }
              }
              return null;
            },
          );
        },
        onConsoleMessage: (controller, consoleMessage) {
          debugPrint('WebView console: ${consoleMessage.message}');
        },
      ),
    );
  }
}
