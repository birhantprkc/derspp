import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:universal_io/io.dart' as io;

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  int _clickCount = 0;
  bool _showEasterEgg = false;
  final FToast _fToast = FToast();

  @override
  void initState() {
    super.initState();
    _fToast.init(context);
  }

  void _showInstantToast(String message, ThemeData theme) {
    _fToast.removeCustomToast();
    _fToast.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.black87,
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  static const _toastChannel = MethodChannel('me.navidicted.derspp/toast');

  void _notify(String message, ThemeData theme) {
    if (kIsWeb || theme.platform != TargetPlatform.android) {
      _showInstantToast(message, theme);
    } else {
      _toastChannel.invokeMethod('showToast', {'message': message});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: theme.colorScheme.surface,
        title: const Text('Hakkında'),
        titleTextStyle: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.7),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Center(
              child: GestureDetector(
                onTap: () {
                  if (_showEasterEgg) return;
                  setState(() {
                    _clickCount++;
                    if (_clickCount >= 1 && _clickCount < 7) {
                      final remaining = 7 - _clickCount;
                      _notify('Keep going, $remaining more times left', theme);
                    } else if (_clickCount >= 7) {
                      _showEasterEgg = true;
                      _notify(
                        "~you've been a good test subject, derspp user~",
                        theme,
                      );
                    }
                  });
                },
                child: Column(
                  children: [
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            blurRadius: 25,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.auto_stories_rounded,
                            size: 70,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'derspp',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'uma version 3.0',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoTile(
                    context,
                    icon: Icons.favorite,
                    title: 'Built with hopes and dreams',
                    subtitle: 'Umarım uygulamayı beğenmişsindir.',
                  ),
                  const SizedBox(height: 32),
                  _buildSectionHeader(context, 'BAĞLANTILAR'),
                  _buildLinkTile(
                    context,
                    icon: Icons.language_rounded,
                    title: 'Web Sitesi',
                    onTap: () => _launchUrl('derspp.navidicted.workers.dev'),
                  ),
                  _buildLinkTile(
                    context,
                    icon: Icons.language_rounded,
                    title: 'Lisans',
                    onTap: () => _launchUrl(
                      'https://github.com/navidicted/derspp/blob/master/LICENSE',
                    ),
                  ),
                  _buildLinkTile(
                    context,
                    icon: Icons.language_rounded,
                    title: 'Github',
                    onTap: () => _launchUrl('https://github.com/navidicted/'),
                  ),
                  _buildLinkTile(
                    context,
                    icon: Icons.language_rounded,
                    title: 'Güncelleme tespit et',
                    onTap: () => _launchUrl(
                      'https://github.com/navidicted/derspp/releases/latest',
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_showEasterEgg)
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildBadgeTile(
                          context,
                          icon: Icons.music_note,
                          title: 'honorable mention to',
                          subtitle: 'The Gunu Gurub',
                          onTap: () => _launchUrl(
                            'https://www.youtube.com/@GunuGurub39',
                          ),
                        ),
                        _buildBadgeTile(
                          context,
                          icon: Icons.science_rounded,
                          title: 'low cortisol mention to',
                          subtitle: 'Agnes Tachyon',
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                insetPadding: const EdgeInsets.all(20),
                                child: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 30,
                                          spreadRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: Image.network(
                                        'https://raw.githubusercontent.com/navidicted/navi-assets/main/assets/lowcortisol.gif',
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return const SizedBox(
                                                width: 200,
                                                height: 200,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              );
                                            },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        _buildBadgeTile(
                          context,
                          icon: Icons.star,
                          title: 'dear psjk please',
                          subtitle: 'give my account BACK',
                          onTap: () => _launchUrl(
                            'https://sega.helpshift.com/hc/en/12-hatsune-miku-colorful-stage/',
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'larp forever.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.2),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
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

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLinkTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(icon, size: 20),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      trailing: const Icon(Icons.open_in_new_rounded, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildBadgeTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: theme.colorScheme.primary.withOpacity(0.7),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary.withOpacity(0.8),
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }
}
