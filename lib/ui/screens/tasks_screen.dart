import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';
import '../../database/database.dart';
import '../widgets/activity_heatmap.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final List<String> _days = ['PZT', 'SAL', 'ÇAR', 'PER', 'CUM', 'CMT', 'PAZ'];
  bool _isEditMode = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    final int todayIndex = DateTime.now().weekday - 1;

    return DefaultTabController(
      length: _days.length,
      initialIndex: taskProvider.isCurrentWeek ? todayIndex : 0,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Stack(
          children: [
            NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  _buildSliverAppBar(context, taskProvider),
                  _buildTabBar(context),
                ];
              },
              body: Column(
                children: [
                  if (taskProvider.isPastWeek)
                    _buildBanner(
                      context,
                      'Salt Okunur Modu',
                      Icons.visibility_outlined,
                      theme.colorScheme.primary,
                    ),
                  if (taskProvider.isFutureWeek)
                    _buildBanner(
                      context,
                      'Düzenleme Modu',
                      Icons.edit_calendar_outlined,
                      theme.colorScheme.secondary,
                    ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: List.generate(
                        _days.length,
                        (index) => _buildDayContent(context, index),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildStatsPanel(context, taskProvider),
          ],
        ),
        floatingActionButton: null,
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, TaskProvider taskProvider) {
    final theme = Theme.of(context);
    return SliverAppBar(
      floating: true,
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: theme.colorScheme.surface,
      centerTitle: false,
      title: const Text('Planlama'),
      titleTextStyle: TextStyle(
        color: theme.colorScheme.onSurface.withOpacity(0.7),
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      actions: [
        if (!taskProvider.isPastWeek)
          IconButton(
            onPressed: () {
              setState(() {
                _isEditMode = !_isEditMode;
              });
            },
            icon: Icon(_isEditMode ? Icons.done : Icons.edit, size: 20),
            tooltip: _isEditMode ? 'Düzenlemeyi Bitir' : 'Düzenle',
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final theme = Theme.of(context);
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.5),
          indicatorColor: theme.colorScheme.primary,
          indicatorWeight: 2,
          dividerColor: Colors.transparent,
          labelPadding: const EdgeInsets.symmetric(horizontal: 20),
          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          tabs: _days.map((day) => Tab(text: day)).toList(),
        ),
      ),
    );
  }

  Widget _buildStatsPanel(BuildContext context, TaskProvider provider) {
    final theme = Theme.of(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.12,
      minChildSize: 0.12,
      maxChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.outlineVariant,
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
                        color: theme.colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                _buildWeekNavigator(context, provider),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Text(
                    'AKTİVİTE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ActivityHeatmap(
                    data: provider.getHeatmapData(),
                    weeks: 12,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeekNavigator(BuildContext context, TaskProvider provider) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            provider.changeWeek(-1);
          } else if (details.primaryVelocity! < 0) {
            provider.changeWeek(1);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, size: 24),
              onPressed: () {
                provider.changeWeek(-1);
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    'HAFTA ${provider.weekNumber}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    provider.weekRangeText,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, size: 24),
              onPressed: () {
                provider.changeWeek(1);
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: color.withOpacity(0.08),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayContent(BuildContext context, int dayIndex) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final dersTasks = taskProvider.getTasksForDay(dayIndex, 'DERS');
    final kisiselTasks = taskProvider.getTasksForDay(dayIndex, 'KİŞİSEL');

    final now = DateTime.now();
    final todayIndex = now.weekday - 1;
    final isToday = dayIndex == todayIndex && taskProvider.isCurrentWeek;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 140.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'DERS', dersTasks.length),
          if (dersTasks.isEmpty && !_isEditMode)
            _buildEmptyState(context, 'Ders görevi bulunmuyor.'),
          ...dersTasks.map(
            (task) => _buildTaskItem(
              context,
              task,
              isToday,
              !taskProvider.isPastWeek,
            ),
          ),
          if (_isEditMode && !taskProvider.isPastWeek)
            _buildAddSmallButton(context, dayIndex, 'DERS'),
          const SizedBox(height: 32),
          _buildSectionHeader(context, 'KİŞİSEL', kisiselTasks.length),
          if (kisiselTasks.isEmpty && !_isEditMode)
            _buildEmptyState(context, 'Kişisel görev bulunmuyor.'),
          ...kisiselTasks.map(
            (task) => _buildTaskItem(
              context,
              task,
              isToday,
              !taskProvider.isPastWeek,
            ),
          ),
          if (_isEditMode && !taskProvider.isPastWeek)
            _buildAddSmallButton(context, dayIndex, 'KİŞİSEL'),
          const SizedBox(height: 60),
          _buildFooterQuote(context),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 13,
          fontStyle: FontStyle.italic,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, int count) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              letterSpacing: 1.1,
            ),
          ),
          Text(
            '$count GÖREV',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(
    BuildContext context,
    Task task,
    bool isToday,
    bool isEditableWeek,
  ) {
    final theme = Theme.of(context);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Transform.scale(
        scale: 0.9,
        child: Checkbox(
          value: task.isDone,
          onChanged: (isEditableWeek && !_isEditMode && isToday)
              ? (v) => taskProvider.toggleTask(task)
              : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      title: Text(
        task.title,
        style: TextStyle(
          fontSize: 15,
          color: task.isDone
              ? theme.colorScheme.onSurface.withOpacity(0.4)
              : theme.colorScheme.onSurface,
          decoration: task.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: (_isEditMode && isEditableWeek)
          ? IconButton(
              icon: const Icon(Icons.remove_circle_outline, size: 18),
              onPressed: () => taskProvider.deleteTask(task.id),
            )
          : null,
    );
  }

  Widget _buildAddSmallButton(
    BuildContext context,
    int dayIndex,
    String category,
  ) {
    return TextButton.icon(
      onPressed: () => _showQuickAddDialog(context, dayIndex, category),
      icon: const Icon(Icons.add, size: 16),
      label: const Text('Görev Ekle', style: TextStyle(fontSize: 13)),
    );
  }

  void _showQuickAddDialog(
    BuildContext context,
    int dayIndex,
    String category,
  ) {
    final controller = TextEditingController();
    int frequency = 0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('$category Görevi Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Görev adı...'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: frequency,
                decoration: const InputDecoration(
                  labelText: 'Tekrarlama Sıklığı',
                  labelStyle: TextStyle(fontSize: 14),
                ),
                items: const [
                  DropdownMenuItem(value: 0, child: Text('Tek Seferlik')),
                  DropdownMenuItem(value: 1, child: Text('Her Hafta')),
                  DropdownMenuItem(value: 2, child: Text('2 Haftada Bir')),
                  DropdownMenuItem(value: 4, child: Text('Ayda Bir')),
                ],
                onChanged: (val) => setDialogState(() => frequency = val!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  Provider.of<TaskProvider>(context, listen: false).addTask(
                    controller.text,
                    dayIndex,
                    category,
                    frequency: frequency,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Ekle'),
            ),
          ],
        ),
      ),
    );
  }

  // void showAddTaskDialog(BuildContext context) {
  //   final int currentDay = DefaultTabController.of(context).index;
  //   _showQuickAddDialog(context, currentDay, 'DERS');
  // }

  Widget _buildFooterQuote(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        children: [
          Text(
            '"Planla"',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);
  final TabBar _tabBar;
  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
