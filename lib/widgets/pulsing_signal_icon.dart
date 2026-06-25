import 'package:flutter/material.dart';
import 'package:food_delivery_app/utils/colors.dart';

class PulsingSignalIcon extends StatefulWidget {
  final double size;
  const PulsingSignalIcon({this.size = 90, super.key});

  @override
  State<PulsingSignalIcon> createState() => _PulsingSignalIconState();
}

class _PulsingSignalIconState extends State<PulsingSignalIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _ring(double phaseOffset) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final t = (_ctrl.value + phaseOffset) % 1.0;
        final scale = 1.0 + t * 1.8;
        final opacity = ((1.0 - t) * 0.6).clamp(0.0, 1.0);
        return Transform.scale(
          scale: scale,
          child: Container(
            width: widget.size * 0.62,
            height: widget.size * 0.62,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.mainColor.withValues(alpha: opacity),
                width: 1.8,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * 2.2,
      height: widget.size * 2.2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _ring(0.0),
          _ring(0.33),
          _ring(0.67),
          // Outer light circle
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: const Color(0xFFE6FAFA),
              shape: BoxShape.circle,
            ),
          ),
          // Inner darker circle
          Container(
            width: widget.size * 0.62,
            height: widget.size * 0.62,
            decoration: BoxDecoration(
              color: const Color(0xFFB2F0F0),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline,
              color: AppColors.mainColor,
              size: widget.size * 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
