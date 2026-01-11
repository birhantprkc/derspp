import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import '../../models/background_pdf.dart';

class BackgroundPdfViewer extends StatelessWidget {
  final BackgroundPdf backgroundPdf;
  final double scale;

  const BackgroundPdfViewer({
    super.key,
    required this.backgroundPdf,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    if (backgroundPdf.document == null || !backgroundPdf.isLoaded) {
      return const SizedBox.shrink();
    }

    final targetWidth = backgroundPdf.originalSize.width * scale;
    final targetHeight = backgroundPdf.originalSize.height * scale;

    return ClipRect(
      child: SizedBox(
        width: targetWidth,
        height: targetHeight,
        child: PdfPageView(
          document: backgroundPdf.document,
          pageNumber: 1,
          alignment: Alignment.topLeft,
          maximumDpi: (300 * scale).clamp(300, 600),
        ),
      ),
    );
  }
}
