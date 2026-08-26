import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: _RotatingCircleIndicator(),
      ),
    );
  }
}

class _RotatingCircleIndicator extends StatefulWidget {
  const _RotatingCircleIndicator();

  @override
  __RotatingCircleIndicatorState createState() => __RotatingCircleIndicatorState();
}

class __RotatingCircleIndicatorState extends State<_RotatingCircleIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      alignment: Alignment.center,
      turns: _animationController,
      child: CustomPaint(
        size: const Size(50, 50),
        painter: _CirclePainter(),
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..color = const Color.fromARGB(255, 0, 0, 255);

    final double radius = size.width / 2 - paint.strokeWidth;
    const double startAngle = 0.0;
    const double sweepAngle = 2 * 3.14159265359 * 0.75;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_CirclePainter oldDelegate) => false;
}
