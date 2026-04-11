import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:drift/drift.dart' hide Column;
import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

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
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: theme.colorScheme.surface,
        centerTitle: false,
        title: const Text('Ayarlar'),
        titleTextStyle: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.7),
          fontSize: 20,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(context, 'GÖRÜNÜM'),
              _buildAppearanceSection(context, themeProvider),

              const SizedBox(height: 32),
              _buildSectionHeader(context, 'OYNATICI'),
              _buildPlayerSection(context, themeProvider),

              const SizedBox(height: 32),
              _buildSectionHeader(context, 'VERİ & YEDEKLEME'),
              _buildDataSection(context),

              const SizedBox(height: 50),
              Center(
                child: Text(
                  'Versiyon: uma version 3.0',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required List<Widget> children}) {
    return Column(children: children);
  }

  Widget _buildAppearanceSection(
    BuildContext context,
    ThemeProvider themeProvider,
  ) {
    return _buildCard(
      context,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          leading: const Icon(Icons.palette_outlined, size: 20),
          title: const Text('Tema', style: TextStyle(fontSize: 15)),
          subtitle: Text(
            themeProvider.themeMode == ThemeMode.system
                ? 'Sistem Teması'
                : themeProvider.themeMode == ThemeMode.light
                ? 'Açık Tema'
                : 'Koyu Tema',
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          trailing: DropdownButtonHideUnderline(
            child: DropdownButton<ThemeMode>(
              value: themeProvider.themeMode,
              borderRadius: BorderRadius.circular(4),
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
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
        Divider(
          height: 32,
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vurgu Rengi',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 16),
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
      height: 48,
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
          const SizedBox(width: 12),
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
        width: 36,
        height: 36,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isDynamic
              ? Theme.of(context).colorScheme.surfaceVariant
              : color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.onSurface
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: isDynamic
            ? Icon(
                Icons.auto_awesome,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                size: 16,
              )
            : isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 18)
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          title: const Text(
            'Karanlık Mod Video Oynatıcı',
            style: TextStyle(fontSize: 15),
          ),
          subtitle: Text(
            'Playerdaki renkleri tersine çevirir.',
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          secondary: const Icon(Icons.nightlight_round, size: 20),
          value: themeProvider.playerContentDarkMode,
          onChanged: (value) => themeProvider.setPlayerContentDarkMode(value),
        ),
        Divider(
          height: 32,
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Varsayılan Hız',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    '${_defaultPlaybackSpeed}x',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 2,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 6,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 12,
                  ),
                  activeTrackColor: Theme.of(context).colorScheme.primary,
                  inactiveTrackColor: Theme.of(
                    context,
                  ).colorScheme.outlineVariant,
                  thumbColor: Theme.of(context).colorScheme.primary,
                ),
                child: Slider(
                  value: _defaultPlaybackSpeed,
                  min: 0.5,
                  max: 4.0,
                  divisions: 7,
                  onChanged: (value) => _saveDefaultPlaybackSpeed(value),
                ),
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
        _buildMinimalActionTile(
          context,
          icon: Icons.north_east,
          title: 'Yayıncıları Dışa Aktar',
          subtitle: 'JSON',
          onTap: _exportPublishers,
        ),
        _buildMinimalActionTile(
          context,
          icon: Icons.south_west,
          title: 'Yayıncıları İçeri Aktar',
          subtitle: 'JSON',
          onTap: _importPublishers,
        ),
        _buildMinimalActionTile(
          context,
          icon: Icons.unarchive_outlined,
          title: 'Kitapları Dışa Aktar',
          subtitle: 'ZIP',
          onTap: _exportBooks,
        ),
        _buildMinimalActionTile(
          context,
          icon: Icons.archive_outlined,
          title: 'Kitapları İçeri Aktar',
          subtitle: 'ZIP',
          onTap: _importBooks,
        ),
      ],
    );
  }

  Widget _buildMinimalActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(icon, size: 20),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
      ),
      onTap: onTap,
      trailing: const Icon(Icons.chevron_right, size: 20),
    );
  }

  Future<void> _exportBooks() async {
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
      final books = await db.select(db.books).get();

      final List<Map<String, dynamic>> jsonList = books
          .map(
            (b) => {
              'id': b.id,
              'name': b.name,
              'sourceId': b.sourceId,
              'baseUrl': b.baseUrl,
              'addedDate': b.addedDate.toIso8601String(),
              'coverImage': b.coverImage,
              'originalCoverImage': b.originalCoverImage,
              'position': b.position,
              'scraperType': b.scraperType,
            },
          )
          .toList();

      final jsonString = const JsonEncoder.withIndent('  ').convert(jsonList);

      final archive = Archive();

      final jsonBytes = utf8.encode(jsonString);
      archive.addFile(ArchiveFile('books.json', jsonBytes.length, jsonBytes));

      for (final book in books) {
        if (book.coverImage != null && book.coverImage!.isNotEmpty) {
          final file = io.File(book.coverImage!);
          if (await file.exists()) {
            final bytes = await file.readAsBytes();
            archive.addFile(
              ArchiveFile(
                'covers/${p.basename(book.coverImage!)}',
                bytes.length,
                bytes,
              ),
            );
          }
        }
        if (book.originalCoverImage != null &&
            book.originalCoverImage!.isNotEmpty) {
          final file = io.File(book.originalCoverImage!);
          if (await file.exists()) {
            final bytes = await file.readAsBytes();
            archive.addFile(
              ArchiveFile(
                'covers/${p.basename(book.originalCoverImage!)}',
                bytes.length,
                bytes,
              ),
            );
          }
        }
      }

      final zipEncoder = ZipEncoder();
      final zipData = zipEncoder.encode(archive);

      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Kitapları Dışa Aktar',
        fileName: 'books_backup.zip',
        type: FileType.custom,
        allowedExtensions: ['zip'],
        bytes: Uint8List.fromList(zipData),
      );

      if (outputFile != null) {
        if (!kIsWeb &&
            (defaultTargetPlatform == TargetPlatform.windows ||
                defaultTargetPlatform == TargetPlatform.linux ||
                defaultTargetPlatform == TargetPlatform.macOS)) {
          await io.File(outputFile).writeAsBytes(zipData);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kitaplar ve kapaklar başarıyla dışa aktarıldı'),
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

  Future<void> _importBooks() async {
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
        dialogTitle: 'Kitapları İçeri Aktar',
        type: FileType.custom,
        allowedExtensions: ['zip'],
      );

      if (result != null && result.files.single.path != null) {
        final bytes = await io.File(result.files.single.path!).readAsBytes();
        final archive = ZipDecoder().decodeBytes(bytes);

        final booksFile = archive.findFile('books.json');
        if (booksFile == null) throw Exception('books.json bulunamadı');

        final jsonString = utf8.decode(booksFile.content as List<int>);
        final List<dynamic> jsonList = jsonDecode(jsonString);

        final docsDir = await getApplicationDocumentsDirectory();
        final coversPath = p.join(docsDir.path, 'book_covers');
        final coversDir = io.Directory(coversPath);
        if (!await coversDir.exists()) {
          await coversDir.create(recursive: true);
        }

        for (final file in archive) {
          if (file.isFile && file.name.startsWith('covers/')) {
            final filename = p.basename(file.name);
            final destPath = p.join(coversPath, filename);
            await io.File(destPath).writeAsBytes(file.content as List<int>);
          }
        }

        if (!mounted) return;
        final db = context.read<AppDatabase>();
        int count = 0;

        for (final item in jsonList) {
          if (item is Map<String, dynamic>) {
            String? newCoverPath;
            String? newOriginalCoverPath;

            if (item['coverImage'] != null) {
              newCoverPath = p.join(coversPath, p.basename(item['coverImage']));
            }
            if (item['originalCoverImage'] != null) {
              newOriginalCoverPath = p.join(
                coversPath,
                p.basename(item['originalCoverImage']),
              );
            }

            await db
                .into(db.books)
                .insertOnConflictUpdate(
                  BooksCompanion.insert(
                    id: item['id'],
                    name: item['name'],
                    sourceId: item['sourceId'],
                    baseUrl: item['baseUrl'],
                    addedDate:
                        DateTime.tryParse(item['addedDate'] ?? '') ??
                        DateTime.now(),
                    coverImage: Value(newCoverPath),
                    originalCoverImage: Value(newOriginalCoverPath),
                    position: Value(item['position'] ?? 0),
                    scraperType: Value(item['scraperType'] ?? 'fsource'),
                  ),
                );
            count++;
          }
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$count kitap ve kapakları içeri aktarıldı'),
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
