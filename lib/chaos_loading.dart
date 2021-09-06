library chaos_loading;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ChaosLoadingWidget extends StatefulWidget {
  const ChaosLoadingWidget({Key? key, this.color = Colors.purpleAccent, this.size = 88.0})
      : super(key: key);

  final Color color;
  final double size;

  @override
  State<StatefulWidget> createState() => _ChaosLoadingState();
}

class _ChaosLoadingState extends State<ChaosLoadingWidget> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double angle = 0;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween(begin: 0.0, end: pi * 2).animate(_controller);
    _controller.repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, _) => Transform(
            transform: Matrix4.identity()
              ..rotate(vector.Vector3(0, -8, 12), pi)
              ..rotateZ(_animation.value),
            alignment: Alignment.center,
            child: CustomPaint(
              painter: _ChaosPainter(widget.color),
              size: Size(widget.size, widget.size),
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, _) => Transform(
            transform: Matrix4.identity()
              ..rotate(vector.Vector3(-12, 8, 8), pi)
              ..rotateZ(_animation.value),
            alignment: Alignment.center,
            child: CustomPaint(
              painter: _ChaosPainter(widget.color),
              size: Size(widget.size, widget.size),
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, _) => Transform(
            transform: Matrix4.identity()
              ..rotate(vector.Vector3(-8, -8, 6), pi)
              ..rotateZ(_animation.value),
            alignment: Alignment.center,
            child: CustomPaint(
              painter: _ChaosPainter(widget.color),
              size: Size(widget.size, widget.size),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChaosPainter extends CustomPainter {
  _ChaosPainter(this.paintColor);

  final Color paintColor;

  Paint _paint = Paint()
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeJoin = StrokeJoin.bevel
    ..strokeWidth = 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    _paint..color = paintColor;
    Path path = new Path();
    double w = size.width;
    double h = size.height;
    double topH = h * 0.92;
    path.moveTo(0, h / 2);
    path.cubicTo(0, topH * 3 / 4, w / 4, topH, w / 2, topH);
    path.cubicTo(w * 3 / 4, topH, w, topH * 3 / 4, w, h / 2);
    path.cubicTo(w, h * 3 / 4, w * 3 / 4, h, w / 2, h);
    path.cubicTo(w / 4, h, 0, h * 3 / 4, 0, h / 2);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _ChaosClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    double w = size.width;
    double h = size.height;
    double topH = h * 0.92;
    path.moveTo(0, h / 2);
    path.cubicTo(0, topH * 3 / 4, w / 4, topH, w / 2, topH);
    path.cubicTo(w * 3 / 4, topH, w, topH * 3 / 4, w, h / 2);
    path.cubicTo(w, h * 3 / 4, w * 3 / 4, h, w / 2, h);
    path.cubicTo(w / 4, h, 0, h * 3 / 4, 0, h / 2);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
