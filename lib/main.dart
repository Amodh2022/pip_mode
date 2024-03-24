import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  late MethodChannel _channel;
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  FlickManager? flickManager;
  Future<void> enterPIPMode() async {
    try {
      await _channel.invokeMethod('enterPip');
    } on PlatformException catch (e) {
      print("Failed to enter PIP mode: '${e.message}'.");
    }
  }

  void initializeMethodChannel() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'seekCode':
          seekCode();
          break;
        default:
          throw PlatformException(
            code: 'Unimplemented',
            message: 'Method ${call.method} not implemented',
          );
      }
    });
  }

  seekCode() {
    print("Its Printing");
    flickManager!.flickControlManager!.seekForward(const Duration(seconds: 10));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _channel = const MethodChannel('enterChannelPip');
    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(
      Uri.parse(
          "https://storage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4"),
    ));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.inactive) {
      await enterPIPMode();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: 200,
          child: Center(
            child: FlickVideoPlayer(
              flickManager: flickManager!,
            ),
          ),
        ),
      ),
    );
  }
}
