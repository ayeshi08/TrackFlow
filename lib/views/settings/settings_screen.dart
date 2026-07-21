import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../viewmodels/settings_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    final homeVM = context.watch<HomeViewModel>();
    final settingsVM = context.watch<SettingsViewModel>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = isDark ? const Color(0xFF1A1A1A) : theme.cardColor;
    final borderColor = isDark ? const Color(0xFF2A2A2A) : theme.dividerColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final subColor =
        theme.textTheme.bodyMedium?.color?.withOpacity(0.6) ?? Colors.grey;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Settings',
          style: GoogleFonts.inter(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            children: [
              _sectionHeader('Display', subColor),
              _settingsTile(
                icon: Icons.dark_mode,
                title: 'Dark Mode',
                subtitle: settingsVM.themeMode == ThemeMode.dark
                    ? 'Enabled'
                    : 'Disabled',
                cardColor: cardColor,
                borderColor: borderColor,
                textColor: textColor,
                subColor: subColor,
                trailing: Switch(
                  value: settingsVM.themeMode == ThemeMode.dark,
                  onChanged: (value) => settingsVM.setThemeMode(
                    value ? ThemeMode.dark : ThemeMode.light,
                  ),
                  activeThumbColor: const Color(0xFF3B82F6),
                ),
              ),
              const SizedBox(height: 16),
              _sectionHeader('Preferences', subColor),
              _settingsTile(
                icon: Icons.straighten,
                title: 'Distance Units',
                subtitle: settingsVM.useMiles
                    ? 'Miles (mi)'
                    : 'Kilometers (km)',
                cardColor: cardColor,
                borderColor: borderColor,
                textColor: textColor,
                subColor: subColor,
                trailing: Switch(
                  value: settingsVM.useMiles,
                  onChanged: (v) => settingsVM.setUseMiles(v),
                  activeThumbColor: const Color(0xFF3B82F6),
                ),
              ),
              const SizedBox(height: 16),
              _sectionHeader('Tracking', subColor),
              _settingsTile(
                icon: Icons.battery_alert_outlined,
                title: 'Battery Optimization',
                subtitle:
                    'Disable battery restrictions for reliable GPS tracking',
                cardColor: cardColor,
                borderColor: borderColor,
                textColor: textColor,
                subColor: subColor,
                onTap: () => Geolocator.openAppSettings(),
              ),
              _settingsTile(
                icon: Icons.location_on_outlined,
                title: 'Location Settings',
                subtitle: 'Manage GPS and location permissions',
                cardColor: cardColor,
                borderColor: borderColor,
                textColor: textColor,
                subColor: subColor,
                onTap: () => Geolocator.openLocationSettings(),
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  'TrackFlow v1.0.0',
                  style: GoogleFonts.inter(
                    color: theme.hintColor,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: GoogleFonts.inter(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color cardColor,
    required Color borderColor,
    required Color textColor,
    required Color subColor,
    Widget? trailing,
    VoidCallback? onTap,
    Color? titleColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(icon, color: titleColor ?? const Color(0xFF3B82F6)),
        title: Text(
          title,
          style: GoogleFonts.inter(
            color: titleColor ?? textColor,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(color: subColor, fontSize: 13),
        ),
        trailing:
            trailing ??
            (onTap != null
                ? Icon(Icons.chevron_right, color: subColor.withOpacity(0.5))
                : null),
      ),
    );
  }
}
