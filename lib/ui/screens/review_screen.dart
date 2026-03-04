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
import '../../models/animation_model.dart';
import '../../models/source_item.dart';
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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SavedQuestionsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedFolderName ?? 'Kaydedilen Sorular'),
        leading: _selectedFolderId != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _selectedFolderId = null;
                    _selectedFolderName = null;
                  });
                },
              )
            : null,
        titleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          fontSize: 20,
        ),
      ),
      body: Stack(
        children: [
          _selectedFolderId == null
              ? _buildFolderTree(provider, null)
              : _buildQuestionList(provider),
          if (_selectedFolderId == null) _buildStatsPanel(context, provider),
        ],
      ),
      floatingActionButton: _selectedFolderId == null
          ? Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: FloatingActionButton(
                onPressed: () =>
                    _showCreateFolderDialog(context, provider, null),
                child: const Icon(Icons.create_new_folder),
              ),
            )
          : null,
    );
  }

  Widget _buildStatsPanel(
    BuildContext context,
    SavedQuestionsProvider provider,
  ) {
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.4,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('Veri Yönetimi'),
                ),
                const Divider(),
                const SizedBox(height: 20),
                _buildBackupButtons(context, provider),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackupButtons(
    BuildContext context,
    SavedQuestionsProvider provider,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text('Veriyi Yedekle'),
              onPressed: () => provider.exportData(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.upload),
              label: const Text('Yedeği Yükle'),
              onPressed: () async {
                final success = await provider.importData();
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Veriler başarıyla yüklendi.'),
                    ),
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
      return const Center(child: Text('Henüz klasör oluşturulmamış.'));
    }

    if (folders.isEmpty) return const SizedBox.shrink();

    return ListView.builder(
      shrinkWrap: true,
      physics: parentId == null
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      itemCount: folders.length,
      itemBuilder: (context, index) {
        final folder = folders[index];
        final hasChildren = provider.folders.any(
          (f) => f.parentId == folder.id,
        );

        return ExpansionTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: GestureDetector(
            onTap: () async {
              final sq = await provider.getNextReviewQuestion(folder.id);
              if (sq != null && context.mounted) {
                _quickOpen(context, sq);
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bu klasörde bugün tekrar edilecek soru yok'),
                  ),
                );
              }
            },
            onLongPress: () => _showFolderOptions(context, provider, folder),
            child: Text(folder.name),
          ),
          trailing: null,
          children: [
            if (hasChildren)
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: _buildFolderTree(provider, folder.id),
              ),
          ],
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
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text(
              'Klasörü Sil',
              style: TextStyle(color: Colors.red),
            ),
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
                icon: const Icon(Icons.edit_note, color: Colors.blue),
                onPressed: () => _showEditNoteDialog(context, provider, sq),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
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
        animationData = AnimationModel(
          objects: [],
          totalDuration: Duration.zero,
          videoUrl: question.videoUrl,
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
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
