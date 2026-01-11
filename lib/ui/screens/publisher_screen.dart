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

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: provider.loadingPubs
                ? const Center(child: CircularProgressIndicator())
                : provider.savedPubs.isEmpty
                ? _buildEmptyPublishers(theme)
                : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListView.builder(
                      itemCount: provider.savedPubs.length,
                      itemBuilder: (context, index) {
                        final pub = provider.savedPubs[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            leading: const Icon(Icons.book),
                            title: Text(pub.name),
                            subtitle: Text("${pub.url} (ID: ${pub.sourceId})"),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
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
        icon: const Icon(Icons.add),
        onPressed: () => _showUrlDialog(provider),
        label: const Text('Yeni yayın ekle'),
      ),
    );
  }

  Widget _buildEmptyPublishers(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SizedBox(height: 16),
          Text("Henüz yayın eklemediniz."),
        ],
      ),
    );
  }
}
