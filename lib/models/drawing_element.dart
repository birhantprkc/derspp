import 'package:flutter/material.dart';

class DrawingElement {
  final double startTime;
  double duration;
  final double realDuration;
  final String type;
  final String id;
  final Color color;
  final double strokeWidth;
  final List<Offset>? points;
  final Rect? rect;
  bool isActive;
  String? imageObjectId;
  double progress = 0.0;

  DrawingElement({
    required this.startTime,
    required this.duration,
    required this.type,
    required this.id,
    required this.color,
    this.strokeWidth = 2.0,
    this.points,
    this.rect,
    this.isActive = false,
    this.imageObjectId,
  }) : realDuration = duration;

  void updateProgress(double currentTime) {
    if (duration == 0 || duration < 0.01) {
      progress = 1.0;
      return;
    }
    final elapsed = currentTime - startTime;
    progress = (elapsed / duration).clamp(0.0, 1.0);
  }
}
