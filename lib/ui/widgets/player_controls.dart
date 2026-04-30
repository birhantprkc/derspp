import 'package:flutter/material.dart';

class PlayerControls extends StatelessWidget {
  final bool isPlaying;
  final Duration currentPosition;
  final Duration totalDuration;
  final double playbackSpeed;
  final bool isSeeking;
  final bool isLocked;
  final bool hasNextVideo;
  final bool hasPreviousVideo;
  final VoidCallback onPlayPause;
  final VoidCallback onLockToggle;
  final Function(Duration) onSeek;
  final VoidCallback onSeekEnd;
  final Function(double) onSpeedChange;
  final VoidCallback? onNextVideo;
  final VoidCallback? onPreviousVideo;
  final bool hasAudio;
  final bool isLongPressSeeking;
  final bool visible;
  final VoidCallback onInteraction;

  const PlayerControls({
    super.key,
    required this.isPlaying,
    required this.currentPosition,
    required this.totalDuration,
    required this.playbackSpeed,
    required this.isSeeking,
    required this.isLocked,
    this.hasNextVideo = false,
    this.hasPreviousVideo = false,
    required this.onPlayPause,
    required this.onLockToggle,
    required this.onSeek,
    required this.onSeekEnd,
    required this.onSpeedChange,
    this.onNextVideo,
    this.onPreviousVideo,
    required this.hasAudio,
    this.isLongPressSeeking = false,
    required this.visible,
    required this.onInteraction,
  });

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0
        ? '${twoDigits(duration.inHours)}:$minutes:$seconds'
        : '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !visible && !isLongPressSeeking,
      child: AnimatedOpacity(
        opacity: visible || isLongPressSeeking ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: _buildControls(context),
      ),
    );
  }

  Widget _buildControls(BuildContext context) {
    if (isLongPressSeeking) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.65),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${_formatDuration(currentPosition)} / ${_formatDuration(totalDuration)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(height: 20, child: _buildProgressBar(context)),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.65),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildProgressBar(context),
          const SizedBox(height: 4),
          _buildControlRow(context),
          const SizedBox(height: 4),
          _buildInfoText(context),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    final max = totalDuration.inMilliseconds > 0
        ? totalDuration.inMilliseconds.toDouble()
        : 1.0;
    final value = currentPosition.inMilliseconds.toDouble().clamp(0.0, max);

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 2,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
      ),
      child: Slider(
        value: value,
        max: max,
        inactiveColor: Colors.white.withOpacity(0.2),
        onChangeStart: (_) {
          onInteraction();
        },
        onChanged: (v) {
          onInteraction();
          onSeek(Duration(milliseconds: v.toInt()));
        },
        onChangeEnd: (v) {
          onInteraction();
          onSeekEnd();
        },
      ),
    );
  }

  Widget _buildInfoText(BuildContext context) {
    final textStyle = Theme.of(
      context,
    ).textTheme.labelSmall?.copyWith(color: Colors.white70);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(_formatDuration(currentPosition), style: textStyle),
        if (isLocked)
          Text(
            '',
            style: textStyle?.copyWith(
              color: Colors.orange.shade200,
              fontSize: 10,
            ),
          ),
        Text(_formatDuration(totalDuration), style: textStyle),
      ],
    );
  }

  Widget _buildControlRow(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () {
            onInteraction();
            onLockToggle();
          },
          icon: Icon(
            isLocked ? Icons.lock : Icons.lock_open,
            color: isLocked
                ? theme.colorScheme.primary.withOpacity(0.7)
                : Colors.white.withOpacity(0.7),
          ),
          tooltip: isLocked ? 'Kilidi Aç' : 'Kilitle',
        ),

        IconButton(
          onPressed: hasPreviousVideo
              ? () {
                  onInteraction();
                  onPreviousVideo?.call();
                }
              : null,
          icon: Icon(
            Icons.skip_previous,
            color: hasPreviousVideo
                ? Colors.white
                : Colors.white.withOpacity(0.3),
          ),
          tooltip: 'Önceki Video',
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.7),
          ),
          child: IconButton(
            iconSize: 32,
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.black,
            ),
            onPressed: () {
              onInteraction();
              onPlayPause();
            },
          ),
        ),
        IconButton(
          onPressed: hasNextVideo
              ? () {
                  onInteraction();
                  onNextVideo?.call();
                }
              : null,
          icon: Icon(
            Icons.skip_next,
            color: hasNextVideo ? Colors.white : Colors.white.withOpacity(0.3),
          ),
          tooltip: 'Sonraki Video',
        ),
        PopupMenuButton<double>(
          color: Colors.grey.shade900,
          position: PopupMenuPosition.over,
          icon: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SizedBox(
              width: 45,
              child: Center(
                child: Text(
                  '${playbackSpeed}x',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          onSelected: (speed) {
            onInteraction();
            onSpeedChange(speed);
          },
          itemBuilder: (context) => [
            for (final s in [0.5, 1.0, 1.25, 1.5, 1.75, 2.0])
              PopupMenuItem(
                value: s,
                child: Text(
                  '${s}x',
                  style: TextStyle(
                    color: s == playbackSpeed
                        ? theme.colorScheme.primary
                        : Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
