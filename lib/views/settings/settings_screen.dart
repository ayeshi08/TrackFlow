// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../service/settings_service.dart';
// import '../../viewmodels/auth_viewmodel.dart';
// import '../../viewmodels/home_viewmodel.dart';
// import '../../viewmodels/settings_viewmodel.dart';
//
// class SettingsScreen extends StatelessWidget {
//   const SettingsScreen({super.key});
//
//   Future<void> _openUrl(String url) async {
//     final uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final w = MediaQuery.of(context).size.width;
//     final h = MediaQuery.of(context).size.height;
//     final authVM = context.watch<AuthViewModel>();
//     final homeVM = context.watch<HomeViewModel>();
//     final settingsVM = context.watch<SettingsViewModel>();
//
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A0A0A),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0A0A0A),
//         elevation: 0,
//         title: Text(
//           'Settings',
//           style: GoogleFonts.inter(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: ListView(
//         padding: EdgeInsets.all(w * 0.05),
//         children: [
//           ListTile(
//             leading: const Icon(Icons.dark_mode),
//             title: const Text('Dark Mode'),
//             subtitle: Text(
//               settingsVM.themeMode == ThemeMode.dark ? 'Enabled' : 'Disabled',
//             ),
//             trailing: Switch(
//               value: settingsVM.themeMode == ThemeMode.dark,
//               onChanged: (value) {
//                 settingsVM.setThemeMode(
//                   value ? ThemeMode.dark : ThemeMode.light,
//                 );
//               },
//             ),
//           ),
//
//           _sectionHeader('Preferences', w),
//           _settingsTile(
//             icon: Icons.straighten,
//             title: 'Distance Units',
//             subtitle: settingsVM.useMiles ? 'Miles (mi)' : 'Kilometers (km)',
//             trailing: Switch(
//               value: settingsVM.useMiles,
//               onChanged: (v) => settingsVM.setUseMiles(v),
//               activeThumbColor: const Color(0xFF3B82F6),
//             ),
//             w: w,
//           ),
//
//           SizedBox(height: h * 0.02),
//           _sectionHeader('Sync', w),
//           FutureBuilder<int>(
//             future: homeVM.getPendingSyncCount(),
//             builder: (context, snapshot) {
//               final count = snapshot.data ?? 0;
//               return _settingsTile(
//                 icon: Icons.cloud_sync_outlined,
//                 title: 'Pending Trips',
//                 subtitle: count == 0
//                     ? 'All trips synced'
//                     : '$count trip${count == 1 ? '' : 's'} waiting to sync',
//                 trailing: count > 0
//                     ? TextButton(
//                         onPressed: homeVM.isSyncing
//                             ? null
//                             : () async {
//                                 await homeVM.syncPendingTrips();
//                                 if (context.mounted) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: Text(
//                                         'Sync attempted',
//                                         style: GoogleFonts.inter(
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                       backgroundColor: const Color(0xFF3B82F6),
//                                       behavior: SnackBarBehavior.floating,
//                                     ),
//                                   );
//                                 }
//                               },
//                         child: Text(
//                           'Retry',
//                           style: GoogleFonts.inter(
//                             color: const Color(0xFF3B82F6),
//                           ),
//                         ),
//                       )
//                     : const Icon(
//                         Icons.check_circle,
//                         color: Colors.green,
//                         size: 20,
//                       ),
//                 w: w,
//               );
//             },
//           ),
//
//           SizedBox(height: h * 0.02),
//           _sectionHeader('Tracking', w),
//           _settingsTile(
//             icon: Icons.battery_alert_outlined,
//             title: 'Battery Optimization',
//             subtitle: 'Disable battery restrictions for reliable GPS tracking',
//             onTap: () => Geolocator.openAppSettings(),
//             w: w,
//           ),
//           _settingsTile(
//             icon: Icons.location_on_outlined,
//             title: 'Location Settings',
//             subtitle: 'Manage GPS and location permissions',
//             onTap: () => Geolocator.openLocationSettings(),
//             w: w,
//           ),
//
//           SizedBox(height: h * 0.02),
//           _sectionHeader('Legal', w),
//           _settingsTile(
//             icon: Icons.privacy_tip_outlined,
//             title: 'Privacy Policy',
//             subtitle: 'How we handle your data',
//             onTap: () => _openUrl(SettingsService.privacyPolicyUrl),
//             w: w,
//           ),
//           _settingsTile(
//             icon: Icons.description_outlined,
//             title: 'Terms of Service',
//             subtitle: 'App usage terms',
//             onTap: () => _openUrl(SettingsService.termsOfServiceUrl),
//             w: w,
//           ),
//
//           SizedBox(height: h * 0.02),
//           _sectionHeader('Data', w),
//           _settingsTile(
//             icon: Icons.delete_outline,
//             title: 'Delete All Local Trips',
//             subtitle: 'Remove trips stored on this device only',
//             titleColor: Colors.orange,
//             onTap: () => _confirmDeleteLocalTrips(context),
//             w: w,
//           ),
//
//           if (!authVM.isGuest && authVM.currentUser != null) ...[
//             SizedBox(height: h * 0.02),
//             _sectionHeader('Account', w),
//             _settingsTile(
//               icon: Icons.person_off_outlined,
//               title: 'Delete Account',
//               subtitle: 'Permanently delete your account and data',
//               titleColor: Colors.red,
//               onTap: () => _confirmDeleteAccount(context),
//               w: w,
//             ),
//           ],
//
//           SizedBox(height: h * 0.03),
//           Center(
//             child: Text(
//               'TrackFlow v1.0.0',
//               style: GoogleFonts.inter(
//                 color: Colors.white24,
//                 fontSize: w * 0.03,
//               ),
//             ),
//           ),
//           SizedBox(height: h * 0.02),
//         ],
//       ),
//     );
//   }
//
//   Widget _sectionHeader(String title, double w) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Text(
//         title,
//         style: GoogleFonts.inter(
//           color: Colors.white54,
//           fontSize: w * 0.032,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }
//
//   Widget _settingsTile({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required double w,
//     Widget? trailing,
//     VoidCallback? onTap,
//     Color? titleColor,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1A1A1A),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFF2A2A2A)),
//       ),
//       child: ListTile(
//         onTap: onTap,
//         leading: Icon(icon, color: titleColor ?? const Color(0xFF3B82F6)),
//         title: Text(
//           title,
//           style: GoogleFonts.inter(
//             color: titleColor ?? Colors.white,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         subtitle: Text(
//           subtitle,
//           style: GoogleFonts.inter(color: Colors.white54, fontSize: w * 0.03),
//         ),
//         trailing:
//             trailing ??
//             (onTap != null
//                 ? const Icon(Icons.chevron_right, color: Colors.white38)
//                 : null),
//       ),
//     );
//   }
//
//   void _confirmDeleteLocalTrips(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         backgroundColor: const Color(0xFF1A1A1A),
//         title: Text(
//           'Delete Local Trips?',
//           style: GoogleFonts.inter(color: Colors.white),
//         ),
//         content: Text(
//           'This removes all trips stored on this device. Synced trips on the server are not affected.',
//           style: GoogleFonts.inter(color: Colors.white70),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: Text(
//               'Cancel',
//               style: GoogleFonts.inter(color: Colors.white54),
//             ),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(ctx);
//               await context.read<HomeViewModel>().clearAllLocalTrips();
//               if (context.mounted) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text(
//                       'Local trips deleted',
//                       style: GoogleFonts.inter(color: Colors.white),
//                     ),
//                     backgroundColor: Colors.orange.shade800,
//                     behavior: SnackBarBehavior.floating,
//                   ),
//                 );
//               }
//             },
//             child: Text(
//               'Delete',
//               style: GoogleFonts.inter(color: Colors.orange),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _confirmDeleteAccount(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         backgroundColor: const Color(0xFF1A1A1A),
//         title: Text(
//           'Delete Account?',
//           style: GoogleFonts.inter(color: Colors.white),
//         ),
//         content: Text(
//           'This permanently deletes your account. This action cannot be undone.',
//           style: GoogleFonts.inter(color: Colors.white70),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: Text(
//               'Cancel',
//               style: GoogleFonts.inter(color: Colors.white54),
//             ),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(ctx);
//               final authVM = context.read<AuthViewModel>();
//               final homeVM = context.read<HomeViewModel>();
//               final result = await authVM.deleteAccount();
//               await homeVM.clearAllLocalTrips();
//               if (!context.mounted) return;
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(
//                     result['message'] ?? 'Account deleted',
//                     style: GoogleFonts.inter(color: Colors.white),
//                   ),
//                   backgroundColor: result['success'] == true
//                       ? Colors.green.shade700
//                       : Colors.red.shade700,
//                   behavior: SnackBarBehavior.floating,
//                 ),
//               );
//               if (result['success'] == true) {
//                 Navigator.pushReplacementNamed(context, '/login');
//               }
//             },
//             child: Text(
//               'Delete Account',
//               style: GoogleFonts.inter(color: Colors.red),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


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
    final subColor = theme.textTheme.bodyMedium?.color?.withOpacity(0.6) ?? Colors.grey;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Settings',
          style: GoogleFonts.inter(color: textColor, fontWeight: FontWeight.bold),
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
                subtitle: settingsVM.themeMode == ThemeMode.dark ? 'Enabled' : 'Disabled',
                cardColor: cardColor, borderColor: borderColor, textColor: textColor, subColor: subColor,
                trailing: Switch(
                  value: settingsVM.themeMode == ThemeMode.dark,
                  onChanged: (value) => settingsVM.setThemeMode(value ? ThemeMode.dark : ThemeMode.light),
                  activeThumbColor: const Color(0xFF3B82F6),
                ),
              ),
              const SizedBox(height: 16),
              _sectionHeader('Preferences', subColor),
              _settingsTile(
                icon: Icons.straighten,
                title: 'Distance Units',
                subtitle: settingsVM.useMiles ? 'Miles (mi)' : 'Kilometers (km)',
                cardColor: cardColor, borderColor: borderColor, textColor: textColor, subColor: subColor,
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
                subtitle: 'Disable battery restrictions for reliable GPS tracking',
                cardColor: cardColor, borderColor: borderColor, textColor: textColor, subColor: subColor,
                onTap: () => Geolocator.openAppSettings(),
              ),
              _settingsTile(
                icon: Icons.location_on_outlined,
                title: 'Location Settings',
                subtitle: 'Manage GPS and location permissions',
                cardColor: cardColor, borderColor: borderColor, textColor: textColor, subColor: subColor,
                onTap: () => Geolocator.openLocationSettings(),
              ),
              const SizedBox(height: 32),
              Center(
                child: Text('TrackFlow v1.0.0', style: GoogleFonts.inter(color: theme.hintColor, fontSize: 13)),
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
      child: Text(title, style: GoogleFonts.inter(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
    );
  }

  Widget _settingsTile({
    required IconData icon, required String title, required String subtitle,
    required Color cardColor, required Color borderColor, required Color textColor, required Color subColor,
    Widget? trailing, VoidCallback? onTap, Color? titleColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(icon, color: titleColor ?? const Color(0xFF3B82F6)),
        title: Text(title, style: GoogleFonts.inter(color: titleColor ?? textColor, fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: Text(subtitle, style: GoogleFonts.inter(color: subColor, fontSize: 13)),
        trailing: trailing ?? (onTap != null ? Icon(Icons.chevron_right, color: subColor.withOpacity(0.5)) : null),
      ),
    );
  }
}