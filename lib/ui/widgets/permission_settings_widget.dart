import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class PermissionSettingsWidget extends StatefulWidget {
  const PermissionSettingsWidget({super.key});

  @override
  State<PermissionSettingsWidget> createState() =>
      _PermissionSettingsWidgetState();
}

class _PermissionSettingsWidgetState extends State<PermissionSettingsWidget>
    with WidgetsBindingObserver {
  bool _installPermission = false;
  bool _notificationPermission = false;
  bool _batteryPermission = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    if (kIsWeb || !Platform.isAndroid) return;
    final install = await Permission.requestInstallPackages.status;
    final notification = await Permission.notification.status;
    final battery = await Permission.ignoreBatteryOptimizations.status;
    if (mounted) {
      setState(() {
        _installPermission = install.isGranted;
        _notificationPermission = notification.isGranted;
        _batteryPermission = battery.isGranted;
      });
    }
  }

  Future<void> _request(Permission permission) async {
    final status = await permission.request();
    if (status.isPermanentlyDenied) await openAppSettings();
    _checkPermissions();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || !Platform.isAndroid) return const SizedBox.shrink();

    return Column(
      children: [
        _PermissionTile(
          icon: Icons.security_rounded,
          title: 'Yükleme İzni',
          subtitle: 'Uygulama içinden kurulum',
          isGranted: _installPermission,
          onTap: _installPermission
              ? openAppSettings
              : () => _request(Permission.requestInstallPackages),
        ),
        const SizedBox(height: 8),
        _PermissionTile(
          icon: Icons.notifications_outlined,
          title: 'Bildirim İzni',
          subtitle: 'İndirme ilerlemesi',
          isGranted: _notificationPermission,
          onTap: _notificationPermission
              ? openAppSettings
              : () => _request(Permission.notification),
        ),
        const SizedBox(height: 8),
        _PermissionTile(
          icon: Icons.battery_saver_outlined,
          title: 'Pil Muafiyeti',
          subtitle: 'Arka plan indirme',
          isGranted: _batteryPermission,
          onTap: _batteryPermission
              ? openAppSettings
              : () => _request(Permission.ignoreBatteryOptimizations),
        ),
      ],
    );
  }
}

class _PermissionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isGranted;
  final VoidCallback onTap;

  const _PermissionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isGranted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isGranted
                ? colorScheme.primary.withOpacity(0.4)
                : colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isGranted
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isGranted ? Icons.check_circle_rounded : Icons.circle_outlined,
              size: 20,
              color: isGranted
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
