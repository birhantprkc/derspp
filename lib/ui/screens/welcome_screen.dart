import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../navi_bar.dart';
import '../../providers/theme_provider.dart';
import '../widgets/theme_widget.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finishWelcome() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('welcome_shown', true);
    if (mounted) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const NaviBar()));
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 339),
        curve: Curves.easeInOut,
      );
    } else {
      _finishWelcome();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 339),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Opacity(
                        opacity: _currentPage > 0 ? 1.0 : 0.0,
                        child: IgnorePointer(
                          ignoring: _currentPage == 0,
                          child: IconButton(
                            onPressed: _previousPage,
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                            iconSize: 20,
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: _currentPage < _totalPages - 1 ? 1.0 : 0.0,
                        child: IgnorePointer(
                          ignoring: _currentPage == _totalPages - 1,
                          child: TextButton(
                            onPressed: _finishWelcome,
                            child: Text(
                              'Atla',
                              style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.6),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(_totalPages, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(left: 6),
                        width: _currentPage == index ? 20 : 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? colorScheme.primary
                              : colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _buildFirstPage(context, themeProvider, colorScheme),
                  _buildSecondPage(colorScheme),
                  _buildThirdPage(colorScheme),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(36.0),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _nextPage,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    _currentPage == _totalPages - 1 ? "Bitir" : 'Devam Et',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstPage(
    BuildContext context,
    ThemeProvider themeProvider,
    ColorScheme colorScheme,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              height: 200,
              width: 200,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            "Hoş geldin.",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Aşağıdan istediğin temayı seç ve devam et düğmesine bas",
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurface.withOpacity(0.65),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          const ThemeSettingsWidget(),
        ],
      ),
    );
  }

  Widget _buildSecondPage(ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/images/logo.png', height: 140, width: 140),
          const SizedBox(height: 24),
          Text(
            "derspp nedir?",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "derspp, kullanıcın belirttiği sağlayıcılardan video çözümlerini çeker ve çekilen video çözümleriyle kullanıcıya iyi bir arayüzde sunan bir uygulamadır. Uygulamanın video çözüm dışında birçok özelliği de vardır",
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onPrimaryContainer.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 24),
          _buildFeatureRow(
            colorScheme,
            icon: Icons.play_circle_outline_rounded,
            title: 'Tüm Video çözümler tek bir yerde',
            subtitle:
                'Tek bir uygulamadan izleyip kapak fotoğraflarına istediğin fotoğrafları koy',
          ),
          const SizedBox(height: 16),
          _buildFeatureRow(
            colorScheme,
            icon: Icons.calendar_today_rounded,
            title: 'Haftalık Planlama sistemi',
            subtitle:
                'Hiçbir todolist uygulamasında haftalık bir şekilde alamıyorsun btw iusearchbtw',
          ),
          const SizedBox(height: 16),
          _buildFeatureRow(
            colorScheme,
            icon: Icons.collections_bookmark,
            title: 'Soru kaydetme',
            subtitle: 've aralıklı tekrarlama',
          ),
          const SizedBox(height: 16),
          _buildFeatureRow(
            colorScheme,
            icon: Icons.checklist,
            title: 'Konu Takip sistemi',
            subtitle: '1 haftada ayt biter bu arada',
          ),
          const SizedBox(height: 16),
          _buildFeatureRow(
            colorScheme,
            icon: Icons.dark_mode_rounded,
            title: 'Karanlık Tema',
            subtitle: 'i ❤️ material3 design',
          ),
          const SizedBox(height: 16),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildThirdPage(ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            'Hatalar ve Öneriler',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Uygulama tamamen özgür yazılımdır ve AGPL-3.0 lisanslıdır uygulama çizgisi dahilinde katkılara her zaman açıktır.",
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurface.withOpacity(0.65),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Uygulamada hala benim görmediğim hatalar olabilir hataları bildirmek için aşağıdaki hata butonuna basarak veya manuel olarak projenin github sayfasına giderek bildirebilirsiniz. Şimdiden teşekkürler",
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  launchUrl(
                    Uri.parse('https://github.com/navidicted/derspp'),
                    mode: LaunchMode.externalApplication,
                  );
                },
                icon: const Icon(Icons.error_outline),
                label: const Text('Hata Bildir'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () {
                  launchUrl(
                    Uri.parse('https://github.com/navidicted/derspp'),
                    mode: LaunchMode.externalApplication,
                  );
                },
                icon: const Icon(Icons.code_rounded),
                label: const Text('GitHub\'da İncele'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(
    ColorScheme colorScheme, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: colorScheme.onSecondaryContainer),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurface.withOpacity(0.55),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
