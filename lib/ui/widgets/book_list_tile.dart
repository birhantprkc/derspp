import 'package:flutter/material.dart';
import '../../models/saved_book.dart';
import 'platform_image.dart';

class BookListTile extends StatelessWidget {
  final SavedBook book;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final Widget? trailing;

  const BookListTile({
    super.key,
    required this.book,
    required this.index,
    required this.onTap,
    required this.onLongPress,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      key: ValueKey(book.id),
      onLongPress: onLongPress,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Hero(
            tag: book.id,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: book.coverImage != null
                  ? PlatformImage(
                      path: book.coverImage!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 48,
                      height: 48,
                      color: theme.colorScheme.primaryContainer,
                      child: Icon(
                        Icons.book,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
            ),
          ),
          title: Text(book.name, style: theme.textTheme.titleMedium),
          trailing: trailing,
          onTap: onTap,
        ),
      ),
    );
  }
}
