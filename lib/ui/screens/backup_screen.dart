import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:drift/drift.dart' hide Column;
import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart' as io;

import '../../database/database.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: theme.colorScheme.surface,
        title: const Text('Veri & Yedekleme'),
        titleTextStyle: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.7),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(context, 'DIŞA AKTARMA'),
              _buildActionTile(
                context,
                icon: Icons.north_east_rounded,
                title: 'Yayıncıları Dışa Aktar',
                subtitle: 'JSON',
                onTap: _exportPublishers,
              ),
              _buildActionTile(
                context,
                icon: Icons.unarchive_outlined,
                title: 'Kitapları Dışa Aktar',
                subtitle: 'ZIP',
                onTap: _exportBooks,
              ),
              const SizedBox(height: 32),
              _buildSectionHeader(context, 'İÇERİ AKTARMA'),
              _buildActionTile(
                context,
                icon: Icons.south_west_rounded,
                title: 'Yayıncıları İçeri Aktar',
                subtitle: 'JSON',
                onTap: _importPublishers,
              ),
              _buildActionTile(
                context,
                icon: Icons.archive_outlined,
                title: 'Kitapları İçeri Aktar',
                subtitle: 'ZIP',
                onTap: _importBooks,
              ),
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

  Widget _buildActionTile(
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

      if (!kIsWeb) {
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
      }

      final zipEncoder = ZipEncoder();
      final zipData = zipEncoder.encode(archive);
      if (zipData == null) throw Exception('ZIP oluşturulamadı');

      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Kitapları Dışa Aktar',
        fileName: 'books_backup.zip',
        type: FileType.custom,
        allowedExtensions: ['zip'],
        bytes: Uint8List.fromList(zipData),
      );

      if (outputFile != null || kIsWeb) {
        if (!kIsWeb &&
            outputFile != null &&
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
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Kitapları İçeri Aktar',
        type: FileType.custom,
        allowedExtensions: ['zip'],
        withData: true,
      );

      if (result != null) {
        final bytes = kIsWeb
            ? result.files.single.bytes
            : await io.File(result.files.single.path!).readAsBytes();

        if (bytes == null) throw Exception('Dosya okunamadı');
        final archive = ZipDecoder().decodeBytes(bytes);

        final booksFile = archive.findFile('books.json');
        if (booksFile == null) throw Exception('books.json bulunamadı');

        final jsonString = utf8.decode(booksFile.content as List<int>);
        final List<dynamic> jsonList = jsonDecode(jsonString);

        String? coversPath;
        if (!kIsWeb) {
          final docsDir = await getApplicationSupportDirectory();
          coversPath = p.join(docsDir.path, 'book_covers');
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
        }

        if (!mounted) return;
        final db = context.read<AppDatabase>();
        int count = 0;

        for (final item in jsonList) {
          if (item is Map<String, dynamic>) {
            String? newCoverPath;
            String? newOriginalCoverPath;

            if (!kIsWeb && item['coverImage'] != null) {
              newCoverPath = p.join(coversPath!, p.basename(item['coverImage']));
            }
            if (!kIsWeb && item['originalCoverImage'] != null) {
              newOriginalCoverPath = p.join(
                coversPath!,
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

      if (outputFile != null || kIsWeb) {
        if (!kIsWeb &&
            outputFile != null &&
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
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Yayıncı Ayarlarını İçeri Aktar',
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: true,
      );

      if (result != null) {
        final bytes = kIsWeb
            ? result.files.single.bytes
            : await io.File(result.files.single.path!).readAsBytes();

        if (bytes == null) throw Exception('Dosya okunamadı');

        final jsonString = utf8.decode(bytes);
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
