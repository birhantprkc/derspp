import 'dart:async';
import 'dart:convert';
import 'package:media_kit/media_kit.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import '../../providers/saved_questions_provider.dart';
import '../../providers/pdf_export_provider.dart';
import '../../providers/source_provider.dart';
import '../../models/question.dart';
import '../../database/database.dart';
import '../../services/download_service.dart';
import '../../services/source_factory.dart';
import '../../services/f2_source_service.dart';
import '../../models/animation_model.dart';
import '../../models/source_item.dart';
import '../widgets/activity_heatmap.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'player_screen.dart';
import 'explorer_screen.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int? _selectedFolderId;
  String? _selectedFolderName;
  Map<int, Map<String, int>> _folderStats = {};
  SavedQuestionsProvider? _provider;

  final Set<int> _selectedFolderIdsForPdf = {};
  String _pdfFilter = 'both';
  int _pdfColumns = 2;
  String _pdfName = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newProvider = Provider.of<SavedQuestionsProvider>(
      context,
      listen: false,
    );
    if (_provider != newProvider) {
      _provider?.removeListener(_refreshFolderStats);
      _provider = newProvider;
      _provider!.addListener(_refreshFolderStats);
      _refreshFolderStats();
    }
  }

  @override
  void dispose() {
    _provider?.removeListener(_refreshFolderStats);
    super.dispose();
  }

  Future<void> _refreshFolderStats() async {
    final provider = Provider.of<SavedQuestionsProvider>(
      context,
      listen: false,
    );
    final stats = await provider.getAllFolderStats();
    if (mounted) {
      setState(() {
        _folderStats = stats;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SavedQuestionsProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        centerTitle: false,
        title: Text(_selectedFolderName ?? 'Kaydedilenler'),
        titleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          fontSize: 20,
        ),
        leading: _selectedFolderId != null
            ? IconButton(
                icon: const Icon(Icons.chevron_left, size: 28),
                onPressed: () {
                  setState(() {
                    _selectedFolderId = null;
                    _selectedFolderName = null;
                  });
                },
              )
            : null,
        actions: const [],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _selectedFolderId == null
                ? _buildFolderTree(provider, null)
                : _buildQuestionList(provider),
          ),
          if (_selectedFolderId == null) _buildStatsPanel(context, provider),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'pdf_export',
            elevation: 2,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
            onPressed: _showPdfExportDialog,
            child: const Icon(Icons.assignment_outlined),
          ),
          if (_selectedFolderId == null) ...[
            const SizedBox(height: 12),
            FloatingActionButton.small(
              heroTag: 'add_folder',
              elevation: 0,
              highlightElevation: 0,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
              onPressed: () => _showCreateFolderDialog(context, provider, null),
              child: const Icon(Icons.add),
            ),
          ],
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color color, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildStatsPanel(
    BuildContext context,
    SavedQuestionsProvider provider,
  ) {
    return DraggableScrollableSheet(
      initialChildSize: 0.12,
      minChildSize: 0.12,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 0.5,
              ),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    child: Container(
                      width: 32,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                _buildSummaryRow(provider),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Text(
                    'AKTİVİTE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.4),
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ActivityHeatmap(
                    data: provider.getHeatmapDataForWeeks(12),
                    weeks: 12,
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Divider(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    height: 1,
                  ),
                ),
                _buildPdfSection(context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Divider(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    height: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Text(
                    'YÖNETİM',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.4),
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                _buildBackupButtons(context, provider),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(SavedQuestionsProvider provider) {
    final streak = provider.getCurrentStreak();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          _buildSummaryStat(
            'SERİ',
            '$streak GÜN',
            Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w300,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildBackupButtons(
    BuildContext context,
    SavedQuestionsProvider provider,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.north_east, size: 18),
              label: const Text('Dışa Aktar'),
              onPressed: () => provider.exportData(),
            ),
          ),
          Expanded(
            child: TextButton.icon(
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.south_west, size: 18),
              label: const Text('İçe Aktar'),
              onPressed: () async {
                final success = await provider.importData();
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Veriler yüklendi')),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFolderTree(
    SavedQuestionsProvider provider,
    int? parentId, {
    int depth = 0,
  }) {
    final folders = provider.folders
        .where((f) => f.parentId == parentId)
        .toList();

    if (folders.isEmpty && parentId == null) {
      return Center(
        child: Text(
          'Kitaplık boş',
          style: TextStyle(color: Theme.of(context).colorScheme.outline),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: parentId == null
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      itemCount: folders.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        indent: 20 + (depth * 16.0),
        color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
      ),
      itemBuilder: (context, index) {
        final folder = folders[index];
        final hasChildren = provider.folders.any(
          (f) => f.parentId == folder.id,
        );
        final stats = _folderStats[folder.id];
        final toReview = stats?['toReview'] ?? 0;
        final newCount = stats?['newCount'] ?? 0;
        final total = stats?['total'] ?? 0;

        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            leading: Icon(
              Icons.folder_open,
              size: 20,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            title: GestureDetector(
              onTap: () async {
                final sq = await provider.getNextReviewQuestion(folder.id);
                if (sq != null && context.mounted) {
                  _quickOpen(context, sq);
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tekrar edilecek soru yok'),
                      duration: Duration(milliseconds: 500),
                    ),
                  );
                }
              },
              onLongPress: () => _showFolderOptions(context, provider, folder),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      folder.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  if (newCount > 0) ...[
                    _buildBadge(
                      '$newCount YENİ',
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.onSecondary,
                    ),
                    const SizedBox(width: 4),
                  ],
                  if (toReview > 0) ...[
                    _buildBadge(
                      '$toReview TEKRAR',
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.onPrimary,
                    ),
                    const SizedBox(width: 4),
                  ],
                  if (total > 0)
                    _buildBadge(
                      '$total TOPLAM',
                      Theme.of(context).colorScheme.outline,
                      Theme.of(context).colorScheme.onSurface,
                    ),
                ],
              ),
            ),
            tilePadding: EdgeInsets.only(left: 20 + (depth * 16.0), right: 20),
            children: [
              if (hasChildren)
                _buildFolderTree(provider, folder.id, depth: depth + 1),
            ],
          ),
        );
      },
    );
  }

  void _showFolderOptions(
    BuildContext context,
    SavedQuestionsProvider provider,
    QuestionFolder folder,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('İçindeki Soruları Görüntüle'),
            onTap: () {
              Navigator.pop(context);
              provider.loadQuestionsByFolder(folder.id);
              setState(() {
                _selectedFolderId = folder.id;
                _selectedFolderName = folder.name;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_to_photos_outlined),
            title: const Text('Özel Soru Ekle'),
            onTap: () {
              Navigator.pop(context);
              _showAddCustomQuestionDialog(context, provider, folder);
            },
          ),
          ListTile(
            leading: const Icon(Icons.create_new_folder_outlined),
            title: const Text('Alt Klasör Ekle'),
            onTap: () {
              Navigator.pop(context);
              _showCreateFolderDialog(context, provider, folder.id);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Klasörü Sil'),
            onTap: () {
              Navigator.pop(context);
              _confirmDeleteFolder(context, provider, folder);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionList(SavedQuestionsProvider provider) {
    if (provider.savedQuestions.isEmpty) {
      return const Center(child: Text('Bu klasörde henüz soru yok.'));
    }
    return ListView.builder(
      itemCount: provider.savedQuestions.length,
      itemBuilder: (context, index) {
        final sq = provider.savedQuestions[index];

        return ListTile(
          leading: const Icon(Icons.description_outlined),
          title: Text('Soru: ${sq.questionId}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(sq.breadcrumbs),
              if (sq.notes != null && sq.notes!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.tertiary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.tertiary.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.note_alt_outlined,
                        size: 14,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          sq.notes!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.tertiary,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (sq.answer != null && sq.answer!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          'Cevap: ${sq.answer!}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_note),
                tooltip: 'Notu Düzenle',
                onPressed: () => _showEditNoteDialog(context, provider, sq),
              ),
              IconButton(
                icon: const Icon(Icons.spellcheck),
                tooltip: 'Cevabı Düzenle',
                onPressed: () => _showEditAnswerDialog(context, provider, sq),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Sil',
                onPressed: () =>
                    provider.deleteSavedQuestion(sq.id, sq.folderId),
              ),
            ],
          ),
          onTap: () => _quickOpen(context, sq),
          onLongPress: () => _openOriginalTest(context, sq),
        );
      },
    );
  }

  void _showEditNoteDialog(
    BuildContext context,
    SavedQuestionsProvider provider,
    SavedQuestion sq,
  ) {
    final controller = TextEditingController(text: sq.notes);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notu Düzenle'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Notunuz...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              provider.updateQuestionNote(
                sq.id,
                controller.text.trim().isEmpty ? null : controller.text.trim(),
                sq.folderId,
              );
              Navigator.pop(context);
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  void _showEditAnswerDialog(
    BuildContext context,
    SavedQuestionsProvider provider,
    SavedQuestion sq,
  ) {
    final controller = TextEditingController(text: sq.answer);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cevabı Düzenle'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Sorunun cevabı...',
            border: OutlineInputBorder(),
          ),
          maxLines: 1,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              provider.updateQuestionAnswer(
                sq.id,
                controller.text.trim().isEmpty ? null : controller.text.trim(),
                sq.folderId,
              );
              Navigator.pop(context);
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  Future<void> _quickOpen(BuildContext context, SavedQuestion sq) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Hazırlanıyor...'),
          ],
        ),
      ),
    );

    try {
      final (question, animationData) = await _prepareAnimationData(sq);

      if (context.mounted) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlayerScreen(
              animationData: animationData!,
              question: question,
              savedQuestion: sq,
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<(Question, AnimationModel?)> _prepareAnimationData(
    SavedQuestion sq,
  ) async {
    final questionData = jsonDecode(sq.rawJson);
    final question = Question.fromJson(questionData);

    AnimationModel? animationData;

    if (sq.scraperType == 'custom_question') {
      final isImage =
          question.videoUrl?.endsWith('.png') == true ||
          question.videoUrl?.endsWith('.jpg') == true ||
          question.videoUrl?.endsWith('.jpeg') == true ||
          (question.videoUrl?.startsWith('data:image/') == true);

      String? finalVideoUrl = question.videoUrl;
      if (!isImage &&
          finalVideoUrl != null &&
          (finalVideoUrl.contains('youtube.com') ||
              finalVideoUrl.contains('youtu.be'))) {
        final youtubeService = SourceFactory.getSourceService('youtube');
        finalVideoUrl = await youtubeService.resolveVideoUrl(
          'custom',
          finalVideoUrl,
        );
      }

      animationData = AnimationModel(
        objects: [],
        totalDuration: Duration.zero,
        videoUrl: isImage ? null : finalVideoUrl,
        backgroundJpgUrl: isImage ? question.videoUrl : null,
        canvasWidth: question.width ?? (isImage ? 1920 : 1280),
        canvasHeight: question.height ?? (isImage ? 1080 : 720),
        pdfDefaultScale: 1.0,
        pdfOffset: Offset.zero,
      );
    } else {
      final sourceService = SourceFactory.getSourceService(sq.scraperType);

      if (sq.scraperType == 'f2source' && sourceService is F2SourceService) {
        final contentType = await sourceService.detectContentType(
          sq.baseUrl,
          question.videoUrl ?? question.id,
        );

        if (contentType['type'] == 'mp4' && contentType['url'] != null) {
          animationData = AnimationModel(
            objects: [],
            totalDuration: Duration.zero,
            videoUrl: contentType['url'],
            canvasWidth: 0,
            canvasHeight: 0,
            pdfDefaultScale: 1.0,
            pdfOffset: Offset.zero,
          );
        }
      }

      if (animationData == null &&
          question.videoUrl != null &&
          (question.videoUrl!.contains('youtube.com') ||
              question.videoUrl!.contains('youtu.be'))) {
        final finalVideoUrl = await sourceService.resolveVideoUrl(
          sq.baseUrl,
          question.videoUrl!,
        );

        animationData = AnimationModel(
          objects: [],
          totalDuration: Duration.zero,
          videoUrl: finalVideoUrl,
          canvasWidth: 1920,
          canvasHeight: 1080,
          pdfDefaultScale: 1.0,
          pdfOffset: Offset.zero,
        );
      }

      animationData ??= await DownloadService.prepareQuestionData(
        question,
        sourceService,
        sq.baseUrl,
        true,
      );
    }

    return (question, animationData);
  }

  Future<Uint8List?> _showManualCapturePlayer(SavedQuestion sq) async {
    try {
      final (question, animationData) = await _prepareAnimationData(sq);
      if (animationData == null) return null;

      if (!mounted) return null;

      return await Navigator.push<Uint8List>(
        context,
        MaterialPageRoute(
          builder: (_) => PlayerScreen(
            animationData: animationData,
            question: question,
            savedQuestion: sq,
            isCaptureMode: true,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Manual capture hatası: $e');
      return null;
    }
  }

  void _openOriginalTest(BuildContext context, SavedQuestion sq) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExplorerScreen(
          initialUrl: sq.baseUrl,
          initialSourceId: sq.bookId,
          bookName: sq.breadcrumbs.split(' > ').first,
          sourceType: sq.scraperType,
        ),
      ),
    ).then((_) {
      if (context.mounted) {
        final provider = context.read<SourceProvider>();
        provider.loadTestContent(
          SourceItem(id: sq.chapterId, name: '', isParent: false, parentId: ''),
        );
      }
    });
  }

  Widget _buildPdfSection(BuildContext context) {
    return Consumer<PdfExportProvider>(
      builder: (context, pdfProvider, _) {
        final pdfs = pdfProvider.generatedPdfs;
        if (pdfs.isEmpty && !pdfProvider.isExporting) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
              child: Row(
                children: [
                  Text(
                    'TESTLERİM',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.4),
                      letterSpacing: 1.1,
                    ),
                  ),
                  const Spacer(),
                  if (pdfProvider.isExporting)
                    SizedBox(
                      width: 80,
                      child: LinearProgressIndicator(
                        value: pdfProvider.exportProgress,
                        minHeight: 3,
                      ),
                    ),
                ],
              ),
            ),
            if (pdfProvider.isExporting)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  pdfProvider.exportStatus,
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
              ),
            ...pdfs.map((pdf) => _buildPdfRow(context, pdfProvider, pdf)),
          ],
        );
      },
    );
  }

  Widget _buildPdfRow(
    BuildContext context,
    PdfExportProvider pdfProvider,
    GeneratedPdf pdf,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pdf.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    _buildBadge(
                      '${pdf.questionCount} SORU',
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.onPrimary,
                    ),
                    const SizedBox(width: 4),
                    _buildBadge(
                      '${pdf.columns} SÜTUN',
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.onSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          _pdfActionButton(
            context,
            Icons.save_alt,
            'Kaydet',
            () => _savePdfFile(pdf),
          ),
          _pdfActionButton(
            context,
            Icons.open_in_new,
            'Aç',
            () => _openPdfFile(pdf),
          ),
          _pdfActionButton(
            context,
            Icons.visibility_outlined,
            'Detaylar',
            () => _showPdfDetails(context, pdf),
          ),
          _pdfActionButton(
            context,
            Icons.delete_outline,
            'Sil',
            () => pdfProvider.deletePdf(pdf.id),
          ),
          _pdfActionButton(
            context,
            Icons.check_circle_outline,
            'Review Adımlarını İlerlet ve Sil',
            () => pdfProvider.markAsCompleted(pdf.id),
          ),
        ],
      ),
    );
  }

  Widget _pdfActionButton(
    BuildContext context,
    IconData icon,
    String tooltip,
    VoidCallback onPressed,
  ) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, size: 18),
        onPressed: onPressed,
        padding: const EdgeInsets.all(6),
        constraints: const BoxConstraints(),
      ),
    );
  }

  Future<void> _savePdfFile(GeneratedPdf pdf) async {
    final file = File(pdf.filePath);
    if (!await file.exists()) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('PDF dosyası bulunamadı')));
      }
      return;
    }

    final bytes = await file.readAsBytes();
    final outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'PDF\'i kaydet',
      fileName: '${pdf.name}.pdf',
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      bytes: bytes,
    );

    if (outputFile != null && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('PDF kaydedildi')));
    }
  }

  Future<void> _openPdfFile(GeneratedPdf pdf) async {
    final file = File(pdf.filePath);
    if (!await file.exists()) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('PDF dosyası bulunamadı')));
      }
      return;
    }

    await OpenFile.open(pdf.filePath);
  }

  void _showPdfDetails(BuildContext context, GeneratedPdf pdf) {
    final pdfProvider = context.read<PdfExportProvider>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 16, 16),
              child: Row(
                children: [
                  Text(
                    pdf.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: FutureBuilder<List<SavedQuestion>>(
                future: pdfProvider.getQuestionsForPdf(pdf.id),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final questions = snapshot.data!;
                  if (questions.isEmpty) {
                    return const Center(child: Text('Soru bulunamadı'));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: questions.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      indent: 24,
                      endIndent: 24,
                      color: Theme.of(
                        context,
                      ).colorScheme.outlineVariant.withOpacity(0.3),
                    ),
                    itemBuilder: (context, index) {
                      final sq = questions[index];
                      return InkWell(
                        onTap: () => _quickOpen(context, sq),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              _buildBadge(
                                '${index + 1}',
                                Theme.of(context).colorScheme.outline,
                                Theme.of(context).colorScheme.onSurface,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Soru ${sq.questionId}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      sq.breadcrumbs,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.5),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              if (sq.notes != null && sq.notes!.isNotEmpty) ...[
                                Icon(
                                  Icons.note_alt_outlined,
                                  size: 14,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                const SizedBox(width: 8),
                              ],
                              if (sq.answer != null &&
                                  sq.answer!.isNotEmpty) ...[
                                Icon(
                                  Icons.check_circle_outline,
                                  size: 14,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                              ],
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.3),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPdfExportDialog() async {
    final provider = Provider.of<SavedQuestionsProvider>(
      context,
      listen: false,
    );
    final db = context.read<AppDatabase>();

    _selectedFolderIdsForPdf.clear();
    _pdfFilter = 'both';
    _pdfColumns = 2;
    _pdfName =
        '${_selectedFolderName ?? 'test'}_${DateTime.now().toString().split(' ').first}';

    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final now = DateTime.now();
          final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

          Future<List<SavedQuestion>> getFilteredQuestions() async {
            final questions = <SavedQuestion>[];
            for (final folderId in _selectedFolderIdsForPdf) {
              final folderQuestions = await (db.select(
                db.savedQuestions,
              )..where((t) => t.folderId.equals(folderId))).get();
              for (final q in folderQuestions) {
                final isDue =
                    q.reviewStep > 0 && !q.nextReviewDate.isAfter(todayEnd);
                final isNew = q.reviewStep == 0;
                if (_pdfFilter == 'due' && isDue) questions.add(q);
                if (_pdfFilter == 'new' && isNew) questions.add(q);
                if (_pdfFilter == 'both' && (isDue || isNew)) questions.add(q);
              }
            }
            return questions;
          }

          return AlertDialog(
            title: const Text('Test Oluştur'),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Klasörler:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 150,
                    child: ListView(
                      children: _buildRecursiveFolderCheckboxes(
                        provider,
                        null,
                        setDialogState,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  const Text(
                    'Soru Filtresi:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _filterChip('Her İkisi', 'both', setDialogState),
                      const SizedBox(width: 4),
                      _filterChip('Tekrarlanacak', 'due', setDialogState),
                      const SizedBox(width: 4),
                      _filterChip('Yeni', 'new', setDialogState),
                    ],
                  ),
                  const SizedBox(height: 8),

                  const Text(
                    'Sütun Sayısı:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [1, 2, 3].map((c) {
                      final isSelected = _pdfColumns == c;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text('$c'),
                          selected: isSelected,
                          onSelected: (v) {
                            setDialogState(() => _pdfColumns = c);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),

                  const Text(
                    'PDF İsmi:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'klasörAdı_tarih',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    controller: TextEditingController(text: _pdfName),
                    onChanged: (v) => _pdfName = v,
                  ),
                  const SizedBox(height: 8),

                  FutureBuilder<List<SavedQuestion>>(
                    future: getFilteredQuestions(),
                    builder: (context, snapshot) {
                      final count = snapshot.data?.length ?? 0;
                      return Text(
                        '$count soru PDF\'e dahil edilecek',
                        style: TextStyle(
                          color: count > 0
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.error,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('İptal'),
              ),
              FutureBuilder<List<SavedQuestion>>(
                future: getFilteredQuestions(),
                builder: (context, snapshot) {
                  final count = snapshot.data?.length ?? 0;
                  return TextButton(
                    onPressed: count > 0
                        ? () async {
                            final questions = snapshot.data!;
                            final folderIds = _selectedFolderIdsForPdf.toList();
                            final columns = _pdfColumns;
                            final pdfName = _pdfName;
                            final messenger = ScaffoldMessenger.of(context);
                            Navigator.pop(context);
                            final pdfProvider = Provider.of<PdfExportProvider>(
                              context,
                              listen: false,
                            );
                            await pdfProvider.exportQuestions(
                              questions: questions,
                              name: pdfName,
                              folderIds: folderIds,
                              columns: columns,
                              onCaptureRequired: (sq) =>
                                  _showManualCapturePlayer(sq),
                            );
                            messenger.showSnackBar(
                              const SnackBar(content: Text('PDF oluşturuldu')),
                            );
                          }
                        : null,
                    child: const Text('Oluştur'),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildRecursiveFolderCheckboxes(
    SavedQuestionsProvider provider,
    int? parentId,
    StateSetter setDialogState, {
    int depth = 0,
  }) {
    final folders = provider.folders
        .where((f) => f.parentId == parentId)
        .toList();
    final widgets = <Widget>[];

    for (final folder in folders) {
      final isSelected = _selectedFolderIdsForPdf.contains(folder.id);
      final hasChildren = provider.folders.any((f) => f.parentId == folder.id);

      if (hasChildren) {
        widgets.add(
          Padding(
            padding: EdgeInsets.only(left: depth * 12.0),
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                tilePadding: EdgeInsets.zero,
                initiallyExpanded: false,
                title: Row(
                  children: [
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: Checkbox(
                        value: isSelected,
                        onChanged: (v) {
                          setDialogState(() {
                            if (v == true) {
                              _selectedFolderIdsForPdf.add(folder.id);
                            } else {
                              _selectedFolderIdsForPdf.remove(folder.id);
                            }
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: Text(
                        folder.name,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
                children: _buildRecursiveFolderCheckboxes(
                  provider,
                  folder.id,
                  setDialogState,
                  depth: depth + 1,
                ),
              ),
            ),
          ),
        );
      } else {
        widgets.add(
          Padding(
            padding: EdgeInsets.only(left: depth * 12.0),
            child: CheckboxListTile(
              dense: true,
              visualDensity: VisualDensity.compact,
              contentPadding: EdgeInsets.zero,
              title: Text(folder.name, style: const TextStyle(fontSize: 13)),
              value: isSelected,
              onChanged: (v) {
                setDialogState(() {
                  if (v == true) {
                    _selectedFolderIdsForPdf.add(folder.id);
                  } else {
                    _selectedFolderIdsForPdf.remove(folder.id);
                  }
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
        );
      }
    }
    return widgets;
  }

  Widget _filterChip(String label, String value, StateSetter setDialogState) {
    return FilterChip(
      label: Text(label),
      selected: _pdfFilter == value,
      onSelected: (v) {
        setDialogState(() => _pdfFilter = value);
      },
    );
  }

  void _showCreateFolderDialog(
    BuildContext context,
    SavedQuestionsProvider provider,
    int? parentId,
  ) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni Klasör'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Klasör Adı'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                provider.createFolder(controller.text, parentId: parentId);
                Navigator.pop(context);
              }
            },
            child: const Text('Oluştur'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteFolder(
    BuildContext context,
    SavedQuestionsProvider provider,
    QuestionFolder folder,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Klasörü Sil'),
        content: Text(
          '${folder.name} klasörünü ve içindeki tüm soruları silmek istediğinize emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteFolder(folder.id);
              Navigator.pop(context);
            },
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }

  void _showAddCustomQuestionDialog(
    BuildContext context,
    SavedQuestionsProvider provider,
    QuestionFolder folder,
  ) {
    final answerController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Özel Soru Ekle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: answerController,
              decoration: const InputDecoration(
                labelText: 'Sorunun Cevabı',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.spellcheck),
              ),
              maxLines: 1,
            ),
            const SizedBox(height: 16),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Video Linki Ekle'),
              onTap: () {
                final answer = answerController.text.trim();
                Navigator.pop(context);
                _showAddVideoLinkDialog(
                  context,
                  provider,
                  folder,
                  initialAnswer: answer.isEmpty ? null : answer,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Resim/Video Seç'),
              onTap: () async {
                final answer = answerController.text.trim();
                Navigator.pop(context);
                await _pickCustomImage(
                  context,
                  provider,
                  folder,
                  initialAnswer: answer.isEmpty ? null : answer,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickCustomImage(
    BuildContext context,
    SavedQuestionsProvider provider,
    QuestionFolder folder, {
    String? initialAnswer,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.media,
      withData: kIsWeb,
    );

    if (result != null) {
      String? fileDataOrPath;
      bool isImage = false;

      if (kIsWeb) {
        final ext = result.files.single.extension?.toLowerCase() ?? 'png';
        isImage = ['png', 'jpg', 'jpeg'].contains(ext);

        if (isImage && result.files.single.bytes != null) {
          final bytes = result.files.single.bytes!;
          final base64Str = base64Encode(bytes);
          fileDataOrPath = 'data:image/$ext;base64,$base64Str';
        } else {
          fileDataOrPath = result.files.single.path;
        }
      } else {
        if (result.files.single.path != null) {
          final originalPath = result.files.single.path!;
          fileDataOrPath = result.files.single.path;
          final ext = result.files.single.extension?.toLowerCase() ?? '';
          isImage = ['png', 'jpg', 'jpeg'].contains(ext);
          final appDir = await getApplicationSupportDirectory();
          final customDir = Directory(p.join(appDir.path, 'custom_questions'));
          if (!await customDir.exists()) {
            await customDir.create(recursive: true);
          }
          final fileName =
              'custom_${DateTime.now().millisecondsSinceEpoch}.${ext.isNotEmpty ? ext : 'dat'}';
          final newPath = p.join(customDir.path, fileName);
          await File(originalPath).copy(newPath);
          fileDataOrPath = newPath;
        }
      }

      if (fileDataOrPath != null) {
        double? width;
        double? height;

        if (isImage) {
          try {
            final Uint8List bytes;
            if (kIsWeb) {
              bytes = result.files.single.bytes!;
            } else {
              bytes = await File(fileDataOrPath).readAsBytes();
            }
            final decodedImage = await decodeImageFromList(bytes);
            width = decodedImage.width.toDouble();
            height = decodedImage.height.toDouble();
          } catch (e) {
            debugPrint('Resim boyutları alınamadı: $e');
          }
        } else if (!kIsWeb) {
          try {
            final player = Player();
            final completer = Completer<void>();
            player.stream.width.listen((w) {
              if (w != null && w > 0) {
                width = w.toDouble();
                if (width != null && height != null && !completer.isCompleted) {
                  completer.complete();
                }
              }
            });
            player.stream.height.listen((h) {
              if (h != null && h > 0) {
                height = h.toDouble();
                if (width != null && height != null && !completer.isCompleted) {
                  completer.complete();
                }
              }
            });

            await player.open(Media(fileDataOrPath), play: false);
            await completer.future
                .timeout(const Duration(seconds: 2))
                .catchError((_) {});
            await player.dispose();
          } catch (e) {
            debugPrint('Video boyutları alınamadı: $e');
          }
        }

        final question = Question(
          id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
          name: isImage ? 'Özel Soru (Resim)' : 'Özel Soru (Video)',
          videoUrl: fileDataOrPath,
          order: '0',
          width: width,
          height: height,
        );

        await provider.saveQuestion(
          folderId: folder.id,
          baseUrl: 'custom',
          scraperType: 'custom_question',
          bookId: 'custom',
          chapterId: 'custom',
          breadcrumbs: 'Özel Sorular',
          question: question,
          answer: initialAnswer,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Soru eklendi')));
          provider.loadQuestionsByFolder(folder.id);
        }
      }
    }
  }

  void _showAddVideoLinkDialog(
    BuildContext context,
    SavedQuestionsProvider provider,
    QuestionFolder folder, {
    String? initialAnswer,
  }) {
    final controller = TextEditingController();
    final answerController = TextEditingController(text: initialAnswer);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Video Linki'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'https://...'),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: answerController,
              decoration: const InputDecoration(hintText: 'Soru Cevabı'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                final link = controller.text.trim();
                final question = Question(
                  id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                  name: 'Özel Soru (Video)',
                  videoUrl: link,
                  order: '0',
                );

                await provider.saveQuestion(
                  folderId: folder.id,
                  baseUrl: 'custom',
                  scraperType: 'custom_question',
                  bookId: 'custom',
                  chapterId: 'custom',
                  breadcrumbs: 'Özel Sorular',
                  question: question,
                  answer: answerController.text.trim().isNotEmpty
                      ? answerController.text.trim()
                      : null,
                );

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Soru eklendi')));
                  provider.loadQuestionsByFolder(folder.id);
                }
              }
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }
}
