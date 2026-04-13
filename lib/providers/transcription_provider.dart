import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:audio_decoder/audio_decoder.dart';

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

  void cancelAndClear({bool notify = true}) {
    _isCancelled = true;
    _isProcessing = false;
    _transcriptionText = "";
    _subtitles = [];
    if (notify) notifyListeners();
  }

  void reset({bool notify = true}) {
    _isPanelOpen = false;
    cancelAndClear(notify: notify);
  }

  Future<void> processTranscription(
    String mediaUrl, {
    bool sendAsChunks = true,
  }) async {
    if (_isProcessing) return;

    _isCancelled = false;
    _isProcessing = true;
    _transcriptionText = "Altyazılar getiriliyor...";
    _subtitles = [];
    notifyListeners();

    try {
      final result = await _extractAudio(mediaUrl, sendAsChunks: sendAsChunks);
      if (_isCancelled) return;

      final chunkPaths = result["paths"] as List<String>;
      final splitPoints = result["points"] as List<double>;
      final actualRate = result["rate"] as int;
      final totalLen = result["totalLen"] as double;
      final originalFilePath = result["originalFilePath"] as String;
      final originalFile = File(originalFilePath);
      if (chunkPaths.isNotEmpty) {
        _transcriptionText = "Parçalara ayrıldı \nSunucuya gönderiliyor.";
        notifyListeners();

        await _processChunksWithGoogleV2(
          chunkPaths,
          splitPoints,
          actualRate,
          totalLen,
        );

        for (var path in chunkPaths) {
          final tempFile = File(path);
          if (await tempFile.exists()) {
            await tempFile.delete();
          }
        }

        if (await originalFile.exists()) {
          await originalFile.delete();
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

  Future<Map<String, dynamic>> _extractAudio(
    String mediaUrl, {
    bool sendAsChunks = true,
  }) async {
    final tempDirectory = await getTemporaryDirectory();
    final originalFileName = Uri.parse(mediaUrl).pathSegments.last;
    final originalfilePath = "${tempDirectory.path}/$originalFileName";

    final response = await http.get(Uri.parse(mediaUrl));
    if (response.statusCode == 200) {
      final file = File(originalfilePath);
      await file.writeAsBytes(response.bodyBytes);
    }
    debugPrint("Dosya indirildi");

    final audioInfo = await AudioDecoder.getAudioInfo(originalfilePath);
    final int actualRate = audioInfo.sampleRate;
    final double audiolength = audioInfo.duration.inMilliseconds / 1000.0;
    debugPrint("AudioInfo: rate=$actualRate, length=$audiolength");

    final double segmentSize = 60.0;
    List<double> fullWaveForm = [];
    int segmentIndex = 0;

    double segStart = 0.0;
    while (segStart < audiolength) {
      final double segEnd = (segStart + segmentSize).clamp(0.0, audiolength);
      final double segDuration = segEnd - segStart;

      final String tempSegPath =
          '${tempDirectory.path}/temp_seg_$segmentIndex.wav';

      await AudioDecoder.trimAudio(
        originalfilePath,
        tempSegPath,
        Duration(milliseconds: (segStart * 1000).toInt()),
        Duration(milliseconds: (segEnd * 1000).toInt()),
      );

      final int sampleCount = (segDuration * 10).toInt();
      final segWaveForm = await AudioDecoder.getWaveform(
        tempSegPath,
        numberOfSamples: sampleCount,
      );

      fullWaveForm.addAll(segWaveForm);

      final tempSeg = File(tempSegPath);
      if (await tempSeg.exists()) await tempSeg.delete();

      segStart += segmentSize;
      segmentIndex++;
    }
    debugPrint("Waveform birleştirildi: ${fullWaveForm.length} örnek");

    int thresholdCounter = 0;
    double lastSplitTime = 0;
    List<double> splitPoints = [0.0];
    List<String> chunkPaths = [];

    if (sendAsChunks) {
      for (int i = 0; i < fullWaveForm.length; i++) {
        double currentTime = i / 10.0;

        if (thresholdCounter < 4) {
          if (currentTime - lastSplitTime >= 3 && fullWaveForm[i] < 0.1) {
            thresholdCounter++;
          } else {
            thresholdCounter = 0;
          }
        } else if (currentTime - lastSplitTime > 20) {
          splitPoints.add(currentTime);
          lastSplitTime = currentTime;
          thresholdCounter = 0;
        } else {
          lastSplitTime = currentTime;
          splitPoints.add(currentTime);
          thresholdCounter = 0;
        }
      }
    } else {
      debugPrint("Parçalama kapalı, tek dosya olarak ayıklanıyor...");
    }

    debugPrint("Split noktaları: $splitPoints");

    for (int i = 0; i < splitPoints.length; i++) {
      final double startSec = splitPoints[i];
      final double endSec = (i == splitPoints.length - 1)
          ? audiolength
          : splitPoints[i + 1];

      if (endSec <= startSec) {
        debugPrint("Clip $i atlandı: geçersiz aralık ($startSec → $endSec)");
        continue;
      }

      final int startMs = (startSec * 1000).toInt();
      final int endMs = (endSec * 1000).toInt().clamp(
        0,
        (audiolength * 1000).toInt(),
      );
      final String outPath = '${tempDirectory.path}/clip_$i.wav';

      debugPrint("Clip $i: $startMs ms → $endMs ms");
      await AudioDecoder.trimAudio(
        originalfilePath,
        outPath,
        Duration(milliseconds: startMs),
        Duration(milliseconds: endMs),
      );
      chunkPaths.add(outPath);
    }

    debugPrint("${chunkPaths.length} clip oluşturuldu");

    return {
      "originalFilePath": originalfilePath,
      "paths": chunkPaths,
      "points": splitPoints,
      "rate": actualRate,
      "totalLen": audiolength,
    };
  }

  Future<void> _processChunksWithGoogleV2(
    List<String> chunkPaths,
    List<double> splitPoints,
    int rate,
    double totalLen,
  ) async {
    final String language = "tr";

    final url = Uri.parse(
      "http://www.google.com/speech-api/v2/recognize?client=chromium&lang=$language&key=$_apiKey",
    );

    List<Future<void>> futures = [];

    for (int i = 0; i < chunkPaths.length; i++) {
      double start = splitPoints[i];
      double end = (i == splitPoints.length - 1)
          ? totalLen
          : splitPoints[i + 1];
      double duration = end - start;

      futures.add(
        _processSingleChunk(chunkPaths[i], start, duration, url, rate),
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
        headers: {"Content-Type": "audio/l16; rate=$rate"},
        body: bytes.length > 44 ? bytes.sublist(44) : bytes,
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
        int existingIndex = _subtitles.indexWhere(
          (s) => s.startTime == startTime,
        );

        if (existingIndex != -1) {
          _subtitles[existingIndex] = SubtitleChunk(
            startTime: startTime,
            endTime: startTime + duration,
            text: chunkText.trim(),
          );
        } else {
          _subtitles.add(
            SubtitleChunk(
              startTime: startTime,
              endTime: startTime + duration,
              text: chunkText.trim(),
            ),
          );
        }

        _subtitles.sort((a, b) => a.startTime.compareTo(b.startTime));
        _transcriptionText = _subtitles.map((chunk) => chunk.text).join(' ');

        notifyListeners();
      }
    } catch (e) {
      debugPrint("Api Hatası $startTime: $e");
    }
  }
}
