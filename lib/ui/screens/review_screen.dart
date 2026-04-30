import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/saved_questions_provider.dart';
import '../../providers/source_provider.dart';
import '../../models/question.dart';
import '../../database/database.dart';
import '../../services/download_service.dart';
import '../../services/source_factory.dart';
import '../../services/f2_source_service.dart';
import '../../services/youtube_source_service.dart';
import '../../models/animation_model.dart';
import '../../models/source_item.dart';
import '../widgets/activity_heatmap.dart';
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
      floatingActionButton: _selectedFolderId == null
          ? Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: FloatingActionButton.small(
                elevation: 0,
                highlightElevation: 0,
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                onPressed: () =>
                    _showCreateFolderDialog(context, provider, null),
                child: const Icon(Icons.add),
              ),
            )
          : null,
    );
  }

  Widget _buildBadge(String label, Color color, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
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

  Widget _buildFolderTree(SavedQuestionsProvider provider, int? parentId) {
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
        indent: 20,
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
            tilePadding: const EdgeInsets.symmetric(horizontal: 20),
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
            children: [if (hasChildren) _buildFolderTree(provider, folder.id)],
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
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.note_alt_outlined,
                        size: 14,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          sq.notes!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.orange,
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
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_note),
                onPressed: () => _showEditNoteDialog(context, provider, sq),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
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
            hintText: 'Soru ile ilgili notunuz...',
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
      final questionData = jsonDecode(sq.rawJson);
      final question = Question.fromJson(questionData);
      final sourceService = SourceFactory.getSourceService(sq.scraperType);

      AnimationModel? animationData;

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
}
