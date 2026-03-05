import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../models/drawing_element.dart';

class DrawingPainter extends CustomPainter {
  final List<DrawingElement> objects;

  DrawingPainter(this.objects);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    for (var obj in objects) {
      _drawObject(canvas, obj);
    }
    canvas.restore();
  }

  void _drawObject(Canvas canvas, DrawingElement obj) {
    final paint = Paint()
      ..color = obj.color
      ..strokeWidth = obj.strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    switch (obj.type) {
      case 'line':
        _drawLine(canvas, obj, paint);
        break;
      case 'circle':
        _drawCircle(canvas, obj, paint);
        break;
      case 'rectangle':
        _drawRectangle(canvas, obj, paint);
        break;
      case 'arrow':
        _drawArrow(canvas, obj, paint);
        break;
      case 'triangle':
        _drawTriangle(canvas, obj, paint);
        break;
      case 'eraser':
        _drawEraser(canvas, obj);
        break;
      case 'add':
      case 'swf':
      case 'scale':
        break;
    }
  }

  void _drawLine(Canvas canvas, DrawingElement obj, Paint paint) {
    if (obj.points == null || obj.points!.length < 2) return;

    final fullPath = Path();
    fullPath.moveTo(obj.points![0].dx, obj.points![0].dy);
    for (int i = 1; i < obj.points!.length; i++) {
      fullPath.lineTo(obj.points![i].dx, obj.points![i].dy);
    }

    if (obj.duration > 0 && obj.progress < 1.0) {
      final metrics = fullPath.computeMetrics();
      final drawPath = Path();

      for (final metric in metrics) {
        final length = metric.length * obj.progress;
        drawPath.addPath(metric.extractPath(0, length), Offset.zero);
      }

      canvas.drawPath(drawPath, paint);
    } else {
      canvas.drawPath(fullPath, paint);
    }
  }

  void _drawCircle(Canvas canvas, DrawingElement obj, Paint paint) {
    if (obj.rect == null) return;

    if (obj.duration > 0 && obj.progress < 1.0) {
      final sweepAngle = 2 * math.pi * obj.progress;
      final path = Path()..addArc(obj.rect!, -math.pi / 2, sweepAngle);
      canvas.drawPath(path, paint);
    } else {
      canvas.drawOval(obj.rect!, paint);
    }
  }

  void _drawRectangle(Canvas canvas, DrawingElement obj, Paint paint) {
    if (obj.points == null || obj.points!.length < 2) return;

    final fullPath = Path();
    fullPath.moveTo(obj.points![0].dx, obj.points![0].dy);
    for (int i = 1; i < obj.points!.length; i++) {
      fullPath.lineTo(obj.points![i].dx, obj.points![i].dy);
    }
    fullPath.close();

    if (obj.duration > 0 && obj.progress < 1.0) {
      final metrics = fullPath.computeMetrics();
      final drawPath = Path();

      for (final metric in metrics) {
        final length = metric.length * obj.progress;
        drawPath.addPath(metric.extractPath(0, length), Offset.zero);
      }

      canvas.drawPath(drawPath, paint);
    } else {
      canvas.drawPath(fullPath, paint);
    }
  }

  void _drawArrow(Canvas canvas, DrawingElement obj, Paint paint) {
    if (obj.points == null || obj.points!.length < 2) return;

    final start = obj.points!.first;
    final end = obj.points!.last;

    if (obj.duration > 0 && obj.progress < 1.0) {
      final currentEnd = Offset(
        start.dx + (end.dx - start.dx) * obj.progress,
        start.dy + (end.dy - start.dy) * obj.progress,
      );
      canvas.drawLine(start, currentEnd, paint);

      if (obj.progress > 0.8) {
        final arrowSize = 15.0 * ((obj.progress - 0.8) / 0.2);
        _drawArrowHead(canvas, start, currentEnd, arrowSize, paint);
      }
    } else {
      canvas.drawLine(start, end, paint);
      _drawArrowHead(canvas, start, end, 15.0, paint);
    }
  }

  void _drawTriangle(Canvas canvas, DrawingElement obj, Paint paint) {
    if (obj.points == null || obj.points!.length < 3) return;

    final path = Path()
      ..moveTo(obj.points![0].dx, obj.points![0].dy)
      ..lineTo(obj.points![1].dx, obj.points![1].dy)
      ..lineTo(obj.points![2].dx, obj.points![2].dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  void _drawEraser(Canvas canvas, DrawingElement obj) {
    if (obj.points == null || obj.points!.length < 2) return;

    final paint = Paint()
      ..blendMode = BlendMode.clear
      ..strokeWidth = obj.strokeWidth * 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fullPath = Path();
    fullPath.moveTo(obj.points![0].dx, obj.points![0].dy);
    for (int i = 1; i < obj.points!.length; i++) {
      fullPath.lineTo(obj.points![i].dx, obj.points![i].dy);
    }

    if (obj.duration > 0 && obj.progress < 1.0) {
      final metrics = fullPath.computeMetrics();
      final drawPath = Path();

      for (final metric in metrics) {
        final length = metric.length * obj.progress;
        drawPath.addPath(metric.extractPath(0, length), Offset.zero);
      }

      canvas.drawPath(drawPath, paint);
    } else {
      canvas.drawPath(fullPath, paint);
    }
  }

  void _drawArrowHead(
    Canvas canvas,
    Offset start,
    Offset end,
    double arrowSize,
    Paint paint,
  ) {
    final angle = math.atan2(end.dy - start.dy, end.dx - start.dx);

    final arrowPath = Path()
      ..moveTo(end.dx, end.dy)
      ..lineTo(
        end.dx - arrowSize * math.cos(angle - math.pi / 6),
        end.dy - arrowSize * math.sin(angle - math.pi / 6),
      )
      ..moveTo(end.dx, end.dy)
      ..lineTo(
        end.dx - arrowSize * math.cos(angle + math.pi / 6),
        end.dy - arrowSize * math.sin(angle + math.pi / 6),
      );

    canvas.drawPath(arrowPath, paint);
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return true;
  }
}
