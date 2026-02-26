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
  bool _animate = false;

  @override
  void initState() {
    super.initState();
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
                            Container(
                              height: 10,
                              width: maxBarWidth,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
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

/// Data model for quadrant chart items
class QuadrantItem {
  final String label;
  final double x; // -1.0 to 1.0
  final double y; // -1.0 to 1.0
  final Color color;

  QuadrantItem({
    required this.label,
    required this.x,
    required this.y,
    required this.color,
  });
}

/// A specialized quadrant chart for car evaluation
class QuadrantChart extends StatelessWidget {
  final String title;
  final String xAxisLabel;
  final String yAxisLabel;
  final String xLeftLabel;
  final String xRightLabel;
  final String yBottomLabel;
  final String yTopLabel;
  final List<QuadrantItem> items;
  final List<String> quadrantLabels; // [TR, TL, BL, BR]

  const QuadrantChart({
    super.key,
    required this.title,
    required this.xAxisLabel,
    required this.yAxisLabel,
    required this.xLeftLabel,
    required this.xRightLabel,
    required this.yBottomLabel,
    required this.yTopLabel,
    required this.items,
    this.quadrantLabels = const ['', '', '', ''],
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  // Axis Labels
                  Positioned(top: 0, left: 0, right: 0, child: Center(child: _buildAxisLabel(yTopLabel, true))),
                  Positioned(bottom: 0, left: 0, right: 0, child: Center(child: _buildAxisLabel(yBottomLabel, true))),
                  Positioned(left: 0, top: 0, bottom: 0, child: Center(child: RotatedBox(quarterTurns: 3, child: _buildAxisLabel(xLeftLabel, true)))),
                  Positioned(right: 0, top: 0, bottom: 0, child: Center(child: RotatedBox(quarterTurns: 1, child: _buildAxisLabel(xRightLabel, true)))),
                  
                  // The Grid
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        color: Colors.grey.shade50,
                      ),
                      child: Stack(
                        children: [
                          // Cross lines
                          const Center(child: Divider(color: Colors.grey, thickness: 1)),
                          const Center(child: VerticalDivider(color: Colors.grey, thickness: 1)),
                          
                          // Quadrant Labels
                          if (quadrantLabels.length >= 4) ...[
                             Positioned(top: 10, right: 10, child: _buildQuadrantTag(quadrantLabels[0], Colors.orange.shade100)),
                             Positioned(top: 10, left: 10, child: _buildQuadrantTag(quadrantLabels[1], Colors.blue.shade100)),
                             Positioned(bottom: 10, left: 10, child: _buildQuadrantTag(quadrantLabels[2], Colors.grey.shade200)),
                             Positioned(bottom: 10, right: 10, child: _buildQuadrantTag(quadrantLabels[3], Colors.green.shade100)),
                          ],

                          // Items
                          ...items.map((item) => _buildItem(item)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('橫軸：$xAxisLabel | 縱軸：$yAxisLabel', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAxisLabel(String text, bool isBold) {
    return Text(text, style: TextStyle(fontSize: 11, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: Colors.black54));
  }

  Widget _buildQuadrantTag(String label, Color color) {
    if (label.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
      child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54)),
    );
  }

  Widget _buildItem(QuadrantItem item) {
    return Align(
      alignment: Alignment(item.x, -item.y), // Flutter coordinates: y is positive downwards
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: item.color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4)],
            ),
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              item.label,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
