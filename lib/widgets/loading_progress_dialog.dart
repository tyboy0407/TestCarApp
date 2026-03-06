import 'package:flutter/material.dart';

class LoadingProgressDialog extends StatefulWidget {
  final Future<void> Function() onLoading;
  final VoidCallback onFinished;

  const LoadingProgressDialog({
    super.key,
    required this.onLoading,
    required this.onFinished,
  });

  @override
  State<LoadingProgressDialog> createState() => _LoadingProgressDialogState();
}

class _LoadingProgressDialogState extends State<LoadingProgressDialog> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  double _progress = 0.0;
  String _statusText = "引擎發動中...";

  @override
  void initState() {
    super.initState();
    
    // 初始化動畫控制器，用來模擬車輛引擎震動
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..repeat(reverse: true); // 讓它來回快速跳動

    _startLoading();
  }

  Future<void> _startLoading() async {
    final loadingTask = widget.onLoading();

    const phases = [
      {"p": 0.2, "t": "正在檢查車輛狀態..."},
      {"p": 0.4, "t": "正在下載最新配備資料..."},
      {"p": 0.7, "t": "正在計算台灣稅金配置..."},
      {"p": 0.9, "t": "正在整合本地快取..."},
      {"p": 1.0, "t": "即將抵達目的地！"},
    ];

    for (var phase in phases) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 600));
      setState(() {
        _progress = phase["p"] as double;
        _statusText = phase["t"] as String;
      });
    }

    await loadingTask;

    if (mounted) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        Navigator.of(context).pop();
        widget.onFinished();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 動態車輛圖示
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  // 根據動畫值產生微小的上下位移，模擬引擎震動
                  offset: Offset(0, _animationController.value * 2),
                  child: const Icon(
                    Icons.directions_car_filled_rounded,
                    size: 60,
                    color: Colors.black,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "資料加載中",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.0),
            ),
            const SizedBox(height: 16),
            // 進度條
            Stack(
              children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  height: 10,
                  width: (MediaQuery.of(context).size.width - 120) * _progress,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF9A8B), Color(0xFFFF6A88)],
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _statusText,
              style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              "${(_progress * 100).toInt()}%",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
