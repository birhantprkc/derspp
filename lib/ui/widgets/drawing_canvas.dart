import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../models/drawing_element.dart';
import 'drawing_painter.dart';
import '../../models/animation_model.dart';
import '../../models/background_pdf.dart';
import 'background_pdf_viewer.dart';

class DrawingCanvas extends StatefulWidget {
  final List<DrawingElement> objects;
  final AnimationModel animationData;
  final bool enableInteraction;
  final VideoController? videoController;
  final YoutubePlayerController? youtubeController;
  final bool isDarkMode;

  const DrawingCanvas({
    super.key,
    required this.objects,
    required this.animationData,
    this.enableInteraction = true,
    this.videoController,
    this.youtubeController,
    this.isDarkMode = false,
  });

  @override
  State<DrawingCanvas> createState() => DrawingCanvasState();
}

class DrawingCanvasState extends State<DrawingCanvas> {
  double _userScale = 1.0;
  Offset _offset = Offset.zero;
  Offset? _lastFocalPoint;
  bool _isInitialized = false;

  Orientation? _lastOrientation;
  Size? _lastScreenSize;

  BackgroundPdf? _loadedPdf;
  bool _isPdfLoading = false;
  bool _pdfLoadAttempted = false;

  double _targetScale = 1.0;
  double _currentScale = 1.0;

  double? _localSwfWidth;
  double? _localSwfHeight;

  double? _lastCanvasWidth;
  double? _lastCanvasHeight;

  static const _invertMatrix = <double>[
    -1.0,
    0.0,
    0.0,
    0.0,
    255.0,
    0.0,
    -1.0,
    0.0,
    0.0,
    255.0,
    0.0,
    0.0,
    -1.0,
    0.0,
    255.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
  ];

  @override
  void initState() {
    super.initState();
    _lastCanvasWidth = widget.animationData.canvasWidth;
    _lastCanvasHeight = widget.animationData.canvasHeight;
  }

  @override
  void didUpdateWidget(DrawingCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_lastCanvasWidth != widget.animationData.canvasWidth ||
        _lastCanvasHeight != widget.animationData.canvasHeight) {
      _lastCanvasWidth = widget.animationData.canvasWidth;
      _lastCanvasHeight = widget.animationData.canvasHeight;

      _loadedPdf?.dispose();
      _loadedPdf = null;
      _pdfLoadAttempted = false;
      _isPdfLoading = false;
      _localSwfWidth = null;
      _localSwfHeight = null;
      _isInitialized = false;
    }

    if (widget.animationData.preferPdf &&
        !_pdfLoadAttempted &&
        widget.animationData.pdfUrl != null) {
      _loadPdfFromUrl();
    }
  }

  Future<void> _loadPdfFromUrl() async {
    if (_isPdfLoading || _pdfLoadAttempted) return;

    final pdfUrl = widget.animationData.pdfUrl;
    if (pdfUrl == null) return;

    setState(() {
      _isPdfLoading = true;
      _pdfLoadAttempted = true;
    });

    try {
      final pdf = await BackgroundPdf.fromUrl(
        pdfUrl,
        'light_pdf',
        defaultScale: widget.animationData.pdfDefaultScale,
      );

      if (mounted && pdf != null) {
        setState(() {
          _loadedPdf = pdf;
          _isPdfLoading = false;
          _localSwfWidth = pdf.originalSize.width;
          _localSwfHeight = pdf.originalSize.height;
        });
      }
    } catch (e) {
      debugPrint('Pdf yüklenemedi: $e');
      if (mounted) {
        setState(() {
          _isPdfLoading = false;
        });
      }
    }
  }

  void _initializeTransform(BuildContext context) {
    if (_isInitialized) return;

    final screenSize = MediaQuery.of(context).size;
    final canvasWidth = widget.animationData.canvasWidth;
    final canvasHeight = widget.animationData.canvasHeight;

    final scaleX = (screenSize.width * 1) / canvasWidth;
    final scaleY = (screenSize.height * 1) / canvasHeight;
    _userScale = scaleX < scaleY ? scaleX : scaleY;
    _userScale = _userScale.clamp(0.1, 5.0);

    final scaledWidth = canvasWidth * _userScale;
    final scaledHeight = canvasHeight * _userScale;

    _offset = Offset(
      (screenSize.width - scaledWidth) / 2,
      (screenSize.height - scaledHeight) / 2,
    );

    _currentScale = _userScale;
    _targetScale = _userScale;
    _isInitialized = true;

    if (widget.animationData.preferPdf && !_pdfLoadAttempted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _loadPdfFromUrl();
      });
    }
  }

  void _handleMouseWheel(PointerScrollEvent event) {
    if (!widget.enableInteraction) return;

    setState(() {
      final zoomFactor = event.scrollDelta.dy > 0 ? 0.9 : 1.1;

      final oldScale = _userScale;
      _userScale = (_userScale * zoomFactor).clamp(0.1, 5.0);

      final mousePos = event.localPosition;
      final scaleChange = _userScale / oldScale;

      _offset = Offset(
        mousePos.dx - (mousePos.dx - _offset.dx) * scaleChange,
        mousePos.dy - (mousePos.dy - _offset.dy) * scaleChange,
      );

      _currentScale = _userScale;
      _targetScale = _userScale;
    });
  }

  @override
  void dispose() {
    _loadedPdf?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final orientation = media.orientation;
    final screenSize = media.size;

    if (_lastOrientation != orientation || _lastScreenSize != screenSize) {
      _isInitialized = false;
      _lastOrientation = orientation;
      _lastScreenSize = screenSize;
    }

    _initializeTransform(context);

    final scaledPdfOffset = widget.animationData.pdfOffset * _userScale;

    Widget backgroundContent = _buildBackground(scaledPdfOffset);

    final content = Stack(
      children: [
        Positioned(
          left: _offset.dx,
          top: _offset.dy,
          child: Transform.scale(
            scale: _userScale,
            alignment: Alignment.topLeft,
            child: Container(
              width: widget.animationData.canvasWidth,
              height: widget.animationData.canvasHeight,
              color: widget.isDarkMode ? Colors.black : Colors.white,
            ),
          ),
        ),

        backgroundContent,

        Positioned(
          left: _offset.dx,
          top: _offset.dy,
          child: Transform.scale(
            scale: _userScale,
            alignment: Alignment.topLeft,
            child: Container(
              width: widget.animationData.canvasWidth,
              height: widget.animationData.canvasHeight,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.withOpacity(0.3),
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
              ),
              child: Stack(
                children: [
                  if (widget.animationData.isVideo &&
                      widget.videoController != null)
                    Positioned.fill(
                      child: Video(
                        controller: widget.videoController!,
                        controls: NoVideoControls,
                        fit: BoxFit.fill,
                      ),
                    ),
                  if (widget.youtubeController != null)
                    Positioned.fill(
                      child: YoutubePlayer(
                        controller: widget.youtubeController!,
                        aspectRatio:
                            widget.animationData.canvasWidth /
                            widget.animationData.canvasHeight,
                      ),
                    ),

                  Builder(
                    builder: (context) {
                      Widget paint = CustomPaint(
                        size: Size(
                          widget.animationData.canvasWidth,
                          widget.animationData.canvasHeight,
                        ),
                        painter: DrawingPainter(widget.objects),
                      );

                      if (widget.isDarkMode) {
                        return ColorFiltered(
                          colorFilter: const ColorFilter.matrix(_invertMatrix),
                          child: paint,
                        );
                      }
                      return paint;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    if (!widget.enableInteraction) return content;

    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          _handleMouseWheel(event);
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onScaleStart: _handleScaleStart,
        onScaleUpdate: _handleScaleUpdate,
        onScaleEnd: _handleScaleEnd,
        child: content,
      ),
    );
  }

  Widget _buildBackground(Offset scaledPdfOffset) {
    if (widget.animationData.isVideo) {
      return const SizedBox.shrink();
    }

    Widget? child;

    if (widget.animationData.preferPdf &&
        _loadedPdf != null &&
        _loadedPdf!.isLoaded) {
      child = BackgroundPdfViewer(
        backgroundPdf: _loadedPdf!,
        scale: widget.animationData.pdfDefaultScale * _userScale,
      );
    } else if (widget.animationData.preferPdf && _isPdfLoading) {
      child = const SizedBox(width: 200, height: 200);
    } else {
      return _buildJpgBackground(scaledPdfOffset);
    }

    if (widget.isDarkMode) {
      child = ColorFiltered(
        colorFilter: const ColorFilter.matrix(_invertMatrix),
        child: child,
      );
    }

    return Positioned(
      left: _offset.dx + scaledPdfOffset.dx,
      top: _offset.dy + scaledPdfOffset.dy,
      child: child,
    );
  }

  Widget _buildJpgBackground(Offset scaledPdfOffset) {
    if (widget.animationData.backgroundJpgUrl == null) {
      return const SizedBox.shrink();
    }

    final swfWidth =
        _localSwfWidth ??
        widget.animationData.swfWidth ??
        widget.animationData.canvasWidth;
    final swfHeight =
        _localSwfHeight ??
        widget.animationData.swfHeight ??
        widget.animationData.canvasHeight;

    Widget image = Image.network(
      widget.animationData.backgroundJpgUrl!,
      fit: BoxFit.fill,
    );

    if (widget.isDarkMode) {
      image = ColorFiltered(
        colorFilter: const ColorFilter.matrix(_invertMatrix),
        child: image,
      );
    }

    return Positioned(
      left: _offset.dx + scaledPdfOffset.dx,
      top: _offset.dy + scaledPdfOffset.dy,
      child: SizedBox(
        width: swfWidth * widget.animationData.pdfDefaultScale * _userScale,
        height: swfHeight * widget.animationData.pdfDefaultScale * _userScale,
        child: image,
      ),
    );
  }

  void _handleScaleStart(ScaleStartDetails details) {
    if (!widget.enableInteraction) return;
    _lastFocalPoint = details.focalPoint;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (!widget.enableInteraction) return;

    setState(() {
      _targetScale = (_currentScale * details.scale).clamp(0.1, 5.0);
      _userScale += (_targetScale - _userScale) * 0.2;

      if (_lastFocalPoint != null) {
        _offset += details.focalPoint - _lastFocalPoint!;
      }
      _lastFocalPoint = details.focalPoint;
    });
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    if (!widget.enableInteraction) return;

    setState(() {
      _lastFocalPoint = null;
      _currentScale = _userScale;
      _targetScale = _userScale;
    });
  }
}
