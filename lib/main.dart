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

      await _copyAssetToFile('assets/www/css', '$folderPath/css');
      await _copyAssetToFile('assets/www/js', '$folderPath/js');

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
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable remote debugging if you connect via adb (optional)
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
  final InAppLocalhostServer _server = InAppLocalhostServer(
    documentRoot: 'assets',
    port: 8080,
  );
  InAppWebViewController? _controller;

  final _startUrl = WebUri(
    'http://localhost:8080/www/index.html',
  ); // maps to assets/www/...

  bool _starting = true;

  @override
  void initState() {
    super.initState();
    _startServerAndLoad();
  }

  Future<void> _startServerAndLoad() async {
    try {
      // Start the embedded localhost web server that serves from /assets
      await _server.start();
    } catch (_) {
      // If it was already running, ignore
    }
    setState(() => _starting = false);
  }

  @override
  void dispose() {
    _server.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_starting) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return WillPopScope(
      onWillPop: () async {
        // If the game gets stuck or user presses back: try to go back; if not, hard reload.
        if (_controller != null) {
          final canGoBack = await _controller!.canGoBack();
          if (canGoBack) {
            await _controller!.goBack();
          } else {
            await _controller!.reload();
          }
        }
        return false;
      },
      child: Scaffold(
        body: InAppWebView(
          initialUrlRequest: URLRequest(url: _startUrl),
          // If localhost fails for any reason, fall back to file:// asset path.
          onReceivedError: (c, r, e) async {
            await c.loadUrl(
              urlRequest: URLRequest(
                url: WebUri(
                  'file:///android_asset/flutter_assets/assets/www/index.html',
                ),
              ),
            );
          },
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            allowFileAccessFromFileURLs: true,
            allowUniversalAccessFromFileURLs: true,
            mediaPlaybackRequiresUserGesture: false,
            domStorageEnabled: true,
            databaseEnabled: true,
            cacheEnabled: true,
            mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
            useHybridComposition: true, // better stability on modern Android
          ),
          onWebViewCreated: (controller) => _controller = controller,
          onConsoleMessage: (controller, msg) {
            // See JS errors in `flutter logs`
            debugPrint(
              '[WEBVIEW] ${msg.messageLevel.toString()}: ${msg.message}',
            );
          },
          onLoadStop: (controller, url) async {
            // Defensive patch: if the game's JS throws on `*.unload()` being null
            // after exiting to the menu, immediately hard-reload the page so the app
            // never freezes on "screen 3".
            await controller.evaluateJavascript(
              source: r'''
              (function() {
                try {
                  // Howler audio unlock on mobile (if present)
                  if (window.Howler) { Howler.autoUnlock = true; }

                  // Global error handler to catch the "unload of null" crash
                  if (!window.__reloadOnUnloadCrash) {
                    window.__reloadOnUnloadCrash = true;
                    window.onerror = function(msg, src, line, col, err) {
                      try {
                        var m = (msg && msg.toString()) || '';
                        if (m.indexOf('unload') !== -1 || m.indexOf('Cannot read') !== -1) {
                          // Give WebView a tick, then hard reload
                          setTimeout(function(){ location.reload(); }, 50);
                          return true; // handled
                        }
                      } catch(_){}
                      return false;
                    };
                  }

                  // Also expose a manual panic-reload if you want to call from the game:
                  window.__flutterReload = function(){ location.reload(); };
                } catch (e) {}
              })();
            ''',
            );
          },
        ),
      ),
    );
  }
}
