import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/question.dart';
import '../../models/source_item.dart';
import '../../models/saved_book.dart';
import '../../models/animation_model.dart';
import '../../services/download_service.dart';
import '../../services/source_factory.dart';
import '../../services/f2_source_service.dart';
import '../../providers/source_provider.dart';
import '../../providers/book_provider.dart';
import 'player_screen.dart';

class ExplorerScreen extends StatefulWidget {
  final String? initialUrl;
  final String? initialSourceId;
  final String? bookName;
  final String sourceType;

  const ExplorerScreen({
    super.key,
    this.initialUrl,
    this.initialSourceId,
    this.bookName,
    this.sourceType = 'fsource',
  });

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SourceProvider>();
      provider.loadSavedPubs();
      if (widget.initialUrl != null && widget.initialSourceId != null) {
        if (widget.bookName != null) {
          provider.setupForBook(
            widget.initialUrl!,
            widget.initialSourceId!,
            widget.bookName!,
            sourceType: widget.sourceType,
          );
        } else {
          provider.setBaseUrl(
            widget.initialUrl!,
            widget.initialSourceId!,
            sourceType: widget.sourceType,
          );
          provider.loadCategory(widget.initialSourceId!);
        }
      }
    });
  }

  Future<void> _handleQuestionTap(
    Question question, {
    bool preferPdf = false,
    bool fromPlayer = false,
  }) async {
    final provider = context.read<SourceProvider>();

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
      final sourceService = SourceFactory.getSourceService(
        provider.currentSourceType,
      );
      final questions = provider.currentBookContent?.questions ?? [];
      final currentIndex = questions.indexWhere((q) => q.id == question.id);
      final hasNext = currentIndex >= 0 && currentIndex < questions.length - 1;
      final hasPrevious = currentIndex > 0;

      if (provider.currentSourceType == 'f2source' &&
          sourceService is F2SourceService) {
        final contentType = await sourceService.detectContentType(
          provider.baseUrl,
          question.videoUrl ?? question.id,
        );

        if (contentType['type'] == 'mp4' && contentType['url'] != null) {
          if (mounted) {
            Navigator.pop(context);

            final animationData = AnimationModel(
              objects: [],
              totalDuration: Duration.zero,
              videoUrl: contentType['url'],
              canvasWidth: 0,
              canvasHeight: 0,
              pdfDefaultScale: 1.0,
              pdfOffset: Offset.zero,
            );

            final mp4Player = PlayerScreen(
              animationData: animationData,
              question: question,
              hasNextVideo: hasNext,
              hasPreviousVideo: hasPrevious,
              onNextVideo: hasNext
                  ? () => _handleQuestionTap(
                      questions[currentIndex + 1],
                      preferPdf: preferPdf,
                      fromPlayer: true,
                    )
                  : null,
              onPreviousVideo: hasPrevious
                  ? () => _handleQuestionTap(
                      questions[currentIndex - 1],
                      preferPdf: preferPdf,
                      fromPlayer: true,
                    )
                  : null,
            );

            if (fromPlayer) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => mp4Player),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => mp4Player),
              );
            }
          }
          return;
        }
      }

      if (question.videoUrl != null &&
          (question.videoUrl!.contains('youtube.com') ||
              question.videoUrl!.contains('youtu.be'))) {
        if (mounted) {
          Navigator.pop(context);

          final animationData = AnimationModel(
            objects: [],
            totalDuration: Duration.zero,
            videoUrl: question.videoUrl,
            canvasWidth: 1920,
            canvasHeight: 1080,
            pdfDefaultScale: 1.0,
            pdfOffset: Offset.zero,
          );

          final player = PlayerScreen(
            animationData: animationData,
            question: question,
            hasNextVideo: hasNext,
            hasPreviousVideo: hasPrevious,
            onNextVideo: hasNext
                ? () => _handleQuestionTap(
                    questions[currentIndex + 1],
                    preferPdf: preferPdf,
                    fromPlayer: true,
                  )
                : null,
            onPreviousVideo: hasPrevious
                ? () => _handleQuestionTap(
                    questions[currentIndex - 1],
                    preferPdf: preferPdf,
                    fromPlayer: true,
                  )
                : null,
          );

          if (fromPlayer) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => player),
            );
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) => player));
          }
        }
        return;
      }

      final animationData = await DownloadService.prepareQuestionData(
        question,
        sourceService,
        provider.baseUrl,
        preferPdf,
      );

      if (mounted) {
        Navigator.pop(context);

        final newPlayer = PlayerScreen(
          animationData: animationData,
          question: question,
          hasNextVideo: hasNext,
          hasPreviousVideo: hasPrevious,
          onNextVideo: hasNext
              ? () => _handleQuestionTap(
                  questions[currentIndex + 1],
                  preferPdf: preferPdf,
                  fromPlayer: true,
                )
              : null,
          onPreviousVideo: hasPrevious
              ? () => _handleQuestionTap(
                  questions[currentIndex - 1],
                  preferPdf: preferPdf,
                  fromPlayer: true,
                )
              : null,
        );

        if (fromPlayer) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => newPlayer),
          );
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (_) => newPlayer));
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 10),
          ),
        );
      }
    }
  }

  Future<void> _saveAsBook() async {
    final provider = context.read<SourceProvider>();
    if (provider.navigationStack.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir kategori seçin')),
      );
      return;
    }

    final currentItem = provider.navigationStack.last;
    final nameController = TextEditingController();

    final bookName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kitap Adı'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            hintText: 'Kitap adını girin',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, nameController.text.trim()),
            child: const Text('İleri'),
          ),
        ],
      ),
    );

    if (bookName == null || bookName.isEmpty) return;

    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    String? coverPath;
    if (imageFile != null && mounted) {
      final bytes = await imageFile.readAsBytes();
      if (!mounted) return;
      final bookId = DateTime.now().millisecondsSinceEpoch.toString();
      coverPath = await context.read<BookProvider>().saveCoverImage(
        bookId,
        bytes,
      );
    }

    if (mounted) {
      final newBook = SavedBook(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: bookName,
        sourceId: currentItem.id,
        baseUrl: provider.baseUrl!,
        addedDate: DateTime.now(),
        coverImage: coverPath,
        sourceType: provider.currentSourceType,
      );
      Navigator.pop(context, newBook);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SourceProvider>();
    final theme = Theme.of(context);

    if (provider.baseUrl == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('İçerik Yüklenemedi')),
        body: const Center(child: Text('Lütfen bir yayın seçin')),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didpop, result) async {
        if (!didpop) {
          provider.navigateBack(
            initialSourceId: widget.initialSourceId,
            onPop: () => Navigator.pop(context),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.initialSourceId != null
                ? (widget.bookName ?? 'Kitap')
                : 'Kategori seç',
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => provider.navigateBack(
              initialSourceId: widget.initialSourceId,
              onPop: () => Navigator.pop(context),
            ),
          ),
          actions: [
            if (provider.currentBookContent == null &&
                provider.navigationStack.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.add_box),
                tooltip: 'Bu sayfayı kitap olarak ekle',
                onPressed: _saveAsBook,
              ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              if (provider.navigationStack.isNotEmpty)
                _buildBreadcrumbs(provider, theme),
              if (provider.errorMessage != null)
                _buildErrorMessage(provider, theme),
              Expanded(
                child: provider.currentBookContent != null
                    ? _buildQuestionsList(provider)
                    : _buildCategoryList(provider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreadcrumbs(SourceProvider provider, ThemeData theme) {
    if (provider.breadcrumbs.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      color: theme.colorScheme.surface,
      child: Row(
        children: [
          const Icon(Icons.folder_open, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              provider.breadcrumbs,
              style: theme.textTheme.bodySmall,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(SourceProvider provider, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: theme.colorScheme.errorContainer,
      child: Row(
        children: [
          Icon(Icons.error, color: theme.colorScheme.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              provider.errorMessage!,
              style: TextStyle(color: theme.colorScheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(SourceProvider provider) {
    final displayItems = provider.isLoading
        ? List.generate(
            1,
            (index) => SourceItem(
              id: 'skeleton_$index',
              name: '',
              isParent: true,
              parentId: '0',
            ),
          )
        : provider.currentItems;

    if (!provider.isLoading && displayItems.isEmpty) {
      return const Center(child: Text('İçerik bulunamadı'));
    }

    return Skeletonizer(
      enabled: provider.isLoading,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: displayItems.length,
        itemBuilder: (context, index) {
          final item = displayItems[index];
          return _buildListItem(
            title: item.name,
            icon: item.isParent ? Icons.folder : Icons.assignment,
            onTap: () => provider.onItemTap(item),
          );
        },
      ),
    );
  }

  Widget _buildQuestionsList(SourceProvider provider) {
    final questions = provider.isLoading
        ? List.generate(
            10,
            (index) => Question(
              id: 'sk_$index',
              name: '',
              order: (index + 1).toString(),
              swfUrl: '',
            ),
          )
        : (provider.currentBookContent?.questions ?? []);

    if (!provider.isLoading && questions.isEmpty) {
      return const Center(child: Text('Soru bulunamadı'));
    }

    return Skeletonizer(
      enabled: provider.isLoading,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          return _buildListItem(
            title: '${question.order}. ${question.name}',
            icon: Icons.play_circle_outline,
            onTap: () => _handleQuestionTap(question, preferPdf: true),
          );
        },
      ),
    );
  }

  Widget _buildListItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(child: Text(title)),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
