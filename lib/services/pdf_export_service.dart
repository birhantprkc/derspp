import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdfrx/pdfrx.dart' as pdfrx;
import 'package:universal_io/io.dart';
import '../database/database.dart';
import '../models/question.dart';
import '../services/cors_proxy_service.dart';
import '../services/f2_source_service.dart';
import '../services/source_factory.dart';

class PdfExportService {
  static final _http = http.Client();

  static const double _renderScale = 3.0;
  static const double _cellGap = 14.0;
  static const double _pageMargin = 20.0;
  static const double _headerHeight = 32.0;
  static const double _footerHeight = 45.0;

  static Future<String> exportQuestions({
    required List<SavedQuestion> questions,
    required String name,
    int columns = 2,
    Map<int, Uint8List>? manualCaptures,
    void Function(int current, int total)? progressCallback,
  }) async {
    await _ensureFontsLoaded();
    final pdf = pw.Document();
    final dir = await _getOutputDir();
    const pageFormat = PdfPageFormat.a4;

    final questionItems = <_QuestionData>[];
    for (int i = 0; i < questions.length; i++) {
      progressCallback?.call(i + 1, questions.length);
      final sq = questions[i];
      final manualImage = manualCaptures?[sq.id];
      final (imgResult, isVideo) = manualImage != null
          ? (await _handleManualImage(manualImage), false)
          : await _downloadQuestionImage(sq);
      questionItems.add(
        _QuestionData(
          index: i + 1,
          imageBytes: imgResult?.bytes,
          imageWidth: imgResult?.width ?? 0,
          imageHeight: imgResult?.height ?? 0,
          note: sq.notes,
          answer: sq.answer,
          isVideoOnly: isVideo,
        ),
      );
    }

    final usableWidth = pageFormat.width - _pageMargin * 2;
    final usableHeight = pageFormat.height - _pageMargin * 2 - _headerHeight;
    final columnWidth = (usableWidth - (columns - 1) * _cellGap) / columns;
    final pages = _paginateItems(
      questionItems,
      columns: columns,
      columnWidth: columnWidth,
      usableHeight: usableHeight,
    );

    int i = 0;
    for (final pageColumns in pages) {
      i++;
      final currentPageNum = i;
      pdf.addPage(
        pw.Page(
          pageFormat: pageFormat,
          margin: pw.EdgeInsets.zero,
          build: (_) =>
              _buildTestPage(pageColumns, columns, currentPageNum, name),
        ),
      );
    }

    final fileName =
        '${name.replaceAll(RegExp(r'[^\w\s\-ğüşiöçĞÜŞİÖÇ]'), '')}.pdf';
    final filePath = p.join(dir.path, fileName);
    await File(filePath).writeAsBytes(await pdf.save());
    return filePath;
  }

  static List<List<List<_QuestionData>>> _paginateItems(
    List<_QuestionData> items, {
    required int columns,
    required double columnWidth,
    required double usableHeight,
  }) {
    final effectiveHeight = usableHeight - _footerHeight;
    final pages = <List<List<_QuestionData>>>[];
    var remainingItems = List<_QuestionData>.from(items);

    while (remainingItems.isNotEmpty) {
      final pageColumns = List.generate(columns, (_) => <_QuestionData>[]);
      for (int c = 0; c < columns; c++) {
        double currentHeight = 0;
        while (remainingItems.isNotEmpty) {
          final item = remainingItems.first;
          final h = _estimateCellHeight(item, columnWidth) + _cellGap;
          if (currentHeight + h > effectiveHeight && currentHeight > 0) break;
          pageColumns[c].add(remainingItems.removeAt(0));
          currentHeight += h;
        }
      }
      if (pageColumns.any((col) => col.isNotEmpty)) pages.add(pageColumns);
    }
    return pages;
  }

  static double _estimateCellHeight(_QuestionData item, double cellWidth) {
    const double numberWidth = 22.0;
    final double contentWidth = cellWidth - numberWidth - 10;
    double h = 10.0;
    if (item.imageBytes != null && item.imageHeight > 0) {
      h += contentWidth / (item.imageWidth / item.imageHeight);
    } else if (item.isVideoOnly) {
      h += 60.0;
    } else {
      h += 100.0;
    }
    if (item.note != null && item.note!.isNotEmpty) {
      h += 6.0 + 14.0;
    }
    return h;
  }

  static pw.Font? _fontRegular;
  static pw.Font? _fontBold;

  static Future<void> _ensureFontsLoaded() async {
    if (_fontRegular != null && _fontBold != null) return;
    try {
      final regularData = await rootBundle.load(
        'assets/fonts/NotoSans-Regular.ttf',
      );
      final boldData = await rootBundle.load('assets/fonts/NotoSans-Bold.ttf');
      _fontRegular = pw.Font.ttf(regularData);
      _fontBold = pw.Font.ttf(boldData);
    } catch (e) {
      debugPrint('Font yükleme hatası: $e');
      _fontRegular = pw.Font.helvetica();
      _fontBold = pw.Font.helveticaBold();
    }
  }

  static pw.TextStyle _textStyle({
    double fontSize = 10,
    bool bold = false,
    PdfColor? color,
  }) {
    return pw.TextStyle(
      font: bold ? _fontBold : _fontRegular,
      fontSize: fontSize,
      fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
      color: color,
    );
  }

  static pw.Widget _buildTestPage(
    List<List<_QuestionData>> pageColumns,
    int columns,
    int pageNum,
    String title,
  ) {
    final usableWidth = PdfPageFormat.a4.width - _pageMargin * 2;
    final columnWidth = (usableWidth - (columns - 1) * _cellGap) / columns;
    final usableHeight =
        PdfPageFormat.a4.height -
        _pageMargin * 2 -
        _headerHeight -
        _footerHeight;

    final columnWidgets = <pw.Widget>[];
    for (int i = 0; i < columns; i++) {
      columnWidgets.add(
        pw.SizedBox(
          width: columnWidth,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: pageColumns[i]
                .map(
                  (item) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: _cellGap),
                    child: _buildQuestionCell(item, columnWidth),
                  ),
                )
                .toList(),
          ),
        ),
      );
      if (i < columns - 1) {
        columnWidgets.add(
          pw.Container(
            width: _cellGap,
            child: pw.Stack(
              alignment: pw.Alignment.center,
              children: [
                pw.VerticalDivider(
                  color: PdfColors.grey500,
                  thickness: 0.5,
                  indent: 2,
                  endIndent: 2,
                ),
                pw.Container(
                  color: PdfColors.white,
                  height: 55,
                  width: _cellGap,
                  child: pw.Transform.translate(
                    offset: const PdfPoint(0, -12),
                    child: pw.Transform.rotate(
                      angle: pi / 2,
                      child: pw.Center(
                        child: pw.Text(
                          'derspp',
                          softWrap: false,
                          style: _textStyle(
                            fontSize: 12,
                            bold: true,
                            color: PdfColors.grey400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    return pw.Stack(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(_pageMargin),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      title,
                      style: _textStyle(fontSize: 12, bold: false),
                      overflow: pw.TextOverflow.clip,
                      maxLines: 1,
                    ),
                  ),
                  pw.Text(
                    'DERSPP DAĞITIM YAPMAZ İÇERİĞİN TAMAMI KULLANICI CİHAZINDA OLUŞTURULUR',
                    style: _textStyle(fontSize: 9, bold: false),
                  ),
                  pw.SizedBox(width: 10),
                  pw.Text('$pageNum', style: _textStyle(fontSize: 9)),
                ],
              ),
              pw.Divider(color: PdfColors.grey400, thickness: 0.5),
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 8),
                child: pw.SizedBox(
                  height: usableHeight,
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                    children: columnWidgets,
                  ),
                ),
              ),
              pw.Spacer(),
              _buildPageAnswerKey(pageColumns),
            ],
          ),
        ),
        pw.Positioned.fill(child: _buildWatermark()),
      ],
    );
  }

  static pw.Widget _buildPageAnswerKey(List<List<_QuestionData>> pageColumns) {
    final allQuestions = pageColumns.expand((col) => col).toList();
    final answered = allQuestions
        .where((q) => q.answer != null && q.answer!.isNotEmpty)
        .toList();

    if (answered.isEmpty) return pw.SizedBox();

    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 5),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
        ),
      ),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Wrap(
              spacing: 8,
              runSpacing: 4,
              children: answered.map((q) {
                return pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
                  ),
                  child: pw.Row(
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      pw.Text(
                        '${q.index}:',
                        style: _textStyle(fontSize: 8, bold: true),
                      ),
                      pw.SizedBox(width: 2),
                      pw.Text(q.answer!, style: _textStyle(fontSize: 8)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildWatermark() {
    return pw.Opacity(
      opacity: 0.6,
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: List.generate(8, (i) {
          return pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 80),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: List.generate(3, (j) {
                return pw.Transform.rotate(
                  angle: -pi / 8,
                  child: pw.Text(
                    '',
                    style: _textStyle(fontSize: 10, color: PdfColors.grey300),
                  ),
                );
              }),
            ),
          );
        }),
      ),
    );
  }

  static pw.Widget _buildQuestionCell(_QuestionData item, double cellWidth) {
    const double numberWidth = 22.0;
    final double contentWidth = cellWidth - numberWidth - 10;

    return pw.Container(
      width: cellWidth,
      padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: numberWidth,
            child: pw.Text(
              '${item.index}.',
              style: _textStyle(fontSize: 10, bold: false),
            ),
          ),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (item.imageBytes != null && item.imageHeight > 0)
                  pw.SizedBox(
                    height: contentWidth / (item.imageWidth / item.imageHeight),
                    width: contentWidth,
                    child: pw.Image(
                      pw.MemoryImage(item.imageBytes!),
                      fit: pw.BoxFit.contain,
                    ),
                  )
                else if (item.isVideoOnly)
                  pw.Container(
                    height: 60,
                    width: contentWidth,
                    color: PdfColors.grey100,
                    child: pw.Center(
                      child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text('▶', style: _textStyle(fontSize: 16)),
                          pw.SizedBox(height: 2),
                          pw.Text('Video Soru', style: _textStyle(fontSize: 8)),
                        ],
                      ),
                    ),
                  )
                else
                  pw.Container(
                    height: 100,
                    width: contentWidth,
                    child: pw.Center(child: pw.Text('—', style: _textStyle())),
                  ),
                if (item.note != null && item.note!.isNotEmpty) ...[
                  pw.SizedBox(height: 6),
                  pw.Text(item.note!, style: _textStyle(fontSize: 11)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildAnswerKey(List<_QuestionData> answers) {
    const cols = 5;
    final rows = <pw.Widget>[];

    for (int i = 0; i < answers.length; i += cols) {
      final rowItems = answers.skip(i).take(cols).toList();
      rows.add(
        pw.Row(
          children: rowItems.map((a) {
            return pw.Expanded(
              child: pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 3),
                child: pw.Row(
                  children: [
                    pw.Text(
                      '${a.index}.',
                      style: _textStyle(fontSize: 9, bold: true),
                    ),
                    pw.SizedBox(width: 4),
                    pw.Text(
                      a.answer!,
                      style: _textStyle(fontSize: 9, bold: true),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Cevap Anahtarı', style: _textStyle(fontSize: 14, bold: true)),
        pw.Divider(color: PdfColors.grey400, thickness: 0.5),
        pw.SizedBox(height: 8),
        ...rows,
      ],
    );
  }

  static Future<_ImageResult?> _handleManualImage(Uint8List bytes) async {
    final dims = await _getImageDimensions(bytes);
    return _ImageResult(bytes, dims.$1, dims.$2);
  }

  static Future<(_ImageResult?, bool)> _downloadQuestionImage(
    SavedQuestion sq,
  ) async {
    final questionData = _parseQuestionJson(sq);
    if (questionData == null) return (null, false);

    final question = Question.fromJson(questionData);

    if (sq.scraperType == 'custom_question') {
      return _handleCustomQuestion(question);
    }

    if (sq.scraperType == 'f2source') {
      return _handleF2Question(question, sq);
    }

    final pdfUrl = question.pdfUrl;
    if (pdfUrl == null || pdfUrl.isEmpty) {
      if (_isVideoUrl(question.videoUrl)) return (null, true);
      return (null, false);
    }
    final result = await _handlePdfQuestion(pdfUrl, sq.id);
    return (result, false);
  }

  static bool _isVideoUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    return url.contains('youtube.com') ||
        url.contains('youtu.be') ||
        url.endsWith('.mp4') ||
        url.contains('.mp4?');
  }

  static Future<(_ImageResult?, bool)> _handleCustomQuestion(
    Question question,
  ) async {
    final videoUrl = question.videoUrl;
    if (videoUrl == null) return (null, false);

    final isImage =
        videoUrl.startsWith('data:image/') ||
        videoUrl.endsWith('.png') ||
        videoUrl.endsWith('.jpg') ||
        videoUrl.endsWith('.jpeg');

    if (!isImage) {
      return (null, _isVideoUrl(videoUrl));
    }

    Uint8List? bytes;
    if (videoUrl.startsWith('data:image/')) {
      bytes = base64Decode(videoUrl.split(',').last);
    } else if (videoUrl.startsWith('http')) {
      bytes = await _downloadImageBytes(videoUrl);
    } else {
      final file = File(videoUrl);
      if (await file.exists()) bytes = await file.readAsBytes();
    }
    if (bytes == null) return (null, false);

    final dims = await _getImageDimensions(bytes);
    return (_ImageResult(bytes, dims.$1, dims.$2), false);
  }

  static Future<(_ImageResult?, bool)> _handleF2Question(
    Question question,
    SavedQuestion sq,
  ) async {
    try {
      final sourceService = SourceFactory.getSourceService('f2source');
      if (sourceService is! F2SourceService) return (null, false);

      final qId = question.videoUrl ?? question.id;

      final jpgUrl = await sourceService.fetchJpgUrl(
        sq.baseUrl,
        qId,
        question.width ?? 0,
        question.height ?? 0,
      );

      if (jpgUrl != null && jpgUrl.isNotEmpty) {
        final bytes = await _downloadImageBytes(jpgUrl);
        if (bytes != null) {
          final dims = await _getImageDimensions(bytes);
          return (_ImageResult(bytes, dims.$1, dims.$2), false);
        }
      }

      final contentType = await sourceService.detectContentType(
        sq.baseUrl,
        qId,
      );
      if (contentType['type'] == 'mp4') {
        return (null, true);
      }

      return (null, false);
    } catch (e) {
      debugPrint('f2source JPG hatası: $e');
      return (null, false);
    }
  }

  static Future<Uint8List?> _downloadImageBytes(String url) async {
    try {
      final response = await _http.get(_proxiedUrl(url));
      if (response.statusCode == 200) return response.bodyBytes;
    } catch (e) {
      debugPrint('Görsel indirme hatası: $e');
    }
    return null;
  }

  static Future<(double, double)> _getImageDimensions(Uint8List bytes) async {
    try {
      final decoded = img.decodeImage(bytes);
      if (decoded != null) {
        return (decoded.width.toDouble(), decoded.height.toDouble());
      }
    } catch (_) {}
    return (400.0, 300.0);
  }

  static Future<_ImageResult?> _handlePdfQuestion(
    String pdfUrl,
    int questionId,
  ) async {
    File? tempFile;
    try {
      final response = await _http.get(_proxiedUrl(pdfUrl));
      if (response.statusCode != 200) return null;

      final tempDir = await getTemporaryDirectory();
      tempFile = File(p.join(tempDir.path, 'q_$questionId.pdf'));
      await tempFile.writeAsBytes(response.bodyBytes);

      final doc = await pdfrx.PdfDocument.openFile(tempFile.path);
      if (doc.pages.isEmpty) {
        await doc.dispose();
        return null;
      }

      final page = doc.pages[0];
      final fullW = page.width * _renderScale;
      final fullH = page.height * _renderScale;

      final pageImage = await page.render(
        fullWidth: fullW,
        fullHeight: fullH,
        width: fullW.toInt(),
        height: fullH.toInt(),
      );

      await doc.dispose();
      if (pageImage == null) return null;

      final result = await compute(
        _rgbaToCroppedPngIsolate,
        _RgbaCropEncodeRequest(
          rgba: pageImage.pixels,
          width: pageImage.width,
          height: pageImage.height,
        ),
      );
      if (result == null) return null;

      return _ImageResult(
        result.$1,
        result.$2.toDouble(),
        result.$3.toDouble(),
      );
    } catch (e) {
      debugPrint('PDF render hatası: $e');
      return null;
    } finally {
      try {
        if (tempFile != null && await tempFile.exists()) {
          await tempFile.delete();
        }
      } catch (_) {}
    }
  }

  static (Uint8List, int, int)? _rgbaToCroppedPngIsolate(
    _RgbaCropEncodeRequest req,
  ) {
    try {
      var image = img.Image.fromBytes(
        width: req.width,
        height: req.height,
        bytes: req.rgba.buffer,
        order: img.ChannelOrder.rgba,
      );
      image = _autoCrop(image, padding: req.cropPadding);
      final pngBytes = img.encodePng(image);
      return (Uint8List.fromList(pngBytes), image.width, image.height);
    } catch (_) {
      return null;
    }
  }

  static img.Image _autoCrop(
    img.Image src, {
    int threshold = 245,
    int padding = 8,
  }) {
    final w = src.width;
    final h = src.height;
    int top = 0, bottom = h - 1, left = 0, right = w - 1;

    outer:
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        if (!_isNearWhite(src.getPixel(x, y), threshold)) {
          top = y;
          break outer;
        }
      }
    }
    outer:
    for (int y = h - 1; y >= top; y--) {
      for (int x = 0; x < w; x++) {
        if (!_isNearWhite(src.getPixel(x, y), threshold)) {
          bottom = y;
          break outer;
        }
      }
    }
    outer:
    for (int x = 0; x < w; x++) {
      for (int y = top; y <= bottom; y++) {
        if (!_isNearWhite(src.getPixel(x, y), threshold)) {
          left = x;
          break outer;
        }
      }
    }
    outer:
    for (int x = w - 1; x >= left; x--) {
      for (int y = top; y <= bottom; y++) {
        if (!_isNearWhite(src.getPixel(x, y), threshold)) {
          right = x;
          break outer;
        }
      }
    }

    top = (top - padding).clamp(0, h - 1);
    bottom = (bottom + padding).clamp(0, h - 1);
    left = (left - padding).clamp(0, w - 1);
    right = (right + padding).clamp(0, w - 1);

    final cropW = right - left + 1;
    final cropH = bottom - top + 1;
    if (cropW < 20 || cropH < 20) return src;

    return img.copyCrop(src, x: left, y: top, width: cropW, height: cropH);
  }

  static bool _isNearWhite(img.Pixel pixel, int threshold) {
    return pixel.r.toInt() >= threshold &&
        pixel.g.toInt() >= threshold &&
        pixel.b.toInt() >= threshold;
  }

  static Uri _proxiedUrl(String url) {
    return Uri.parse(CorsProxyService.instance.wrapUrlString(url));
  }

  static Map<String, dynamic>? _parseQuestionJson(SavedQuestion sq) {
    try {
      return jsonDecode(sq.rawJson) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('JSON parse hatası: $e');
      return null;
    }
  }

  static Future<Directory> _getOutputDir() async {
    final appDir = await getApplicationSupportDirectory();
    final dir = Directory(p.join(appDir.path, 'generated_tests'));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }
}

class _ImageResult {
  final Uint8List bytes;
  final double width;
  final double height;
  _ImageResult(this.bytes, this.width, this.height);
}

class _QuestionData {
  final int index;
  final Uint8List? imageBytes;
  final double imageWidth;
  final double imageHeight;
  final String? note;
  final String? answer;
  final bool isVideoOnly;

  _QuestionData({
    required this.index,
    this.imageBytes,
    required this.imageWidth,
    required this.imageHeight,
    this.note,
    this.answer,
    this.isVideoOnly = false,
  });
}

class _RgbaCropEncodeRequest {
  final Uint8List rgba;
  final int width;
  final int height;
  final int cropPadding = 8;

  _RgbaCropEncodeRequest({
    required this.rgba,
    required this.width,
    required this.height,
  });
}
