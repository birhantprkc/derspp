import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'dart:convert';
import 'package:flutter_ffmpeg_kit_full/ffmpeg_kit.dart';
import 'package:flutter_ffmpeg_kit_full/return_code.dart';
import 'package:flutter_ffmpeg_kit_full/session_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class SubtitleChunk {
  final double startTime;
  final double endTime;
  final String text;

  SubtitleChunk({
    required this.startTime,
    required this.endTime,
    required this.text,
  });
}

class TranscriptionProvider with ChangeNotifier {
  bool _isPanelOpen = false;
  bool _isProcessing = false;
  bool _isCancelled = false;
  String _transcriptionText = "";
  List<SubtitleChunk> _subtitles = [];

  final String _apiKey =
      "AIzaSyBOti4mM-6x9WDnZIjIeyEU21OpBXqWBgw"; // fre api from somewhere no one knows

  bool get isPanelOpen => _isPanelOpen;
  bool get isProcessing => _isProcessing;
  String get transcriptionText => _transcriptionText;
  List<SubtitleChunk> get subtitles => _subtitles;

  void togglePanel() {
    _isPanelOpen = !_isPanelOpen;
    notifyListeners();
  }

  void cancelAndClear() {
    _isCancelled = true;
    _isProcessing = false;
    _transcriptionText = "";
    _subtitles = [];
    FFmpegKit.cancel();
    notifyListeners();
  }

  void reset() {
    _isPanelOpen = false;
    cancelAndClear();
  }

  Future<void> processTranscription(String mediaUrl) async {
    if (_isProcessing) return;

    _isCancelled = false;

    if (kIsWeb) {
      _transcriptionText =
          "Webde ffmeg şuanlık desteklenmediğinden dolayı transkripsiyn kullanılamamaktadır. Lütfen native uygulamayı kullanın.";
      notifyListeners();
      return;
    }

    _isProcessing = true;
    _transcriptionText = "Ses ayıklanıyor...";
    _subtitles = [];
    notifyListeners();

    try {
      final chunkPaths = await _extractAndChunkAudioToFlac(mediaUrl);

      if (_isCancelled) return;

      if (chunkPaths.isNotEmpty) {
        _transcriptionText = "Çevriliyor...";
        notifyListeners();

        await _processChunksWithGoogleV2(chunkPaths);

        for (var path in chunkPaths) {
          final tempFile = File(path);
          if (await tempFile.exists()) {
            await tempFile.delete();
          }
        }
      } else {
        if (!_isCancelled) {
          _transcriptionText = "Ses ayıklanamadı";
        }
      }
    } catch (e) {
      if (!_isCancelled) {
        _transcriptionText = "Hata oluştu: $e";
      }
    } finally {
      if (!_isCancelled) {
        _isProcessing = false;
        notifyListeners();
      }
    }
  }

  Future<List<String>> _extractAndChunkAudioToFlac(String mediaUrl) async {
    final directory = await getTemporaryDirectory();
    final outputPattern =
        '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}_%03d.flac';

    final List<String> ffmpegArgs = [
      '-y',
      '-i',
      mediaUrl,
      '-vn',
      '-af',
      'adelay=500|500,apad=pad_dur=0.5',
      '-acodec',
      'flac',
      '-ar',
      '48000',
      '-ac',
      '1',
      '-f',
      'segment',
      '-segment_time',
      '10',
      outputPattern,
    ];

    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final command = ffmpegArgs
            .map((a) => a.contains('http') ? '"$a"' : a)
            .join(' ');

        final session = await FFmpegKit.executeAsync(command);

        while (!await session.getState().then(
          (state) =>
              state == SessionState.completed || state == SessionState.failed,
        )) {
          if (_isCancelled) {
            await FFmpegKit.cancel();
            return [];
          }
          await Future.delayed(const Duration(milliseconds: 500));
        }

        final returnCode = await session.getReturnCode();
        if (ReturnCode.isSuccess(returnCode)) {
          return _getGeneratedChunks(directory.path, outputPattern);
        }
      } else if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
        final result = await Process.run('ffmpeg', ffmpegArgs);
        if (result.exitCode == 0) {
          return _getGeneratedChunks(directory.path, outputPattern);
        }
      }
    } catch (e) {
      debugPrint('Ffmpeg hatasi: $e');
    }

    return [];
  }

  List<String> _getGeneratedChunks(String dirPath, String pattern) {
    final basePrefix = pattern.split('_%03d.flac').first;
    final dir = Directory(dirPath);
    final List<String> chunkPaths = [];

    if (dir.existsSync()) {
      final files = dir.listSync().whereType<File>().toList();
      files.sort((a, b) => a.path.compareTo(b.path));

      for (var file in files) {
        if (file.path.startsWith(basePrefix) && file.path.endsWith('.flac')) {
          chunkPaths.add(file.path);
        }
      }
    }
    return chunkPaths;
  }

  Future<void> _processChunksWithGoogleV2(List<String> chunkPaths) async {
    final int rate = 48000;
    final String language = "tr";

    final url = Uri.parse(
      "http://www.google.com/speech-api/v2/recognize?client=chromium&lang=$language&key=$_apiKey",
    );

    final double chunkDuration = 10.0;
    List<Future<void>> futures = [];

    for (int i = 0; i < chunkPaths.length; i++) {
      double currentStartTime = i * chunkDuration;
      futures.add(
        _processSingleChunk(
          chunkPaths[i],
          currentStartTime,
          chunkDuration,
          url,
          rate,
        ),
      );
    }

    await Future.wait(futures);

    if (_isCancelled) return;

    if (_subtitles.isEmpty) {
      _transcriptionText = "Konuşma algılanamadı.";
      notifyListeners();
    }
  }

  Future<void> _processSingleChunk(
    String path,
    double startTime,
    double duration,
    Uri url,
    int rate,
  ) async {
    if (_isCancelled) return;

    try {
      final bytes = await File(path).readAsBytes();

      final response = await http.post(
        url,
        headers: {"Content-Type": "audio/x-flac; rate=$rate"},
        body: bytes,
      );

      if (_isCancelled) return;

      String chunkText = "";
      bool foundTranscript = false;

      final lines = response.body.split('\n');
      for (var line in lines) {
        if (line.trim().isEmpty) continue;

        try {
          final data = jsonDecode(line);
          if (data['result'] != null && (data['result'] as List).isNotEmpty) {
            final alternatives = data['result'][0]['alternative'];
            if (alternatives != null && (alternatives as List).isNotEmpty) {
              final transcript = alternatives[0]['transcript'] as String?;
              if (transcript != null && transcript.isNotEmpty) {
                chunkText =
                    transcript[0].toUpperCase() + transcript.substring(1);
                foundTranscript = true;
              }
            }
          }
        } catch (e) {
          continue;
        }
      }

      if (foundTranscript && chunkText.isNotEmpty && !_isCancelled) {
        _subtitles.add(
          SubtitleChunk(
            startTime: startTime,
            endTime: startTime + duration,
            text: chunkText.trim(),
          ),
        );

        _subtitles.sort((a, b) => a.startTime.compareTo(b.startTime));
        _transcriptionText = _subtitles.map((chunk) => chunk.text).join(' ');

        notifyListeners();
      }
    } catch (e) {
      debugPrint("Api Hatası $startTime: $e");
    }
  }
}
