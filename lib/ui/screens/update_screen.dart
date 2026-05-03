import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../../services/update_service.dart';
import '../widgets/permission_settings_widget.dart';
import 'dart:io';

class UpdateScreen extends StatefulWidget {
  final Map<String, dynamic>? releaseData;

  const UpdateScreen({super.key, this.releaseData});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  double? _downloadProgress;
  bool _isDownloading = false;
  String? _errorMessage;
  bool _showErrorDetails = false;
  bool _isDone = false;
  String _currentFrequency = 'weekly';

  @override
  void initState() {
    super.initState();
    _loadFrequency();
    if (UpdateService.isDownloading) {
      _isDownloading = true;
      _downloadProgress = UpdateService.downloadProgress.value;
      UpdateService.downloadProgress.addListener(_onGlobalProgressChange);
    }
  }

  void _onGlobalProgressChange() {
    if (mounted) {
      setState(() {
        _downloadProgress = UpdateService.downloadProgress.value;
        if (_downloadProgress == null && !UpdateService.isDownloading) {
          _isDownloading = false;
          if (UpdateService.downloadedApkPath != null) _isDone = true;
        }
      });
    }
  }

  @override
  void dispose() {
    UpdateService.downloadProgress.removeListener(_onGlobalProgressChange);
    super.dispose();
  }

  Future<void> _loadFrequency() async {
    final freq = await UpdateService.getFrequency();
    if (mounted) setState(() => _currentFrequency = freq);
  }

  Future<void> _setFrequency(String freq) async {
    await UpdateService.setFrequency(freq);
    setState(() => _currentFrequency = freq);
  }

  void _cancelUpdate() {
    UpdateService.cancelDownload();
    setState(() {
      _isDownloading = false;
      _downloadProgress = null;
    });
  }

  void _startUpdate() async {
    if (widget.releaseData == null) return;
    final assets = widget.releaseData!['assets'] as List<dynamic>;
    final downloadUrl = await UpdateService.findMatchingAsset(assets);

    if (downloadUrl == null) {
      setState(() => _errorMessage = 'Cihazınıza uygun bir APK bulunamadı.');
      return;
    }

    setState(() {
      _isDownloading = true;
      _errorMessage = null;
    });

    try {
      UpdateService.downloadProgress.addListener(_onGlobalProgressChange);
      await UpdateService.downloadAndInstall(
        url: downloadUrl,
        onProgress: (progress) {
          if (mounted) setState(() => _downloadProgress = progress);
        },
      );
      if (mounted)
        setState(() {
          _isDownloading = false;
          _isDone = true;
        });
    } catch (e) {
      if (mounted)
        setState(() {
          _isDownloading = false;
          _errorMessage = e.toString();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isUpToDate = widget.releaseData == null;
    final tagName = widget.releaseData?['tag_name'] as String?;
    final body = widget.releaseData?['body'] as String?;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Veri & Yedekleme'),
        titleTextStyle: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.7),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colorScheme.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isUpToDate
                              ? Icons.check_circle_outline_rounded
                              : Icons.system_update_outlined,
                          size: 28,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isUpToDate ? 'Sistem Güncel' : 'Sürüm $tagName',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isUpToDate
                                    ? 'En son sürümü kullanıyorsunuz.'
                                    : 'Yeni özellikler ve iyileştirmeler hazır.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (!isUpToDate && body != null) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Neler Değişti',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: MarkdownBody(
                        data: body,
                        selectable: true,
                        styleSheet: MarkdownStyleSheet.fromTheme(theme)
                            .copyWith(
                              p: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.6,
                                color: colorScheme.onSurface,
                              ),
                              h1: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              h2: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              listBullet: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),
                  Text(
                    'İzinler',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const PermissionSettingsWidget(),
                  const SizedBox(height: 16),
                  _buildFrequencyTile(theme, colorScheme),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: InkWell(
                onTap: () =>
                    setState(() => _showErrorDetails = !_showErrorDetails),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.error.withOpacity(0.4),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            color: colorScheme.error,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Bir hata oluştu.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            _showErrorDetails
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: colorScheme.error,
                            size: 18,
                          ),
                        ],
                      ),
                      if (_showErrorDetails) ...[
                        const SizedBox(height: 10),
                        SelectableText(
                          _errorMessage!,
                          style: TextStyle(
                            color: colorScheme.error,
                            fontSize: 11,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

          if (!isUpToDate)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: _isDone || UpdateService.downloadedApkPath != null
                  ? FilledButton.icon(
                      onPressed: () => UpdateService.installApk(
                        UpdateService.downloadedApkPath!,
                      ),
                      icon: const Icon(Icons.install_mobile_outlined),
                      label: const Text('Şimdi Kur'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    )
                  : _isDownloading
                  ? Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: _downloadProgress,
                            minHeight: 6,
                            backgroundColor: colorScheme.surfaceContainerHigh,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _downloadProgress == null
                                  ? 'Bağlantı kuruluyor...'
                                  : 'İndiriliyor: %${(_downloadProgress! * 100).toInt()}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: _cancelUpdate,
                              icon: const Icon(Icons.close_rounded, size: 16),
                              label: const Text('İptal'),
                              style: TextButton.styleFrom(
                                foregroundColor: colorScheme.error,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : FilledButton.icon(
                      onPressed: _startUpdate,
                      icon: const Icon(Icons.download_outlined),
                      label: const Text('Güncellemeyi İndir'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
            ),
        ],
      ),
    );
  }

  Widget _buildFrequencyTile(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(
            Icons.update_outlined,
            size: 20,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Denetleme Sıklığı',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Otomatik kontrol aralığı',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          DropdownButton<String>(
            value: _currentFrequency,
            underline: const SizedBox(),
            borderRadius: BorderRadius.circular(12),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
            items: const [
              DropdownMenuItem(value: 'daily', child: Text('Günlük')),
              DropdownMenuItem(value: 'every3days', child: Text('3 Günde Bir')),
              DropdownMenuItem(value: 'weekly', child: Text('Haftalık')),
              DropdownMenuItem(value: 'monthly', child: Text('Aylık')),
              DropdownMenuItem(value: 'manual', child: Text('Manuel')),
            ],
            onChanged: (val) {
              if (val != null) _setFrequency(val);
            },
          ),
        ],
      ),
    );
  }
}
