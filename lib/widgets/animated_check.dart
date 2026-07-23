import 'package:flutter/material.dart';

/// An animated checkmark that draws itself when [isChecked] becomes true.
///
/// Plays a satisfying draw-in animation using [CustomPainter] + [AnimationController].
class AnimatedCheck extends StatefulWidget {

  const AnimatedCheck({
    super.key,
    required this.isChecked,
    required this.color,
    this.size = 32,
  });
  /// Whether to show the check (triggers animation).
  final bool isChecked;

  /// Color of the checkmark stroke.
  final Color color;

  /// Overall size of the widget.
  final double size;

  @override
  State<AnimatedCheck> createState() => _AnimatedCheckState();
}

class _AnimatedCheckState extends State<AnimatedCheck>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _progress = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    if (widget.isChecked) _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCheck oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isChecked && !oldWidget.isChecked) {
      _controller.forward(from: 0);
    } else if (!widget.isChecked && oldWidget.isChecked) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _progress,
        builder: (context, _) {
          return CustomPaint(
            painter: _CheckPainter(
              progress: _progress.value,
              color: widget.color,
              strokeWidth: widget.size * 0.1,
            ),
          );
        },
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {

  _CheckPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });
  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // Checkmark path: down-left segment then up-right segment
    // Defined as a fraction of the widget size
    final p1 = Offset(size.width * 0.18, size.height * 0.52);
    final p2 = Offset(size.width * 0.42, size.height * 0.74);
    final p3 = Offset(size.width * 0.82, size.height * 0.26);

    // Total path length (approximate)
    final seg1Len = (p2 - p1).distance;
    final seg2Len = (p3 - p2).distance;
    final totalLen = seg1Len + seg2Len;

    final drawn = progress * totalLen;

    final path = Path();
    if (drawn <= seg1Len) {
      // Still drawing first segment
      final t = drawn / seg1Len;
      path.moveTo(p1.dx, p1.dy);
      path.lineTo(
        p1.dx + (p2.dx - p1.dx) * t,
        p1.dy + (p2.dy - p1.dy) * t,
      );
    } else {
      // First segment complete, drawing second
      final t = (drawn - seg1Len) / seg2Len;
      path.moveTo(p1.dx, p1.dy);
      path.lineTo(p2.dx, p2.dy);
      path.lineTo(
        p2.dx + (p3.dx - p2.dx) * t,
        p2.dy + (p3.dy - p2.dy) * t,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CheckPainter old) =>
      old.progress != progress || old.color != color;
}
