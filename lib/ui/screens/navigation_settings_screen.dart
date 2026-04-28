import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/navigation_provider.dart';

class NavigationSettingsScreen extends StatelessWidget {
  const NavigationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    final allItems = navProvider.allItems;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: theme.colorScheme.surface,
        title: const Text('Navigasyonu Düzenle'),
        titleTextStyle: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.7),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Sekmelerin yerini değiştirmek için sürükleyin. Bazı sekmeleri gizleyebilirsiniz (Ayarlar her zaman görünür kalır).',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              buildDefaultDragHandles: false,
              onReorder: (oldIndex, newIndex) {
                navProvider.updateOrder(oldIndex, newIndex);
              },
              itemCount: allItems.length,
              itemBuilder: (context, index) {
                final item = allItems[index];
                final bool isSettings = item.type == NavItemType.settings;

                return ListTile(
                  key: ValueKey(item.type),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ReorderableDragStartListener(
                        index: index,
                        child: const Icon(Icons.drag_handle, size: 20),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          navProvider.initialType == item.type
                              ? Icons.home_rounded
                              : Icons.home_outlined,
                          size: 20,
                          color: navProvider.initialType == item.type
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                        onPressed: () => navProvider.setInitialType(item.type),
                        tooltip: 'Başlangıç sekmesi yap',
                      ),
                    ],
                  ),
                  title: Text(item.label, style: const TextStyle(fontSize: 15)),
                  trailing: isSettings
                      ? Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Text(
                            'Sabit',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary.withOpacity(0.6),
                            ),
                          ),
                        )
                      : Switch(
                          value: item.isVisible,
                          onChanged: (_) {
                            navProvider.toggleVisibility(item.type);
                          },
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
