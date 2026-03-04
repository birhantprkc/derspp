import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:drift/drift.dart' hide Column;
import 'dart:convert';

import '../../providers/theme_provider.dart';
import '../../database/database.dart';
import 'package:universal_io/io.dart' as io;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _defaultPlaybackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPreferences();
    });
  }

  Future<void> _loadPreferences() async {
    final db = context.read<AppDatabase>();
    final settings = await db.select(db.settings).get();
    final map = {for (var s in settings) s.key: s.value};

    if (mounted && map.containsKey('defaultPlaybackSpeed')) {
      setState(() {
        _defaultPlaybackSpeed =
            double.tryParse(map['defaultPlaybackSpeed']!) ?? 1.0;
      });
    }
  }

  Future<void> _saveDefaultPlaybackSpeed(double speed) async {
    setState(() {
      _defaultPlaybackSpeed = speed;
    });
    final db = context.read<AppDatabase>();
    await db
        .into(db.settings)
        .insertOnConflictUpdate(
          SettingsCompanion.insert(
            key: 'defaultPlaybackSpeed',
            value: speed.toString(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Ayarlar'),
            titleTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              fontSize: 20,
            ),
            centerTitle: false,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(context, 'Görünüm'),
                  _buildAppearanceSection(context, themeProvider),

                  const SizedBox(height: 24),
                  _buildSectionHeader(context, 'Oynatıcı'),
                  _buildPlayerSection(context, themeProvider),

                  const SizedBox(height: 24),
                  _buildSectionHeader(context, 'Veri & Yedekleme'),
                  _buildDataSection(context),

                  const SizedBox(height: 50),
                  Center(
                    child: Text(
                      'Versiyon 1.0.0',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required List<Widget> children}) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainer,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(children: children),
    );
  }

  Widget _buildAppearanceSection(
    BuildContext context,
    ThemeProvider themeProvider,
  ) {
    return _buildCard(
      context,
      children: [
        ListTile(
          leading: const Icon(Icons.palette_outlined),
          title: const Text('Tema Modu'),
          subtitle: Text(
            themeProvider.themeMode == ThemeMode.system
                ? 'Sistem Teması'
                : themeProvider.themeMode == ThemeMode.light
                ? 'Açık Tema'
                : 'Koyu Tema',
          ),
          trailing: DropdownButtonHideUnderline(
            child: DropdownButton<ThemeMode>(
              value: themeProvider.themeMode,
              borderRadius: BorderRadius.circular(12),
              icon: const Icon(Icons.arrow_drop_down_rounded),
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('Sistem'),
                ),
                DropdownMenuItem(value: ThemeMode.light, child: Text('Açık')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Koyu')),
              ],
              onChanged: (mode) {
                if (mode != null) themeProvider.setThemeMode(mode);
              },
            ),
          ),
        ),
        const Divider(height: 1, indent: 16, endIndent: 16),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vurgu Rengi',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              _buildColorPicker(context, themeProvider),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColorPicker(BuildContext context, ThemeProvider themeProvider) {
    final List<Color> seedColors = [
      Colors.blue,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.pink,
      Colors.red,
      Colors.orange,
      Colors.amber,
      Colors.green,
      Colors.teal,
      Colors.cyan,
    ];

    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildColorOption(
            context,
            color: Theme.of(context).colorScheme.primary,
            isSelected: themeProvider.useDynamicColor,
            isDynamic: true,
            onTap: () => themeProvider.setUseDynamicColor(true),
          ),
          const VerticalDivider(width: 24, indent: 10, endIndent: 10),
          ...seedColors.map(
            (color) => _buildColorOption(
              context,
              color: color,
              isSelected:
                  !themeProvider.useDynamicColor &&
                  themeProvider.customSeedColor.value == color.value,
              onTap: () => themeProvider.setSeedColor(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorOption(
    BuildContext context, {
    required Color color,
    required bool isSelected,
    bool isDynamic = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isDynamic
              ? Theme.of(context).colorScheme.surfaceContainerHigh
              : color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color:
                        (isDynamic
                                ? Theme.of(context).colorScheme.primary
                                : color)
                            .withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: isDynamic
            ? Icon(
                Icons.auto_awesome,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                size: 20,
              )
            : isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 24)
            : null,
      ),
    );
  }

  Widget _buildPlayerSection(
    BuildContext context,
    ThemeProvider themeProvider,
  ) {
    return _buildCard(
      context,
      children: [
        SwitchListTile(
          title: const Text('Karanlık Mod Video Oynatıcı'),
          subtitle: const Text('Playerdaki renkleri tersine çevirir.'),
          secondary: Icon(
            Icons.nightlight_round,
            color: Theme.of(context).colorScheme.primary,
          ),
          value: themeProvider.playerContentDarkMode,
          onChanged: (value) => themeProvider.setPlayerContentDarkMode(value),
        ),
        const Divider(height: 1, indent: 16, endIndent: 16),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Varsayılan Hız',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    '${_defaultPlaybackSpeed}x',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SliderTheme(
                data: SliderTheme.of(
                  context,
                ).copyWith(showValueIndicator: ShowValueIndicator.always),
                child: Slider(
                  value: _defaultPlaybackSpeed,
                  min: 0.5,
                  max: 2.0,
                  divisions: 6,
                  label: '${_defaultPlaybackSpeed}x',
                  onChanged: (value) {
                    _saveDefaultPlaybackSpeed(value);
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('0.5x', style: Theme.of(context).textTheme.bodySmall),
                  Text('2.0x', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataSection(BuildContext context) {
    return _buildCard(
      context,
      children: [
        ListTile(
          leading: const Icon(Icons.upload),
          title: const Text('Yayıncıları Dışa Aktar'),
          subtitle: const Text('JSON formatında'),
          onTap: _exportPublishers,
          trailing: const Icon(Icons.chevron_right),
        ),
        const Divider(height: 1, indent: 16, endIndent: 16),
        ListTile(
          leading: const Icon(Icons.download),
          title: const Text('Yayıncıları İçeri Aktar'),
          subtitle: const Text('JSON dosyası seçin'),
          onTap: _importPublishers,
          trailing: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }

  Future<void> _exportPublishers() async {
    if (kIsWeb) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Web platformunda dışa aktarma henüz desteklenmiyor'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    try {
      final db = context.read<AppDatabase>();
      final publishers = await db.select(db.publishers).get();

      final List<Map<String, dynamic>> jsonList = publishers
          .map(
            (p) => {
              'id': p.id,
              'name': p.name,
              'url': p.url,
              'sourceId': p.sourceId,
              'sourceType': p.scraperType,
            },
          )
          .toList();

      final jsonString = const JsonEncoder.withIndent('  ').convert(jsonList);
      final bytes = utf8.encode(jsonString);

      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Yayıncı Ayarlarını Dışa Aktar',
        fileName: 'publishers.json',
        type: FileType.custom,
        allowedExtensions: ['json'],
        bytes: Uint8List.fromList(bytes),
      );

      if (outputFile != null) {
        if (!kIsWeb &&
            (defaultTargetPlatform == TargetPlatform.windows ||
                defaultTargetPlatform == TargetPlatform.linux ||
                defaultTargetPlatform == TargetPlatform.macOS)) {
          await io.File(outputFile).writeAsString(jsonString);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Yayıncılar başarıyla dışa aktarıldı'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _importPublishers() async {
    if (kIsWeb) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Web platformunda içeri aktarma henüz desteklenmiyor',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Yayıncı Ayarlarını İçeri Aktar',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final jsonString = await io.File(
          result.files.single.path!,
        ).readAsString();
        final List<dynamic> jsonList = jsonDecode(jsonString);

        if (!mounted) return;
        final db = context.read<AppDatabase>();
        int count = 0;

        for (final item in jsonList) {
          if (item is Map<String, dynamic>) {
            await db
                .into(db.publishers)
                .insertOnConflictUpdate(
                  PublishersCompanion.insert(
                    id: Value(item['id']),
                    name: item['name'],
                    url: item['url'],
                    sourceId: item['sourceId'],
                    scraperType: Value(item['sourceType'] ?? 'fsource'),
                  ),
                );
            count++;
          }
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$count yayıncı başarıyla içeri aktarıldı'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
