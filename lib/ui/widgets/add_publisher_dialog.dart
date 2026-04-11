import 'package:flutter/material.dart';
import '../../services/source_factory.dart';

class AddPublisherDialog extends StatefulWidget {
  const AddPublisherDialog({super.key});

  @override
  State<AddPublisherDialog> createState() => _AddPublisherDialogState();
}

class _AddPublisherDialogState extends State<AddPublisherDialog> {
  final urlController = TextEditingController();
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final apiUrlController = TextEditingController();
  bool isDiscovering = false;
  bool isValidating = false;
  bool showAdvanced = false;
  String selectedSourceType = 'fsource';
  String? validationError;

  @override
  void dispose() {
    urlController.dispose();
    nameController.dispose();
    idController.dispose();
    apiUrlController.dispose();
    super.dispose();
  }

  Future<bool> _validatePublisher(
    String apiUrl,
    String id,
    String sourceType,
  ) async {
    try {
      final sourceService = SourceFactory.getSourceService(sourceType);

      if (sourceType == 'youtube') {
        final items = await sourceService.fetchSourceList(id, apiUrl);
        return items.isNotEmpty;
      }

      final items = await sourceService.fetchSourceList(id, apiUrl);
      return items.isNotEmpty;
    } catch (e) {
      debugPrint('Validate edilemedi: $e');
      return false;
    }
  }

  Future<void> _handleSave() async {
    if (nameController.text.isEmpty) {
      setState(() => validationError = 'Yayın adı boş olamaz');
      return;
    }

    String apiUrl;
    String id;

    if (showAdvanced) {
      if (apiUrlController.text.isEmpty || idController.text.isEmpty) {
        setState(() => validationError = 'Api url ve id zorunludur');
        return;
      }
      apiUrl = apiUrlController.text.trim();
      if (!apiUrl.startsWith('http')) apiUrl = 'https://$apiUrl';
      id = idController.text.trim();
    } else {
      if (urlController.text.isEmpty) {
        setState(() => validationError = 'Site adresi boş olamaz');
        return;
      }

      var url = urlController.text.trim();
      if (!url.startsWith('http')) url = 'https://$url';

      setState(() {
        isDiscovering = true;
        validationError = null;
      });

      try {
        final sourceService = SourceFactory.getSourceService(
          selectedSourceType,
        );
        final info = await sourceService.discoverPublisherInfo(url);

        if (info['type'] == 'youtube') {
          setState(() {
            selectedSourceType = 'youtube';
          });
        }

        apiUrl = info['apiUrl'] ?? url;
        if (!apiUrl.startsWith('http')) apiUrl = 'https://$apiUrl';

        if (selectedSourceType == 'fsource') {
          final targetUri = Uri.parse(apiUrl);
          if (targetUri.path.isEmpty || targetUri.path == '/') {
            apiUrl = '${targetUri.origin}/mobile_solved/mobile_watch.php';
          }
        }

        id = info['id'] ?? (selectedSourceType == 'f2source' ? 'root' : '2');
      } catch (e) {
        if (mounted) {
          setState(() {
            isDiscovering = false;
            validationError = 'Bağlantı hatası: $e';
          });
        }
        return;
      }
    }

    setState(() {
      isDiscovering = false;
      isValidating = true;
      validationError = null;
    });

    final isValid = await _validatePublisher(apiUrl, id, selectedSourceType);

    if (!mounted) return;

    if (!isValid) {
      setState(() {
        isValidating = false;
        validationError = 'Yayın doğrulanamadı. URL veya ID hatalı olabilir.';
      });
      return;
    }

    Navigator.pop(context, {
      'name': nameController.text.trim(),
      'url': apiUrl,
      'id': id,
      'type': selectedSourceType,
    });
  }

  @override
  Widget build(BuildContext context) {
    final isProcessing = isDiscovering || isValidating;

    return AlertDialog(
      title: const Text('Yeni Yayın Ekle'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Yayın Adı',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Otomatik'),
                    selected: !showAdvanced,
                    onSelected: (_) => setState(() => showAdvanced = false),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Gelişmiş'),
                    selected: showAdvanced,
                    onSelected: (_) => setState(() => showAdvanced = true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (!showAdvanced) ...[
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
                  labelText: 'Site Adresi',
                  border: OutlineInputBorder(),
                ),
              ),
            ] else ...[
              TextField(
                controller: apiUrlController,
                decoration: const InputDecoration(
                  labelText: 'API URL',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: idController,
                decoration: const InputDecoration(
                  labelText: 'Başlangıç ID',
                  border: OutlineInputBorder(),
                ),
              ),
            ],

            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedSourceType,
              decoration: const InputDecoration(
                labelText: 'Kaynak Tipi',
                border: OutlineInputBorder(),
              ),
              items: SourceFactory.availableSourceTypes.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: isProcessing
                  ? null
                  : (val) {
                      if (val != null) {
                        setState(() => selectedSourceType = val);
                      }
                    },
            ),

            if (validationError != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  validationError!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),

            if (isProcessing)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isDiscovering ? 'Keşfediliyor...' : 'Doğrulanıyor...',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isProcessing ? null : () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        FilledButton(
          onPressed: isProcessing ? null : _handleSave,
          child: const Text('Ekle'),
        ),
      ],
    );
  }
}
