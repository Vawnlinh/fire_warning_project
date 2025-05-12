import 'package:flutter/material.dart';
// ignore: unused_import
import '../screens/alert_page.dart';

class RadarAlert extends StatefulWidget {
  const RadarAlert({super.key});

  @override
  State<RadarAlert> createState() => _RadarAlertState();
}

class _RadarAlertState extends State<RadarAlert>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rippleAnimation;

  bool isDanger = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _rippleAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildRadar(double size, double opacity) {
    double easedOpacity = Curves.easeOut.transform(opacity);
    int alpha = (easedOpacity * 255).toInt().clamp(0, 255);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red.withAlpha(alpha),
      ),
    );
  }

  Widget buildDangerInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        const Text(
          '🔥 Cảnh báo nguy hiểm!',
          style: TextStyle(color: Colors.red, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          '🕒 Thời gian: 12:45 - 12/05/2025',
          style: TextStyle(color: Colors.black),
        ),
        const Text(
          '📍 Vị trí: Tầng 3 - Khu A',
          style: TextStyle(color: Colors.black),
        ),
        const Text(
          '⚠️ Mức độ: Nguy hiểm cao',
          style: TextStyle(color: Colors.black),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 40),

            // VÙNG RADAR CỐ ĐỊNH
            SizedBox(
              height: 300,
              child: Center(
                child: isDanger
                    ? AnimatedBuilder(
                        animation: _rippleAnimation,
                        builder: (context, _) {
                          double progress = _rippleAnimation.value;
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              buildRadar(350 * progress, 1 - progress),
                              buildRadar(250 * progress, 0.7 - progress * 0.7),
                              Container(
                                width: 150,
                                height: 150,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: const Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                          size: 80,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Không phát hiện nguy hiểm',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '🕒 Thời gian kiểm tra: 12:45 - 12/05/2025',
                          style: TextStyle(color: Colors.black54),
                        ),
                        Text(
                          '📍 Vị trí: Tầng 3 - Khu A',
                          style: TextStyle(color: Colors.black54),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Hệ thống đang giám sát bình thường.',
                          style: TextStyle(color: Colors.black87, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
              ),
            ),

            const SizedBox(height: 30),
            if (isDanger) buildDangerInfo(),
            const SizedBox(height: 30),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDanger ? Colors.red : Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                setState(() {
                  isDanger = !isDanger;
                });
              },
              icon: Icon(isDanger ? Icons.cancel : Icons.warning),
              label: Text(isDanger ? 'Tắt cảnh báo' : 'Giả lập cảnh báo'),
            ),
          ],
        ),
      ),
    );
  }
}