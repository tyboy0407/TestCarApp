import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A card that flips 180 degrees on tap to reveal the back side.
class KnowledgeFlipCard extends StatefulWidget {
  final Widget front;
  final Widget back;
  final Duration duration;

  const KnowledgeFlipCard({
    super.key,
    required this.front,
    required this.back,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<KnowledgeFlipCard> createState() => _KnowledgeFlipCardState();
}

class _KnowledgeFlipCardState extends State<KnowledgeFlipCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _frontRotation;
  late Animation<double> _backRotation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _frontRotation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -math.pi / 2), weight: 50),
      TweenSequenceItem(tween: ConstantTween(-math.pi / 2), weight: 50),
    ]).animate(_controller);

    _backRotation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(math.pi / 2), weight: 50),
      TweenSequenceItem(tween: Tween(begin: math.pi / 2, end: 0.0), weight: 50),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _isFront = !_isFront;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCard,
      child: Stack(
        children: [
          // Front Side
          AnimatedBuilder(
            animation: _frontRotation,
            builder: (context, child) {
              final angle = _frontRotation.value;
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(angle),
                alignment: Alignment.center,
                child: angle < -math.pi / 2.01 ? const SizedBox.shrink() : widget.front,
              );
            },
          ),
          // Back Side
          AnimatedBuilder(
            animation: _backRotation,
            builder: (context, child) {
              final angle = _backRotation.value;
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(angle),
                alignment: Alignment.center,
                child: angle > math.pi / 2.01 ? const SizedBox.shrink() : widget.back,
              );
            },
          ),
        ],
      ),
    );
  }
}

/// A simple data model for the bar chart
class BarChartItem {
  final String label;
  final double value;
  final String displayValue;
  final Color color;

  BarChartItem({
    required this.label,
    required this.value,
    required this.displayValue,
    required this.color,
  });
}

/// An interactive bar chart where bars animate in when the widget builds.
/// Supports switching between different datasets.
class InteractiveBarChart extends StatefulWidget {
  final String title;
  final List<BarChartItem> items;
  final double maxValue;
  final String unit;

  const InteractiveBarChart({
    super.key,
    required this.title,
    required this.items,
    required this.maxValue,
    this.unit = '',
  });

  @override
  State<InteractiveBarChart> createState() => _InteractiveBarChartState();
}

class _InteractiveBarChartState extends State<InteractiveBarChart> {
  // Use a key to force rebuild when title/items change if needed, 
  // or rely on didUpdateWidget to trigger animations.
  // For simplicity, we'll use a local state to trigger animation.
  bool _animate = false;

  @override
  void initState() {
    super.initState();
    // Trigger animation after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _animate = true);
    });
  }

  @override
  void didUpdateWidget(covariant InteractiveBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.title != widget.title) {
      _animate = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _animate = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      surfaceTintColor: Colors.white,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(widget.unit, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
            const SizedBox(height: 16),
            ...widget.items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        Text(item.displayValue, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final maxBarWidth = constraints.maxWidth;
                        final barWidth = (item.value / widget.maxValue) * maxBarWidth;
                        
                        return Stack(
                          children: [
                            // Background track
                            Container(
                              height: 10,
                              width: maxBarWidth,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            // Animated Bar
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeOutQuart,
                              height: 10,
                              width: _animate ? barWidth : 0,
                              decoration: BoxDecoration(
                                color: item.color,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
