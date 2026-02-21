import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/saved_questions_provider.dart';
import '../../providers/source_provider.dart';
import '../../models/question.dart';
import '../../database/database.dart';
import '../../services/download_service.dart';
import '../../services/source_factory.dart';
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
      ),
      body: _selectedFolderId == null
          ? _buildFolderList(provider)
          : _buildQuestionList(provider),
      floatingActionButton: _selectedFolderId == null
          ? FloatingActionButton(
              onPressed: () => _showCreateFolderDialog(context, provider),
              child: const Icon(Icons.create_new_folder),
            )
          : null,
    );
  }

  Widget _buildFolderList(SavedQuestionsProvider provider) {
    if (provider.folders.isEmpty) {
      return const Center(child: Text('Henüz klasör oluşturulmamış.'));
    }
    return ListView.builder(
      itemCount: provider.folders.length,
      itemBuilder: (context, index) {
        final folder = provider.folders[index];
        return ListTile(
          leading: const Icon(Icons.folder),
          title: Text(folder.name),
          subtitle: Text(
            '${folder.createdAt.day}.${folder.createdAt.month}.${folder.createdAt.year}',
          ),
          onTap: () {
            provider.loadQuestionsByFolder(folder.id);
            setState(() {
              _selectedFolderId = folder.id;
              _selectedFolderName = folder.name;
            });
          },
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDeleteFolder(context, provider, folder),
          ),
        );
      },
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
          subtitle: Text(sq.breadcrumbs),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => provider.deleteSavedQuestion(sq.id),
          ),
          onTap: () => _quickOpen(context, sq),
          onLongPress: () => _showOptions(context, sq),
        );
      },
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

      final animationData = await DownloadService.prepareQuestionData(
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
            builder: (_) =>
                PlayerScreen(animationData: animationData, question: question),
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

  void _showOptions(BuildContext context, SavedQuestion sq) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.play_circle),
            title: const Text('Hızlı Aç'),
            onTap: () {
              Navigator.pop(context);
              _quickOpen(context, sq);
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text('Kitabı/Testi Aç'),
            onTap: () {
              Navigator.pop(context);
              _openOriginalTest(context, sq);
            },
          ),
        ],
      ),
    );
  }

  void _openOriginalTest(BuildContext context, SavedQuestion sq) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExplorerScreen(
          initialUrl: sq.baseUrl,
          initialSourceId: sq.chapterId,
          sourceType: sq.scraperType,
        ),
      ),
    );
  }

  void _showCreateFolderDialog(
    BuildContext context,
    SavedQuestionsProvider provider,
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
                provider.createFolder(controller.text);
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
