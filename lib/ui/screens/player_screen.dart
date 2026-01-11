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
import '../widgets/drawing_canvas.dart';
import '../widgets/player_controls.dart';
import '../../providers/theme_provider.dart';

class PlayerScreen extends StatefulWidget {
  final AnimationModel animationData;
  final VoidCallback? onNextVideo;
  final VoidCallback? onPreviousVideo;
  final bool hasNextVideo;
  final bool hasPreviousVideo;

  const PlayerScreen({
    super.key,
    required this.animationData,
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
      await _player.setVolume(100.0);

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
      await _player.setVolume(320.0);

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

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _animationTimer?.cancel();
    _controlsHideTimer?.cancel();
    _youtubeController?.close();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.playerContentDarkMode;

    return Scaffold(
      body: Stack(
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
                          details.globalPosition.dx - _lastLongPressX!;
                      _lastLongPressX = details.globalPosition.dx;

                      final seekRatio =
                          delta / MediaQuery.of(context).size.width;
                      final seekDuration = Duration(
                        milliseconds:
                            (seekRatio * _totalDuration.inMilliseconds).round(),
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
              onHorizontalDragEnd: _isLocked ? (_) => _onSeekEnd() : null,
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
    );
  }
}
