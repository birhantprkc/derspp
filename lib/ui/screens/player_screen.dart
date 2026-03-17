import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../database/database.dart';
import '../../models/animation_model.dart';
import '../../models/question.dart';
import '../widgets/drawing_canvas.dart';
import '../widgets/player_controls.dart';
import '../../providers/theme_provider.dart';
import '../../providers/saved_questions_provider.dart';
import '../../providers/source_provider.dart';
import '../../providers/transcription_provider.dart';

class PlayerScreen extends StatefulWidget {
  final AnimationModel animationData;
  final Question? question;
  final SavedQuestion? savedQuestion;
  final VoidCallback? onNextVideo;
  final VoidCallback? onPreviousVideo;
  final bool hasNextVideo;
  final bool hasPreviousVideo;
  const PlayerScreen({
    super.key,
    required this.animationData,
    this.question,
    this.savedQuestion,
    this.onNextVideo,
    this.onPreviousVideo,
    this.hasNextVideo = false,
    this.hasPreviousVideo = false,
  });
  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  Timer? _animationTimer;
  late final Player _player;
  VideoController? _videoController;
  YoutubePlayerController? _youtubeController;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isPlaying = false;
  double _playbackSpeed = 1.0;
  bool _isAudioReady = false;
  bool _isLocked = false;
  bool _isSeeking = false;
  bool _isInitializing = false;
  bool _wasPlayingBeforeSeek = false;
  double? _lastLongPressX;
  bool _controlsVisible = true;
  Timer? _controlsHideTimer;
  DateTime? _lastSyncTime;
  Duration _lastSyncPos = Duration.zero;
  final GlobalKey<DrawingCanvasState> _canvasKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        Provider.of<TranscriptionProvider>(context, listen: false).reset();
      }
    });
    _totalDuration = widget.animationData.totalDuration;
    _player = Player();
    _setupPlayerListeners();
    if (widget.animationData.isVideo) {
      _initVideo();
    } else if (widget.animationData.hasAudio) {
      _initAndLoadAudio();
    } else {
      _isAudioReady = true;
    }
    _loadDefaultPlaybackSpeed();
    _startAnimationTimer();
    _startControlsHideTimer();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _startControlsHideTimer() {
    _controlsHideTimer?.cancel();
    _controlsHideTimer = Timer(const Duration(seconds: 4), () {
      if (mounted && !_isSeeking && _lastLongPressX == null) {
        setState(() => _controlsVisible = false);
      }
    });
  }

  void _resetControlsHideTimer() {
    _controlsHideTimer?.cancel();
    if (!_controlsVisible) {
      setState(() => _controlsVisible = true);
    }
    _startControlsHideTimer();
  }

  void _toggleControls() {
    setState(() => _controlsVisible = !_controlsVisible);
    if (_controlsVisible) {
      _startControlsHideTimer();
    } else {
      _controlsHideTimer?.cancel();
    }
  }

  void _setupPlayerListeners() {
    _player.stream.playing.listen((isPlaying) {
      if (!mounted) return;
      setState(() => _isPlaying = isPlaying);
    });
    _player.stream.duration.listen((duration) {
      if (!mounted) return;
      if (duration != Duration.zero) {
        setState(() {
          _totalDuration = duration;
          widget.animationData.totalDuration = duration;
        });
      }
    });
    _player.stream.width.listen((width) {
      if (width != null && width > 0 && mounted) {
        setState(() {
          widget.animationData.canvasWidth = width.toDouble();
        });
        debugPrint('Video genişliği: $width');
      }
    });
    _player.stream.height.listen((height) {
      if (height != null && height > 0 && mounted) {
        setState(() {
          widget.animationData.canvasHeight = height.toDouble();
        });
        debugPrint('Video yüksekliği: $height');
      }
    });
    _player.stream.completed.listen((completed) {
      if (completed) _onPlaybackComplete();
    });
  }

  Future<void> _initVideo() async {
    final url = widget.animationData.videoUrl;
    if (url == null) return;
    final bool isDesktop =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.linux ||
            defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.macOS);
    String? ytId = YoutubePlayerController.convertUrlToId(url);
    if (ytId != null && !isDesktop) {
      debugPrint('Youtube videosu algılandı: $ytId');
      _youtubeController = YoutubePlayerController.fromVideoId(
        videoId: ytId,
        autoPlay: true,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
          strictRelatedVideos: false,
        ),
      );
      widget.animationData.canvasWidth = 1920;
      widget.animationData.canvasHeight = 1080;
      if (mounted) {
        setState(() {});
      }
      return;
    }
    try {
      _videoController = VideoController(_player);
      await _player.open(Media(url));
      await _player.setRate(_playbackSpeed);
      if (mounted) {
        setState(() {
          if (!widget.animationData.hasAudio) {
            _isAudioReady = true;
          }
        });
      }
    } catch (e) {
      debugPrint('Video başlatma hatası: $e');
    }
  }

  Future<void> _loadDefaultPlaybackSpeed() async {
    try {
      final db = context.read<AppDatabase>();
      final settings = await db.select(db.settings).get();
      final map = {for (var s in settings) s.key: s.value};
      if (mounted && map.containsKey('defaultPlaybackSpeed')) {
        final speed = double.tryParse(map['defaultPlaybackSpeed']!) ?? 1.0;
        setState(() {
          _playbackSpeed = speed;
          widget.animationData.setPlaybackSpeed(speed);
        });
        await _player.setRate(speed);
      }
    } catch (e) {
      debugPrint('Hız ayarı yüklenemedi: $e');
    }
  }

  Future<void> _initAndLoadAudio() async {
    if (_isAudioReady || _isInitializing) return;
    setState(() {
      _isInitializing = true;
    });
    try {
      final path = widget.animationData.audioPath;
      if (path == null || path.isEmpty) {
        debugPrint('Ses yolu boş');
        if (mounted) {
          setState(() => _isInitializing = false);
        }
        return;
      }
      debugPrint('Ses yükleniyor mpv: $path');
      await _player.open(Media(path));
      await _player.setRate(_playbackSpeed);
      if (mounted) {
        setState(() {
          _isAudioReady = true;
          _isInitializing = false;
        });
      }
    } catch (e) {
      debugPrint('Ses yükleme hatası: $e');
      if (mounted) {
        setState(() => _isInitializing = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ses yüklenemedi: $e')));
      }
    }
  }

  void _startAnimationTimer() {
    _animationTimer?.cancel();
    _animationTimer = Timer.periodic(const Duration(milliseconds: 16), (
      _,
    ) async {
      if (!mounted) return;
      try {
        if (_youtubeController != null) {
          final duration = await _youtubeController!.duration;
          final position = await _youtubeController!.currentTime;
          if (duration > 0) {
            _totalDuration = Duration(milliseconds: (duration * 1000).round());
            widget.animationData.totalDuration = _totalDuration;
          }
          if (!_isSeeking) {
            setState(() {
              _currentPosition = Duration(
                milliseconds: (position * 1000).round(),
              );
            });
            widget.animationData.update(position);
          }
        } else {
          if (_isPlaying && !_isSeeking) {
            final actualPos = _player.state.position;
            if (_lastSyncTime == null || actualPos != _lastSyncPos) {
              _lastSyncPos = actualPos;
              _lastSyncTime = DateTime.now();
            }
            final elapsed = DateTime.now().difference(_lastSyncTime!);
            final smoothMs =
                _lastSyncPos.inMilliseconds +
                (elapsed.inMilliseconds * _playbackSpeed);
            final smoothPos = Duration(milliseconds: smoothMs.round());
            setState(() {
              _currentPosition = smoothPos;
            });
            widget.animationData.update(smoothPos.inMilliseconds / 1000.0);
          } else if (!_isPlaying || _isSeeking) {
            _lastSyncTime = null;
            widget.animationData.update(
              _currentPosition.inMilliseconds / 1000.0,
            );
          }
        }
      } catch (e) {
        debugPrint('Timer hatası: $e');
      }
    });
  }

  void _onPlaybackComplete() {
    _player.pause();
    _player.seek(Duration.zero);
    if (mounted) {
      setState(() {
        _isPlaying = false;
        _currentPosition = _totalDuration;
      });
    }
  }

  Future<void> _togglePlay() async {
    if (_youtubeController != null) {
      if (_isPlaying) {
        await _youtubeController!.pauseVideo();
      } else {
        await _youtubeController!.playVideo();
      }
      setState(() => _isPlaying = !_isPlaying);
    } else {
      await _player.playOrPause();
    }
  }

  Future<void> _seek(Duration position) async {
    if (position < Duration.zero) position = Duration.zero;
    if (position > _totalDuration) position = _totalDuration;
    if (!_isSeeking) {
      setState(() {
        _isSeeking = true;
        _controlsVisible = true;
        _controlsHideTimer?.cancel();
      });
      _wasPlayingBeforeSeek = _isPlaying;
      if (_youtubeController != null) {
        if (_isPlaying) await _youtubeController!.pauseVideo();
      } else if (_isPlaying) {
        await _player.pause();
      }
    }
    setState(() {
      _currentPosition = position;
    });
    widget.animationData.update(position.inMilliseconds / 1000.0);
    try {
      if (_youtubeController != null) {
        await _youtubeController!.seekTo(
          seconds: position.inMilliseconds / 1000.0,
          allowSeekAhead: true,
        );
      } else {
        await _player.seek(position);
      }
    } catch (e) {
      debugPrint('Seek hatası: $e');
    }
  }

  void _onSeekEnd() {
    if (mounted) {
      setState(() {
        _isSeeking = false;
      });
      _startControlsHideTimer();
      if (_wasPlayingBeforeSeek) {
        if (_youtubeController != null) {
          _youtubeController!.playVideo();
        } else {
          _player.play();
        }
        _wasPlayingBeforeSeek = false;
      }
    }
  }

  void _onDragSeek(double deltaX, double screenWidth) {
    if (!_isLocked) return;
    if (!_isSeeking) {
      _wasPlayingBeforeSeek = _isPlaying;
      if (_isPlaying) {
        if (_youtubeController != null) {
          _youtubeController!.pauseVideo();
        } else {
          _player.pause();
        }
      }
      setState(() => _isSeeking = true);
    }
    final seekRatio = deltaX / screenWidth;
    final seekDuration = Duration(
      milliseconds: (seekRatio * _totalDuration.inMilliseconds).round(),
    );
    _seek(_currentPosition + seekDuration);
  }

  Future<void> _changeSpeed(double speed) async {
    setState(() {
      _playbackSpeed = speed;
      widget.animationData.setPlaybackSpeed(speed);
    });
    if (_youtubeController != null) {
      await _youtubeController!.setPlaybackRate(speed);
    } else {
      await _player.setRate(speed);
    }
  }

  void _toggleLock() {
    setState(() {
      _isLocked = !_isLocked;
    });
  }

  void _showSaveDialog(BuildContext context) {
    final sourceProvider = context.read<SourceProvider>();
    final question = widget.question;
    if (question == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Soru verisi bulunamadı.')));
      return;
    }
    final noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Soruyu Kaydet'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    labelText: 'Not Ekle (Opsiyonel)',
                    hintText: 'Soru ile ilgili bir not yazın...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Klasör Seç:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Consumer<SavedQuestionsProvider>(
                    builder: (context, provider, child) {
                      if (provider.folders.isEmpty) {
                        return const Text(
                          'Henüz klasör oluşturulmamış. Lütfen "Kaydedilenler" sekmesinden klasör oluşturun.',
                        );
                      }
                      return SingleChildScrollView(
                        child: _buildRecursiveFolderPicker(
                          context,
                          provider,
                          null,
                          sourceProvider,
                          question,
                          noteController,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kapat'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRecursiveFolderPicker(
    BuildContext context,
    SavedQuestionsProvider provider,
    int? parentId,
    SourceProvider sourceProvider,
    Question question,
    TextEditingController noteController,
  ) {
    final folders = provider.folders
        .where((f) => f.parentId == parentId)
        .toList();
    if (folders.isEmpty) return const SizedBox.shrink();
    return Column(
      children: folders.map((folder) {
        final hasChildren = provider.folders.any(
          (f) => f.parentId == folder.id,
        );
        return ExpansionTile(
          key: PageStorageKey<int>(folder.id),
          controlAffinity: ListTileControlAffinity.leading,
          leading: const Icon(Icons.folder_outlined),
          title: InkWell(
            onTap: () async {
              await provider.saveQuestion(
                folderId: folder.id,
                baseUrl: sourceProvider.baseUrl ?? '',
                scraperType: sourceProvider.currentSourceType,
                bookId: sourceProvider.navigationStack.isNotEmpty
                    ? sourceProvider.navigationStack.first.id
                    : '',
                chapterId: sourceProvider.currentCategoryId,
                breadcrumbs: sourceProvider.breadcrumbs,
                question: question,
                notes: noteController.text.trim().isNotEmpty
                    ? noteController.text.trim()
                    : null,
              );
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Soru başarıyla kaydedildi')),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              width: double.maxFinite,
              child: Text(folder.name),
            ),
          ),
          trailing: hasChildren ? null : const SizedBox.shrink(),
          children: [
            if (hasChildren)
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: _buildRecursiveFolderPicker(
                  context,
                  provider,
                  folder.id,
                  sourceProvider,
                  question,
                  noteController,
                ),
              ),
          ],
        );
      }).toList(),
    );
  }

  void _showReviewDialog(BuildContext context) {
    final provider = context.read<SavedQuestionsProvider>();
    final sq = widget.savedQuestion!;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Bu soruyu ne zaman tekrar etmek istersin?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            _buildReviewOption(context, provider, sq, '1 Gün', 1),
            _buildReviewOption(context, provider, sq, '3 Gün', 3),
            _buildReviewOption(context, provider, sq, '7 Gün', 7),
            _buildReviewOption(context, provider, sq, '14 Gün', 14),
            _buildReviewOption(context, provider, sq, '30 Gün', 30),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _buildReviewOption(
    BuildContext context,
    SavedQuestionsProvider provider,
    SavedQuestion sq,
    String label,
    int days,
  ) {
    return ListTile(
      title: Text(label),
      leading: const Icon(Icons.calendar_today_outlined),
      onTap: () async {
        final nextDate = DateTime.now().add(Duration(days: days));
        await provider.updateReviewStatus(sq.id, nextDate, sq.reviewStep + 1);
        if (context.mounted) {
          Navigator.pop(context);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Soru $label sonraya ertelendi.')),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _animationTimer?.cancel();
    _controlsHideTimer?.cancel();
    _youtubeController?.close();
    _player.dispose();
    final transcriptionProvider = Provider.of<TranscriptionProvider>(
      context,
      listen: false,
    );
    transcriptionProvider.reset();
    super.dispose();
  }

  void _toggleTranscription(TranscriptionProvider provider) {
    provider.togglePanel();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final transcriptionProvider = Provider.of<TranscriptionProvider>(context);
    final isDarkMode = themeProvider.playerContentDarkMode;
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;
          final isOpen = transcriptionProvider.isPanelOpen;
          final double panelSize = isPortrait ? 250.0 : 320.0;
          final Size screenSize = MediaQuery.of(context).size;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                top: isPortrait ? (isOpen ? panelSize : 0) : 0,
                bottom: 0,
                left: 0,
                right: isPortrait ? 0 : (isOpen ? panelSize : 0),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: _toggleControls,
                        onLongPressStart: !_isLocked
                            ? (details) {
                                _wasPlayingBeforeSeek = _isPlaying;
                                if (_isPlaying) _player.pause();
                                setState(() {
                                  _isSeeking = true;
                                  _lastLongPressX = details.globalPosition.dx;
                                });
                              }
                            : null,
                        onLongPressMoveUpdate: !_isLocked
                            ? (details) {
                                final delta =
                                    details.globalPosition.dx -
                                    _lastLongPressX!;
                                _lastLongPressX = details.globalPosition.dx;
                                final seekRatio =
                                    delta / MediaQuery.of(context).size.width;
                                final seekDuration = Duration(
                                  milliseconds:
                                      (seekRatio *
                                              _totalDuration.inMilliseconds)
                                          .round(),
                                );
                                _seek(_currentPosition + seekDuration);
                              }
                            : null,
                        onLongPressEnd: !_isLocked
                            ? (_) {
                                _lastLongPressX = null;
                                _onSeekEnd();
                              }
                            : null,
                        onHorizontalDragStart: _isLocked
                            ? (_) {
                                _wasPlayingBeforeSeek = _isPlaying;
                                if (_isPlaying) _player.pause();
                                setState(() => _isSeeking = true);
                              }
                            : null,
                        onHorizontalDragUpdate: _isLocked
                            ? (details) {
                                _onDragSeek(
                                  details.delta.dx,
                                  MediaQuery.of(context).size.width,
                                );
                              }
                            : null,
                        onHorizontalDragEnd: _isLocked
                            ? (_) => _onSeekEnd()
                            : null,
                        child: Container(
                          color: isDarkMode ? Colors.black : Colors.white,
                          child: DrawingCanvas(
                            key: _canvasKey,
                            objects: widget.animationData.getActiveObjects(),
                            animationData: widget.animationData,
                            enableInteraction: !_isLocked,
                            videoController: _videoController,
                            youtubeController: _youtubeController,
                            isDarkMode: isDarkMode,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 16,
                      child: FloatingActionButton(
                        mini: true,
                        heroTag: 'back',
                        backgroundColor: Colors.black.withOpacity(0.5),
                        foregroundColor: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(Icons.arrow_back),
                      ),
                    ),
                    if (widget.question != null)
                      Positioned(
                        top: 40,
                        right: 16,
                        child: FloatingActionButton(
                          mini: true,
                          heroTag: 'save_or_review',
                          backgroundColor: Colors.black.withOpacity(0.5),
                          foregroundColor: Colors.white,
                          onPressed: () => widget.savedQuestion != null
                              ? _showReviewDialog(context)
                              : _showSaveDialog(context),
                          child: Icon(
                            widget.savedQuestion != null
                                ? Icons.check_box
                                : Icons.bookmark_add,
                          ),
                        ),
                      ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: PlayerControls(
                        isPlaying: _isPlaying,
                        currentPosition: _currentPosition,
                        totalDuration: _totalDuration,
                        playbackSpeed: _playbackSpeed,
                        isSeeking: _isSeeking,
                        isLocked: _isLocked,
                        hasNextVideo: widget.hasNextVideo,
                        hasPreviousVideo: widget.hasPreviousVideo,
                        onPlayPause: _togglePlay,
                        onLockToggle: _toggleLock,
                        onSeek: _seek,
                        onSeekEnd: _onSeekEnd,
                        onSpeedChange: _changeSpeed,
                        onNextVideo: widget.onNextVideo,
                        onPreviousVideo: widget.onPreviousVideo,
                        hasAudio: widget.animationData.hasAudio,
                        isLongPressSeeking: _lastLongPressX != null,
                        visible: _controlsVisible,
                        onInteraction: _resetControlsHideTimer,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                top: isPortrait ? (isOpen ? 0 : -panelSize) : 0,
                bottom: isPortrait ? null : 0,
                left: isPortrait ? 0 : null,
                right: isPortrait ? 0 : (isOpen ? 0 : -panelSize),
                height: isPortrait ? panelSize : null,
                width: isPortrait ? null : panelSize,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      if (isOpen)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: isPortrait
                              ? const Offset(0, 4)
                              : const Offset(-4, 0),
                        ),
                    ],
                  ),
                  child: _buildTranscriptionContent(transcriptionProvider),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                left: isPortrait ? (screenSize.width / 2 - 30) : null,
                top: isPortrait ? (isOpen ? panelSize : 0) : null,
                right: isPortrait ? null : (isOpen ? panelSize : 0),
                bottom: isPortrait ? null : (screenSize.height / 2 - 30),
                child: GestureDetector(
                  onTap: () => _toggleTranscription(transcriptionProvider),
                  child: Container(
                    width: isPortrait ? 60 : 36,
                    height: isPortrait ? 30 : 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withOpacity(0.85),
                      borderRadius: isPortrait
                          ? const BorderRadius.vertical(
                              bottom: Radius.circular(16),
                            )
                          : const BorderRadius.horizontal(
                              left: Radius.circular(16),
                            ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 4,
                          offset: isPortrait
                              ? const Offset(0, 2)
                              : const Offset(-2, 0),
                        ),
                      ],
                    ),
                    child: Icon(
                      isPortrait
                          ? (isOpen
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down)
                          : (isOpen
                                ? Icons.keyboard_arrow_right
                                : Icons.keyboard_arrow_left),
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTranscriptionContent(TranscriptionProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 8, 6),
          child: Row(
            children: [
              const Text(
                'Transkripsiyon',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const Spacer(),
              if (provider.transcriptionText.isNotEmpty &&
                  !provider.isProcessing)
                IconButton(
                  icon: const Icon(Icons.refresh, size: 18),
                  tooltip: 'Yeniden isle',
                  onPressed: () {
                    final mediaUrl =
                        widget.animationData.videoUrl ??
                        widget.animationData.audioPath;
                    if (mediaUrl != null) {
                      provider.processTranscription(mediaUrl);
                    }
                  },
                ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: provider.transcriptionText.isEmpty && !provider.isProcessing
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.subtitles_outlined,
                        size: 36,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          final mediaUrl =
                              widget.animationData.videoUrl ??
                              widget.animationData.audioPath;
                          if (mediaUrl != null) {
                            provider.processTranscription(mediaUrl);
                          }
                        },
                        child: const Text('Metne Dönüştür'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (provider.isProcessing)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      if (provider.subtitles.isNotEmpty)
                        Wrap(
                          spacing: 4.0,
                          runSpacing: 6.0,
                          children: provider.subtitles.map((chunk) {
                            final double currentSeconds =
                                _currentPosition.inMilliseconds / 1000.0;
                            final bool isActive =
                                currentSeconds >= chunk.startTime &&
                                currentSeconds <= chunk.endTime;
                            return InkWell(
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? Colors.white.withOpacity(0.2)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  chunk.text,
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: isActive
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.6),
                                    fontWeight: isActive
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      else if (!provider.isProcessing)
                        Text(
                          provider.transcriptionText,
                          style: const TextStyle(fontSize: 13, height: 1.6),
                        ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
