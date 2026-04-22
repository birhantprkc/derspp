import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/subject_review_provider.dart';
import '../../database/database.dart';

class SubjectReviewScreen extends StatefulWidget {
  const SubjectReviewScreen({super.key});

  @override
  State<SubjectReviewScreen> createState() => _SubjectReviewScreenState();
}

class _SubjectReviewScreenState extends State<SubjectReviewScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SubjectReviewProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Konu Takibi'),
        titleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          fontSize: 20,
        ),
      ),
      body: _buildFolderTree(provider, null),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.create_new_folder_outlined),
                    title: const Text('Klasör Ekle'),
                    onTap: () {
                      Navigator.pop(context);
                      _showAddDialog(context, provider, null, isLeaf: false);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.checklist_rtl_sharp),
                    title: const Text('Konu Ekle'),
                    onTap: () {
                      Navigator.pop(context);
                      _showAddDialog(context, provider, null, isLeaf: true);
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildFolderTree(SubjectReviewProvider provider, int? parentId) {
    final items = provider.getChildren(parentId);

    if (items.isEmpty && parentId == null) {
      return const Center(child: Text('Henüz bir konu/klasör eklenmemiş'));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: parentId == null
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        indent: 20,
        color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
      ),
      itemBuilder: (context, index) {
        final subject = items[index];
        final progress = provider.calculateProgress(subject.id);
        final isExpired =
            subject.isLeaf &&
            subject.isKnown &&
            subject.nextReviewDate != null &&
            subject.nextReviewDate!.isBefore(DateTime.now());

        if (subject.isLeaf) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 4,
            ),
            leading: GestureDetector(
              onTap: () {
                if (subject.isKnown && !isExpired) {
                  provider.resetKnown(subject.id);
                } else {
                  _showIntervalDialog(context, provider, subject);
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.outlineVariant.withOpacity(0.3),
                    color: Theme.of(context).colorScheme.primary,
                    strokeWidth: 2.5,
                  ),
                  Icon(
                    Icons.check,
                    size: 16,
                    color: progress == 1.0
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                  ),
                ],
              ),
            ),
            title: Text(
              subject.name,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                decoration: progress == 1.0 ? TextDecoration.lineThrough : null,
                color: progress == 1.0
                    ? Theme.of(context).colorScheme.onSurface.withOpacity(0.5)
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: subject.isKnown
                ? Text(
                    isExpired
                        ? 'Tekrar zamanı geldi!'
                        : 'Tekrar: ${_formatDate(subject.nextReviewDate)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isExpired
                          ? Colors.red
                          : Theme.of(context).colorScheme.primary,
                    ),
                  )
                : null,
            trailing: IconButton(
              icon: const Icon(Icons.more_vert, size: 20),
              onPressed: () => _showOptionsDialog(context, provider, subject),
            ),
            onTap: () {
              if (subject.isKnown && !isExpired) {
                provider.resetKnown(subject.id);
              } else {
                _showIntervalDialog(context, provider, subject);
              }
            },
          );
        }

        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 20),
            leading: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    value: progress,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.outlineVariant.withOpacity(0.3),
                    color: Theme.of(context).colorScheme.primary,
                    strokeWidth: 3,
                  ),
                ),
                Icon(
                  Icons.folder_open,
                  size: 16,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ],
            ),
            title: Text(
              subject.name,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert, size: 20),
              onPressed: () => _showOptionsDialog(context, provider, subject),
            ),
            children: [_buildFolderTree(provider, subject.id)],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  void _showAddDialog(
    BuildContext context,
    SubjectReviewProvider provider,
    int? parentId, {
    required bool isLeaf,
  }) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isLeaf ? 'Konu Ekle' : 'Klasör Ekle'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: isLeaf ? 'Konu Adı' : 'Klasör Adı',
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                provider.addSubject(controller.text.trim(), parentId, isLeaf);
                Navigator.pop(context);
              }
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }

  void _showOptionsDialog(
    BuildContext context,
    SubjectReviewProvider provider,
    StudySubject subject,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              subject.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          if (!subject.isLeaf) ...[
            ListTile(
              leading: const Icon(Icons.create_new_folder_outlined),
              title: const Text('Alt Klasör Ekle'),
              onTap: () {
                Navigator.pop(context);
                _showAddDialog(context, provider, subject.id, isLeaf: false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.checklist_rtl_sharp),
              title: const Text('Alt Konu Ekle'),
              onTap: () {
                Navigator.pop(context);
                _showAddDialog(context, provider, subject.id, isLeaf: true);
              },
            ),
          ],
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Sil'),
            onTap: () {
              Navigator.pop(context);
              provider.deleteSubject(subject.id);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showIntervalDialog(
    BuildContext context,
    SubjectReviewProvider provider,
    StudySubject subject,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ne zaman tekrar edeceksin?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIntervalOption(context, provider, subject, '1 Gün', 1),
            _buildIntervalOption(context, provider, subject, '3 Gün', 3),
            _buildIntervalOption(context, provider, subject, '7 Gün', 7),
            _buildIntervalOption(context, provider, subject, '14 Gün', 14),
            _buildIntervalOption(context, provider, subject, '30 Gün', 30),
            _buildIntervalOption(context, provider, subject, '6 Ay', 180),
          ],
        ),
      ),
    );
  }

  Widget _buildIntervalOption(
    BuildContext context,
    SubjectReviewProvider provider,
    StudySubject subject,
    String label,
    int days,
  ) {
    final bool isSelectedBefore = subject.lastReviewInterval == days;
    return ListTile(
      title: Text(label),
      leading: Icon(
        isSelectedBefore ? Icons.check_circle : Icons.calendar_today_outlined,
        color: isSelectedBefore ? Theme.of(context).colorScheme.primary : null,
      ),
      tileColor: isSelectedBefore
          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
          : null,
      onTap: () {
        provider.markAsKnown(subject.id, days);
        Navigator.pop(context);
      },
    );
  }
}
