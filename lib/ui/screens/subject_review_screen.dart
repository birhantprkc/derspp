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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _buildFolderTree(provider, null),
          ),
          _buildStatsPanel(context, provider),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
        child: FloatingActionButton.small(
          elevation: 2,
          backgroundColor: Theme.of(
            context,
          ).colorScheme.surfaceVariant,
          foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
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

  Widget _buildStatsPanel(
    BuildContext context,
    SubjectReviewProvider provider,
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
                _buildSummaryRow(context, provider),
                const SizedBox(height: 16),
                _buildDueSection(context, provider),
                _buildUpcomingSection(context, provider),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(BuildContext context, SubjectReviewProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.menu_book_outlined),
              label: const Text('Konu Çalış'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildSummaryStat(
                context,
                'TOPLAM KONU',
                '${provider.subjects.where((s) => s.isLeaf).length}',
                Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 32),
              _buildSummaryStat(
                context,
                'TEKRARDA',
                '${provider.dueSubjects.length}',
                Theme.of(context).colorScheme.error,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(BuildContext context, String label, String value, Color color) {
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

  Widget _buildDueSection(BuildContext context, SubjectReviewProvider provider) {
    final dueSubjects = provider.dueSubjects;
    if (dueSubjects.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Text(
            'TEKRAR EDİLECEKLER',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              letterSpacing: 1.1,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: dueSubjects.length,
          itemBuilder: (context, index) {
            final subject = dueSubjects[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              leading: Icon(
                Icons.history,
                size: 18,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                subject.name,
                style: const TextStyle(fontSize: 14),
              ),
              subtitle: Text(
                'Zamanı geçti',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              onTap: () => _showIntervalDialog(context, provider, subject),
            );
          },
        ),
      ],
    );
  }

  Widget _buildUpcomingSection(BuildContext context, SubjectReviewProvider provider) {
    final upcoming = provider.upcomingSubjects;
    if (upcoming.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Text(
            'TEKRARI YAKLAŞANLAR',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              letterSpacing: 1.1,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: upcoming.length,
          itemBuilder: (context, index) {
            final subject = upcoming[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              leading: Icon(
                Icons.schedule,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                subject.name,
                style: const TextStyle(fontSize: 14),
              ),
              subtitle: Text(
                _formatRelativeDate(subject.nextReviewDate),
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              onTap: () => _showIntervalDialog(context, provider, subject),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSquareBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
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
        final dueCount = provider.getDueCount(subject.id);
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
                    Icons.check,
                    size: 16,
                    color: progress == 1.0
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                  ),
                ],
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
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
                ),
                if (isExpired)
                  _buildSquareBadge(
                    'TEKRAR',
                    Theme.of(context).colorScheme.error,
                  ),
              ],
            ),
            subtitle: null,
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
                  color: dueCount > 0
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ],
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    subject.name,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
                if (dueCount > 0)
                  _buildSquareBadge(
                    '$dueCount TEKRAR',
                    Theme.of(context).colorScheme.error,
                  ),
              ],
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

  String _formatRelativeDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diffDays = target.difference(today).inDays;

    if (diffDays == 0) return 'Bugün';
    if (diffDays == 1) return 'Yarın';
    if (diffDays > 1) return '$diffDays gün sonra';
    if (diffDays == -1) return 'Dün';
    return '${diffDays.abs()} gün önce';
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
