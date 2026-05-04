import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../../database/database.dart';
import '../../services/cors_proxy_service.dart';
import '../widgets/theme_widget.dart';
import 'navigation_settings_screen.dart';
import 'backup_screen.dart';
import 'about_screen.dart';
import '../../services/update_service.dart';
import 'update_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _defaultPlaybackSpeed = 1.0;
  bool _corsProxyEnabled = true;
  bool _transcriptionAsChunks = true;
  final TextEditingController _corsProxyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPreferences();
    });
  }

  @override
  void dispose() {
    _corsProxyController.dispose();
    super.dispose();
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

    if (mounted && map.containsKey('corsProxyUrl')) {
      _corsProxyController.text = map['corsProxyUrl']!;
    }
    if (mounted && map.containsKey('corsProxyEnabled')) {
      setState(() {
        _corsProxyEnabled = map['corsProxyEnabled'] == 'true';
      });
    }

    if (mounted && map.containsKey('transcriptionAsChunks')) {
      setState(() {
        _transcriptionAsChunks = map['transcriptionAsChunks'] != 'false';
      });
    }
  }

  Future<void> _saveCorsProxyUrl(String url) async {
    final db = context.read<AppDatabase>();
    final trimmed = url.trim();
    await db
        .into(db.settings)
        .insertOnConflictUpdate(
          SettingsCompanion.insert(key: 'corsProxyUrl', value: trimmed),
        );
    CorsProxyService.instance.updateProxyUrl(trimmed);
  }

  Future<void> _saveCorsProxyEnabled(bool enabled) async {
    setState(() {
      _corsProxyEnabled = enabled;
    });
    final db = context.read<AppDatabase>();
    await db
        .into(db.settings)
        .insertOnConflictUpdate(
          SettingsCompanion.insert(
            key: 'corsProxyEnabled',
            value: enabled.toString(),
          ),
        );
    CorsProxyService.instance.updateProxyEnabled(enabled);
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

  Future<void> _saveTranscriptionAsChunks(bool enabled) async {
    setState(() {
      _transcriptionAsChunks = enabled;
    });
    final db = context.read<AppDatabase>();
    await db
        .into(db.settings)
        .insertOnConflictUpdate(
          SettingsCompanion.insert(
            key: 'transcriptionAsChunks',
            value: enabled.toString(),
          ),
        );
  }

  Future<void> _checkUpdate() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final updateData = await UpdateService.checkUpdate();

    if (mounted) Navigator.pop(context);

    if (mounted) {
      _pushScreen(context, UpdateScreen(releaseData: updateData));
    }
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
              const SizedBox(height: 8),
              _buildSectionHeader(context, 'OYNATICI'),
              _buildPlayerSection(context, themeProvider),

              if (kIsWeb) ...[
                const SizedBox(height: 8),
                _buildSectionHeader(context, 'WEB - CORS PROXY'),
                _buildCorsProxySection(context),
              ],

              _buildSectionHeader(context, 'SİSTEM'),
              _buildMinimalActionTile(
                context,
                icon: Icons.format_list_bulleted_rounded,
                title: 'Navigasyon Çubuğunu Düzenle',
                subtitle: 'Sekme sırasını ve görünürlüğü ayarla',
                onTap: () {
                  _pushScreen(context, const NavigationSettingsScreen());
                },
              ),
              _buildMinimalActionTile(
                context,
                icon: Icons.storage_rounded,
                title: 'Veri & Yedekleme',
                subtitle: 'İçe ve dışa aktarma işlemleri',
                onTap: () {
                  _pushScreen(context, const BackupScreen());
                },
              ),

              _buildMinimalActionTile(
                context,
                icon: Icons.info_outline_rounded,
                title: 'Hakkında',
                subtitle: 'Uygulama bilgileri ve versiyon',
                onTap: () {
                  _pushScreen(context, const AboutScreen());
                },
              ),
              _buildMinimalActionTile(
                context,
                icon: Icons.update_rounded,
                title: 'Güncelleştirmeleri Denetle',
                subtitle: 'Yeni bir sürüm olup olmadığını kontrol et',
                onTap: _checkUpdate,
              ),
              _buildTranscriptionSection(context),

              const SizedBox(height: 50),
              Center(
                child: Text(
                  'uma version 3.0',
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
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 16),
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

  void _pushScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 250),
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
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: ThemeSettingsWidget(),
        ),
      ],
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
        const SizedBox(height: 4),
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
                      fontSize: 12,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.5),
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
                  max: 2.0,
                  divisions: 6,
                  onChanged: (value) => _saveDefaultPlaybackSpeed(value),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTranscriptionSection(BuildContext context) {
    return _buildCard(
      context,
      children: [
        SwitchListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          title: const Text(
            'Altyazı Parçalı Gönderim',
            style: TextStyle(fontSize: 15),
          ),
          subtitle: Text(
            'Transkripsiyonda sorun yaşıyorsanız kapatın',
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          secondary: const Icon(Icons.subtitles, size: 20),
          value: _transcriptionAsChunks,
          onChanged: _saveTranscriptionAsChunks,
        ),
      ],
    );
  }

  Widget _buildCorsProxySection(BuildContext context) {
    return _buildCard(
      context,
      children: [
        SwitchListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          title: const Text('CORS Proxy Aktif', style: TextStyle(fontSize: 15)),
          subtitle: Text(
            'Web sürümünde harici sitelere erişmek için gereklidir.',
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          secondary: const Icon(Icons.public, size: 20),
          value: _corsProxyEnabled,
          onChanged: _saveCorsProxyEnabled,
        ),
        if (_corsProxyEnabled) ...[
          Divider(
            height: 32,
            color: Theme.of(
              context,
            ).colorScheme.outlineVariant.withOpacity(0.5),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 14),
                TextField(
                  controller: _corsProxyController,
                  decoration: InputDecoration(
                    labelText: 'CORS Proxy URL',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      tooltip: 'Temizle',
                      onPressed: () {
                        _corsProxyController.clear();
                        _saveCorsProxyUrl('');
                      },
                    ),
                  ),
                  style: const TextStyle(fontSize: 13),
                  keyboardType: TextInputType.url,
                  autocorrect: false,
                  onSubmitted: _saveCorsProxyUrl,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    FilledButton.tonal(
                      onPressed: () =>
                          _saveCorsProxyUrl(_corsProxyController.text),
                      child: const Text('Kaydet'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        _corsProxyController.text = '';
                        _saveCorsProxyUrl('');
                      },
                      child: const Text('Varsayılanı Kullan'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
}
