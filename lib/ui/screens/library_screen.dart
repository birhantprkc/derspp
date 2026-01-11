import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../models/saved_book.dart';
import '../../providers/book_provider.dart';
import 'explorer_screen.dart';
import 'book_edit_screen.dart';
import '../widgets/book_card.dart';
import '../widgets/book_list_tile.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  Future<void> _deleteBook(SavedBook book) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kitabı Sil'),
        content: Text(
          '${book.name} kitabını silmek istediğinizden emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      context.read<BookProvider>().deleteBook(book);
    }
  }

  void _openBook(SavedBook book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExplorerScreen(
          initialUrl: book.baseUrl,
          initialSourceId: book.sourceId,
          bookName: book.name,
          sourceType: book.sourceType,
        ),
      ),
    );
  }

  void _showBookEditor(SavedBook book) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (context, _, __) => BookEditScreen(book: book),
        transitionsBuilder: (context, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bookProvider = Provider.of<BookProvider>(context);
    final filteredBooks = bookProvider.savedBooks.where((book) {
      return book.name.toLowerCase().contains(bookProvider.searchQuery);
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: filteredBooks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          bookProvider.searchQuery.isEmpty
                              ? Icons.library_books_outlined
                              : Icons.search_off,
                          size: 80,
                          color: theme.colorScheme.primary.withAlpha(
                            (0.3 * 255).round(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          bookProvider.searchQuery.isEmpty
                              ? 'Henüz kitap eklemediniz'
                              : 'Kitap bulunamadı',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary.withAlpha(
                              (0.6 * 255).round(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          bookProvider.searchQuery.isEmpty
                              ? 'Lütfen yayınlar sekmesinden kitap ekleyiniz.'
                              : 'Büyük, küçük harf duyarsızdır.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(
                              (0.3 * 255).round(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : bookProvider.isGridView
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Skeletonizer(
                      enabled: bookProvider.isLoading,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 240,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.72,
                            ),
                        itemCount: filteredBooks.length,
                        itemBuilder: (context, index) {
                          final book = filteredBooks[index];
                          return BookCard(
                            book: book,
                            onTap: () => _openBook(book),
                            onLongPress: () => _showBookEditor(book),
                          );
                        },
                      ),
                    ),
                  )
                : Skeletonizer(
                    enabled: bookProvider.isLoading,
                    child: ReorderableListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: filteredBooks.length,
                      buildDefaultDragHandles: false,
                      onReorder: (oldIndex, newIndex) {
                        bookProvider.reorderBooks(oldIndex, newIndex);
                      },
                      itemBuilder: (context, index) {
                        final book = filteredBooks[index];

                        return BookListTile(
                          key: ValueKey(book.id),
                          book: book,
                          index: index,
                          onTap: () => _openBook(book),
                          onLongPress: () => _showBookEditor(book),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert),
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _showBookEditor(book);
                                  } else if (value == 'delete') {
                                    _deleteBook(book);
                                  }
                                },
                                itemBuilder: (context) => const [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit),
                                        SizedBox(width: 8),
                                        Text('Düzenle'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete),
                                        SizedBox(width: 8),
                                        Text('Sil'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              ReorderableDragStartListener(
                                index: index,
                                child: const SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Center(child: Icon(Icons.drag_handle)),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
