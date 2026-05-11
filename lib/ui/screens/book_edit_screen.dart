import 'dart:convert';
import 'package:universal_io/io.dart' as io;
import 'package:flutter/foundation.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:crop_image/crop_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';
import '../../models/saved_book.dart';
import '../../providers/book_provider.dart';
import '../widgets/platform_image.dart';

class _ImageProcessParams {
  final Uint8List bytes;
  final Rect? cropRect;

  _ImageProcessParams({
    required this.bytes,
    this.cropRect,
  });
}

Future<Uint8List?> _processImageInBackground(_ImageProcessParams params) async {
  img.Image? image = img.decodeImage(params.bytes);
  if (image == null) return null;

  const int maxDimension = 2000;
  if (image.width > maxDimension || image.height > maxDimension) {
    image = img.copyResize(
      image,
      width: image.width > image.height ? maxDimension : null,
      height: image.height >= image.width ? maxDimension : null,
      interpolation: img.Interpolation.average,
    );
  }

  if (params.cropRect != null) {
    final rect = params.cropRect!;
    final x = (rect.left * image.width).round();
    final y = (rect.top * image.height).round();
    final w = (rect.width * image.width).round();
    final h = (rect.height * image.height).round();

    image = img.copyCrop(image, x: x, y: y, width: w, height: h);
  }

  return Uint8List.fromList(img.encodePng(image));
}

class BookEditScreen extends StatefulWidget {
  final SavedBook book;

  const BookEditScreen({super.key, required this.book});

  @override
  State<BookEditScreen> createState() => _BookEditScreenState();
}

class _BookEditScreenState extends State<BookEditScreen> {
  bool _isCropping = false;
  late CropController _cropController;
  late TextEditingController _nameController;

  Uint8List? _originalImageBytes;
  Uint8List? _currentImageBytes;
  bool _newImagePicked = false;

  @override
  void initState() {
    super.initState();
    _cropController = CropController(aspectRatio: 0.72);
    _nameController = TextEditingController(text: widget.book.name);
  }

  Future<void> _loadOriginalImageIfNeeded() async {
    if (_originalImageBytes != null) return;

    String? sourcePath;
    if (widget.book.originalCoverImage != null) {
      sourcePath = widget.book.originalCoverImage!;
    } else if (widget.book.coverImage != null) {
      sourcePath = widget.book.coverImage!;
    }

    if (sourcePath != null) {
      if (kIsWeb && sourcePath.startsWith('data:image')) {
        final base64String = sourcePath.split(',').last;
        _originalImageBytes = base64Decode(base64String);
      } else if (await io.File(sourcePath).exists()) {
        _originalImageBytes = await io.File(sourcePath).readAsBytes();
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _originalImageBytes = bytes;
        _currentImageBytes = bytes;
        _newImagePicked = true;
        _isCropping = true;
      });
    }
  }

  Future<void> _startCropping() async {
    await _loadOriginalImageIfNeeded();
    if (_originalImageBytes == null) return;

    setState(() {
      _isCropping = true;
    });
  }

  Future<void> _applyCrop() async {
    if (_originalImageBytes == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Resim işleniyor...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final rect = _cropController.crop;

      final processedBytes = await compute(
        _processImageInBackground,
        _ImageProcessParams(bytes: _originalImageBytes!, cropRect: rect),
      );

      if (mounted) {
        Navigator.pop(context);
        if (processedBytes != null) {
          setState(() {
            _currentImageBytes = processedBytes;
            _isCropping = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Hata: $e')));
      }
    }
  }

  void _removeCover() {
    setState(() {
      _originalImageBytes = null;
      _currentImageBytes = null;
      _newImagePicked = true;
    });
  }

  Future<void> _saveAndClose() async {
    String? newOriginalPath = widget.book.originalCoverImage;
    String? newCoverPath = widget.book.coverImage;

    if (_newImagePicked && _originalImageBytes != null) {
      newOriginalPath = await context.read<BookProvider>().saveCoverImage(
        '${widget.book.id}_original',
        _originalImageBytes!,
        oldPath: widget.book.originalCoverImage,
      );
    }

    if (!mounted) return;

    if (_currentImageBytes != null) {
      newCoverPath = await context.read<BookProvider>().saveCoverImage(
        widget.book.id,
        _currentImageBytes!,
        oldPath: widget.book.coverImage,
      );
    } else if (_newImagePicked && _originalImageBytes == null) {
      newOriginalPath = null;
      newCoverPath = null;
    }

    if (newCoverPath != widget.book.coverImage ||
        newOriginalPath != widget.book.originalCoverImage ||
        widget.book.name != _nameController.text) {
      final updatedBook = widget.book
        ..name = _nameController.text
        ..coverImage = newCoverPath
        ..originalCoverImage = newOriginalPath;

      if (mounted) {
        await context.read<BookProvider>().updateBook(updatedBook);
      }
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _deleteBook() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Kitabı Sil'),
        content: Text(
          '${widget.book.name} kitabını silmek istediğinizden emin misiniz?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await context.read<BookProvider>().deleteBook(widget.book);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),
          GestureDetector(onTap: () => Navigator.pop(context)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 20),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.45,
                            child: _isCropping
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.white24),
                                    ),
                                    child: CropImage(
                                      controller: _cropController,
                                      image: Image(
                                        image: MemoryImage(
                                          _originalImageBytes!,
                                        ),
                                      ),
                                      gridColor: Colors.white70,
                                      scrimColor: Colors.black54,
                                      alwaysShowThirdLines: true,
                                      minimumImageSize: 50,
                                    ),
                                  )
                                : Hero(
                                    tag: widget.book.id,
                                    child: ClipRRect(
                                      child: _buildCoverImage(context),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 12),
                          if (!_isCropping)
                            TextField(
                              controller: _nameController,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: 'Kitap İsmi',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                border: InputBorder.none,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                          const SizedBox(height: 32),
                          _isCropping
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          _isCropping = false;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white70,
                                      ),
                                      label: const Text('İptal'),
                                    ),
                                    FilledButton.icon(
                                      onPressed: _applyCrop,
                                      icon: const Icon(Icons.check),
                                      label: const Text('Kırp'),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildActionButton(
                                      icon: Icons.close,
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    _buildActionButton(
                                      icon: Icons.delete_forever,
                                      onPressed: _deleteBook,
                                    ),
                                    _buildActionButton(
                                      icon: Icons.image_not_supported,
                                      onPressed: _removeCover,
                                    ),
                                    _buildActionButton(
                                      icon: Icons.photo_library_outlined,
                                      onPressed: _pickImage,
                                    ),
                                    _buildActionButton(
                                      icon: Icons.crop,
                                      onPressed: _startCropping,
                                    ),
                                    _buildActionButton(
                                      icon: Icons.check,
                                      onPressed: _saveAndClose,
                                    ),
                                  ],
                                ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverImage(BuildContext context) {
    if (_currentImageBytes != null) {
      return Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.45,
        ),
        child: Image.memory(_currentImageBytes!, fit: BoxFit.contain),
      );
    }
    if (!_newImagePicked &&
        widget.book.coverImage != null &&
        widget.book.coverImage!.isNotEmpty) {
      return Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.45,
        ),
        child: PlatformImage(
          path: widget.book.coverImage!,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _buildPlaceholder(context),
        ),
      );
    }

    return AspectRatio(aspectRatio: 0.72, child: _buildPlaceholder(context));
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      alignment: Alignment.center,
      child: Icon(
        Icons.book,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        size: 96,
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Icon(icon, size: 28),
        ),
      ),
    );
  }
}
