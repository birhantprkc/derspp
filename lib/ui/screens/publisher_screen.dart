import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/saved_book.dart';
import '../../providers/book_provider.dart';
import '../../providers/source_provider.dart';
import '../widgets/add_publisher_dialog.dart';
import 'explorer_screen.dart';

class PublisherScreen extends StatefulWidget {
  const PublisherScreen({super.key});

  @override
  State<PublisherScreen> createState() => _PublisherScreenState();
}

class _PublisherScreenState extends State<PublisherScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SourceProvider>().loadSavedPubs();
    });
  }

  Future<void> _showUrlDialog(SourceProvider provider) async {
    final result = await showDialog<Map<String, String>?>(
      context: context,
      builder: (context) => const AddPublisherDialog(),
    );

    if (result != null) {
      await provider.savePub(
        result['name']!,
        result['url']!,
        result['id']!,
        type: result['type']!,
      );
      if (mounted) {
        await _openExplorer(
          result['url']!,
          result['id']!,
          result['name']!,
          sourceType: result['type']!,
        );
      }
    }
  }

  Future<void> _openExplorer(
    String url,
    String id,
    String name, {
    String sourceType = 'fsource',
  }) async {
    final result = await Navigator.push<SavedBook>(
      context,
      MaterialPageRoute(
        builder: (context) => ExplorerScreen(
          initialUrl: url,
          initialSourceId: id,
          bookName: name,
          sourceType: sourceType,
        ),
      ),
    );

    if (result != null && mounted) {
      context.read<BookProvider>().addBook(result);
      DefaultTabController.of(context).animateTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SourceProvider>();
    final theme = Theme.of(context);

    final filteredPubs = provider.savedPubs.where((pub) {
      return pub.name.toLowerCase().contains(provider.searchQuery);
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: provider.loadingPubs
                ? const Center(child: CircularProgressIndicator())
                : filteredPubs.isEmpty
                ? _buildEmptyPublishers(theme, provider.searchQuery.isNotEmpty)
                : Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListView.builder(
                      itemCount: filteredPubs.length,
                      itemBuilder: (context, index) {
                        final pub = filteredPubs[index];
                        return Card(
                          elevation: 0,
                          color: theme.colorScheme.surfaceVariant.withOpacity(
                            0.3,
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            leading: const Icon(Icons.book),
                            title: Text(pub.name),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, size: 20),
                              onPressed: () => provider.deletePub(pub),
                            ),
                            onTap: () => _openExplorer(
                              pub.url,
                              pub.sourceId,
                              pub.name,
                              sourceType: pub.scraperType,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        highlightElevation: 0,
        icon: const Icon(Icons.add),
        onPressed: () => _showUrlDialog(provider),
        label: const Text('Yeni yayın ekle'),
      ),
    );
  }

  Widget _buildEmptyPublishers(ThemeData theme, bool isSearching) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off : Icons.library_books_outlined,
            size: 80,
            color: theme.colorScheme.primary.withAlpha((0.3 * 255).round()),
          ),
          const SizedBox(height: 16),
          Text(
            isSearching ? 'Yayıncı bulunamadı' : 'Henüz yayın eklemediniz',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary.withAlpha((0.6 * 255).round()),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isSearching
                ? 'Büyük, küçük harf duyarsızdır.'
                : 'Sağ alttaki butonu kullanarak yeni bir yayın ekleyebilirsiniz.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha((0.3 * 255).round()),
            ),
          ),
        ],
      ),
    );
  }
}
