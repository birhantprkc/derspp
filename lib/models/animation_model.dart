import 'package:flutter/painting.dart';

import 'drawing_element.dart';
import 'background_pdf.dart';

class AnimationModel {
  final List<DrawingElement> objects;
  Duration totalDuration;
  String? audioPath;
  String? backgroundJpgUrl;
  String? pdfUrl;
  bool preferPdf = false;
  BackgroundPdf? backgroundPdf;
  String? videoUrl;
  bool get isVideo => videoUrl != null && videoUrl!.isNotEmpty;

  double canvasWidth;
  double canvasHeight;
  final double pdfDefaultScale;
  final Offset pdfOffset;

  double? swfWidth;
  double? swfHeight;

  AnimationModel({
    required this.objects,
    required this.totalDuration,
    this.audioPath,
    this.backgroundPdf,
    this.backgroundJpgUrl,
    this.pdfUrl,
    this.preferPdf = false,
    required this.canvasWidth,
    required this.canvasHeight,
    required this.pdfDefaultScale,
    required this.pdfOffset,
    this.swfWidth,
    this.swfHeight,
    this.videoUrl,
  });

  void update(double currentSeconds) {
    final deleteObjects = objects.where((o) => o.type == 'delete').toList();

    for (var obj in objects) {
      final endTime = obj.startTime + obj.duration;

      if (currentSeconds < obj.startTime) {
        obj.isActive = false;
        obj.progress = 0.0;
      } else if (obj.duration < 0.01 || currentSeconds >= endTime) {
        obj.isActive = true;
        obj.progress = 1.0;
      } else {
        obj.isActive = true;
        obj.updateProgress(currentSeconds);
      }

      for (var del in deleteObjects) {
        if (del.isActive) {
          final targetId = del.imageObjectId;
          if (targetId != null && targetId.isNotEmpty) {
            for (var target in objects) {
              if (target.id == targetId) {
                target.isActive = false;
                target.progress = 0.0;
              }
            }
          }
        }
      }
    }
  }

  void setPlaybackSpeed(double speed) {
    for (var obj in objects) {
      obj.duration = obj.realDuration / speed;
    }
  }

  List<DrawingElement> getActiveObjects() {
    return objects.where((obj) => obj.isActive).toList();
  }

  int get totalObjectCount => objects.length;

  int get activeObjectCount => getActiveObjects().length;

  int get imageCount => (backgroundJpgUrl != null && !preferPdf) ? 1 : 0;

  bool get hasPdf =>
      backgroundPdf != null &&
      backgroundPdf!.isLoaded &&
      (preferPdf || backgroundJpgUrl == null);

  bool get hasAudio => audioPath != null && audioPath!.isNotEmpty;

  bool get hasImageObjects {
    return objects.any(
      (obj) => obj.type == 'swf' || obj.type == 'add' || obj.type == 'scale',
    );
  }

  Set<String> getImageObjectIds() {
    return objects
        .where((obj) => obj.imageObjectId != null)
        .map((obj) => obj.imageObjectId!)
        .toSet();
  }
}
