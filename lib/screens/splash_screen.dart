import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  VideoPlayerController? _controller;
  bool _isNavigated = false;
  bool _hasError = false;
  String _errorMessage = "";
  Timer? _timeoutTimer;
  
  final String videoPath = 'assets/videos/login_animation.mp4';

  @override
  void initState() {
    super.initState();
    _timeoutTimer = Timer(const Duration(seconds: 10), () {
      if (!_isNavigated) {
        debugPrint("影片載入超時，強制跳轉");
        _handleNavigation();
      }
    });
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      final controller = VideoPlayerController.asset(videoPath);
      _controller = controller;
      
      controller.addListener(_videoListener);
      await controller.initialize();
      
      if (kIsWeb) {
        await controller.setVolume(0.0);
      } else {
        await controller.setVolume(1.0);
      }
      
      if (mounted) {
        setState(() {});
        try {
          await controller.play();
        } catch (e) {
          debugPrint("自動播放被攔截: $e");
        }
      }
    } catch (e) {
      debugPrint("影片播放器發生錯誤: $e");
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = e.toString();
        });
      }
      Future.delayed(const Duration(seconds: 1), _handleNavigation);
    }
  }

  void _videoListener() {
    final controller = _controller;
    if (controller == null || !mounted) return;
    
    if (controller.value.position >= controller.value.duration && 
        controller.value.isInitialized && 
        !_isNavigated) {
      _handleNavigation();
    }
  }

  void _handleNavigation() {
    if (_isNavigated || !mounted) return;
    _isNavigated = true;
    
    _timeoutTimer?.cancel();
    _controller?.pause();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    Widget nextScreen = authProvider.isLoggedIn ? const HomeScreen() : const LoginScreen();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final isInitialized = controller?.value.isInitialized ?? false;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          if (isInitialized && controller != null && !controller.value.isPlaying) {
            controller.play();
            setState(() {});
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 修改處：使用 FittedBox 來達成全螢幕填滿效果
            if (isInitialized && controller != null)
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover, // 關鍵設定：填滿並適度裁切
                  child: SizedBox(
                    width: controller.value.size.width,
                    height: controller.value.size.height,
                    child: VideoPlayer(controller),
                  ),
                ),
              )
            else if (_hasError)
              const Center(child: Icon(Icons.error, color: Colors.white))
            else
              const Center(child: CircularProgressIndicator(color: Colors.white)),
            
            // 提示點擊 (Web 特定)
            if (kIsWeb && isInitialized && controller != null && !controller.value.isPlaying && !_hasError)
              const Center(
                child: Text(
                  "點擊畫面開始動畫",
                  style: TextStyle(color: Colors.white54, fontSize: 16),
                ),
              ),

            // 跳過按鈕
            if (isInitialized)
              Positioned(
                bottom: 40,
                right: 20,
                child: TextButton(
                  onPressed: _handleNavigation,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black38,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('跳過動畫'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
