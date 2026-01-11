import 'dart:convert';
import 'dart:math' as math;
import 'package:xml/xml.dart';
import 'package:flutter/material.dart';
import '../models/drawing_element.dart';
import '../models/animation_model.dart';

class XmlParserService {
  static const String _cryptKey = '10,20';

  static Future<AnimationModel> decodeAndParseXmlIsolate(
    String xmlContent,
  ) async {
    final decoded = decodeBase64Xml(xmlContent, _cryptKey);
    return parseXml(decoded);
  }

  static String decodeBase64Xml(String encodedXml, String cryptKey) {
    try {
      final keys = cryptKey.split(',').map((k) => int.parse(k)).toList();
      final chars = encodedXml.split('');

      keys.sort((a, b) => b.compareTo(a));
      for (var key in keys) {
        if (key < chars.length) {
          chars.removeAt(key);
        }
      }

      final decoded = utf8.decode(base64Decode(chars.join('')));
      return decoded.replaceAll(',', '.');
    } catch (e) {
      debugPrint('Base64 decode hatası: $e');
      return encodedXml;
    }
  }

  static Future<AnimationModel> parseXml(String xmlString) async {
    final document = XmlDocument.parse(xmlString);
    final objects = <DrawingElement>[];

    double pD(String? value, [double defaultValue = 0.0]) {
      if (value == null) return defaultValue;
      return double.tryParse(value.trim().replaceAll(',', '.')) ?? defaultValue;
    }

    int pI(String? value, [int defaultValue = 0]) {
      if (value == null) return defaultValue;
      return int.tryParse(value.trim()) ?? defaultValue;
    }

    for (var element in document.findAllElements('obj')) {
      try {
        final type = element.getAttribute('act') ?? '';
        final startTime = pD(element.getAttribute('t1')) / 1000;
        final duration = pD(element.getAttribute('t2')) / 1000;
        final colorInt = pI(element.getAttribute('color'));
        final color = Color(0xFF000000 + colorInt);
        final strokeWidth = pD(element.getAttribute('thc'), 2.0);

        List<Offset>? points;
        Rect? rect;
        String? imageObjectId;

        if (type == 'line' || type == 'arrow' || type == 'eraser') {
          final pts = <Offset>[];
          for (var po in element.findElements('po')) {
            final coords = po.text.split('|');
            if (coords.length >= 2) {
              pts.add(Offset(pD(coords[0]), pD(coords[1])));
            }
          }
          if (pts.isNotEmpty) points = pts;
        } else if (type == 'circle' || type == 'rectangle') {
          final rectElement = element.findElements('rect').firstOrNull;
          if (rectElement != null) {
            final coords = rectElement.text.split('|');
            if (coords.length >= 4) {
              rect = Rect.fromLTWH(
                pD(coords[0]),
                pD(coords[1]),
                pD(coords[2]),
                pD(coords[3]),
              );
            }
          }
        } else if (type == 'add' ||
            type == 'swf' ||
            type == 'scale' ||
            type == 'delete') {
          imageObjectId = element.findElements('id').firstOrNull?.text;
        }

        objects.add(
          DrawingElement(
            startTime: startTime,
            duration: duration,
            type: type,
            id: element.getAttribute('name') ?? '',
            color: color,
            strokeWidth: strokeWidth,
            points: points,
            rect: rect,
            imageObjectId: imageObjectId,
          ),
        );
      } catch (e) {
        debugPrint('Obje parse hatası: $e');
      }
    }

    objects.sort((a, b) => a.startTime.compareTo(b.startTime));

    final maxTime = objects.isNotEmpty
        ? objects
              .map((o) => o.startTime + o.duration)
              .reduce((a, b) => math.max(a, b))
        : 0.0;

    final infoElement = document.findAllElements('info').first;
    final infoParts = infoElement.text.split('|').map((e) => pD(e)).toList();

    return AnimationModel(
      objects: objects,
      totalDuration: Duration(milliseconds: (maxTime * 1000).toInt()),
      canvasWidth: infoParts[0],
      canvasHeight: infoParts[1],
      pdfDefaultScale: infoParts[2],
      pdfOffset: Offset(infoParts[3], infoParts[4]),
    );
  }
}
