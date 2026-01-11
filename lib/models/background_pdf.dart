import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

class BackgroundPdf {
  PdfDocument? document;
  final String id;
  Size originalSize = Size.zero;
  bool isLoaded = false;
  double defaultScale = 1.0;

  BackgroundPdf({required this.id, this.defaultScale = 1.0});

  static Future<BackgroundPdf?> fromFile(
    String path,
    String id, {
    double defaultScale = 1.0,
  }) async {
    try {
      final doc = await PdfDocument.openFile(path);

      if (doc.pages.length != 1) {
        debugPrint(
          'Pdf birden fazla sayfa içeriyor: ${doc.pages.length} sayfa',
        );
        doc.dispose();
        return null;
      }

      final page = doc.pages[0];

      final pdfBg = BackgroundPdf(id: id, defaultScale: defaultScale);
      pdfBg.document = doc;
      pdfBg.originalSize = Size(page.width, page.height);
      pdfBg.isLoaded = true;

      return pdfBg;
    } catch (e) {
      debugPrint('Pdf yükleme hatası: $e');
      return null;
    }
  }

  static Future<BackgroundPdf?> fromUrl(
    String url,
    String id, {
    double defaultScale = 1.0,
  }) async {
    try {
      final doc = await PdfDocument.openUri(Uri.parse(url));

      if (doc.pages.length != 1) {
        debugPrint(
          'Pdf birden fazla sayfa içeriyor: ${doc.pages.length} sayfa',
        );
        doc.dispose();
        return null;
      }

      final page = doc.pages[0];

      final pdfBg = BackgroundPdf(id: id, defaultScale: defaultScale);
      pdfBg.document = doc;
      pdfBg.originalSize = Size(page.width, page.height);
      pdfBg.isLoaded = true;

      return pdfBg;
    } catch (e) {
      debugPrint('Pdf url yükleme hatası: $e');
      return null;
    }
  }

  void dispose() {
    document?.dispose();
  }
}
