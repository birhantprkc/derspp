import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../providers/theme_provider.dart';

class ThemeSettingsWidget extends StatelessWidget {
  const ThemeSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
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
              color: theme.colorScheme.onSurface.withOpacity(0.5),
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
        const SizedBox(height: 16),
        Text(
          'Vurgu Rengi',
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 16),
        _buildColorPicker(context, themeProvider),
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
          _buildCustomColorButton(context, themeProvider),
        ],
      ),
    );
  }

  Widget _buildCustomColorButton(
    BuildContext context,
    ThemeProvider themeProvider,
  ) {
    final isCustomSelected =
        !themeProvider.useDynamicColor &&
        ![
          Colors.blue.value,
          Colors.purple.value,
          Colors.deepPurple.value,
          Colors.indigo.value,
          Colors.pink.value,
          Colors.red.value,
          Colors.orange.value,
          Colors.amber.value,
          Colors.green.value,
          Colors.teal.value,
          Colors.cyan.value,
        ].contains(themeProvider.customSeedColor.value);

    return GestureDetector(
      onTap: () => _showColorPickerDialog(context, themeProvider),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isCustomSelected
              ? themeProvider.customSeedColor
              : Theme.of(context).colorScheme.surfaceVariant,
          shape: BoxShape.circle,
          border: Border.all(
            color: isCustomSelected
                ? Theme.of(context).colorScheme.onSurface
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Icon(
          Icons.edit_rounded,
          size: 18,
          color: isCustomSelected
              ? (themeProvider.customSeedColor.computeLuminance() > 0.5
                    ? Colors.black
                    : Colors.white)
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  void _showColorPickerDialog(
    BuildContext context,
    ThemeProvider themeProvider,
  ) {
    Color pickerColor = themeProvider.customSeedColor;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Özel Renk Seç'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: (color) => pickerColor = color,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () {
              themeProvider.setSeedColor(pickerColor);
              Navigator.pop(context);
            },
            child: const Text('Seç'),
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
}
