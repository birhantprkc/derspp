import 'package:flutter/material.dart';
import '../../services/update_service.dart';
import '../screens/update_screen.dart';

class UpdateCheckerWrapper extends StatefulWidget {
  final Widget child;
  const UpdateCheckerWrapper({super.key, required this.child});

  @override
  State<UpdateCheckerWrapper> createState() => _UpdateCheckerWrapperState();
}

class _UpdateCheckerWrapperState extends State<UpdateCheckerWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUpdate();
    });
  }

  Future<void> _checkUpdate() async {
    if (await UpdateService.shouldCheckNow()) {
      final releaseData = await UpdateService.checkUpdate();
      if (releaseData != null && mounted) {
        _showUpdatePrompt(releaseData);
      }
    }
  }

  void _showUpdatePrompt(Map<String, dynamic> releaseData) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tagName = releaseData['tag_name'];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.system_update_rounded,
              color: colorScheme.onPrimaryContainer,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Yeni Sürüm Mevcut ($tagName)',
                style: TextStyle(color: colorScheme.onPrimaryContainer),
              ),
            ),
          ],
        ),
        backgroundColor: colorScheme.primaryContainer,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 10),
        action: SnackBarAction(
          label: 'GÖSTER',
          textColor: colorScheme.primary,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UpdateScreen(releaseData: releaseData),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
