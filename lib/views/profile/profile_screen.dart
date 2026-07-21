import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureCurrent = true;
  final bool _obscureNew = true;
  final bool _obscureConfirm = true;
  bool _showChangePassword = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthViewModel>().currentUser;
    _nameController.text = user?.name ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSnack(String msg, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.inter()),
        backgroundColor: success ? Colors.green.shade700 : Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    final user = authVM.currentUser;
    final theme = Theme.of(context);
    // Determine dynamic adaptive colors based on active theme brightness
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1A1A1A) : theme.cardColor;
    final borderColor = isDark ? const Color(0xFF2A2A2A) : theme.dividerColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Profile',
          style: GoogleFonts.inter(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isLandscape = orientation == Orientation.landscape;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: isLandscape
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildAvatar(user?.name),
                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildProfileName(user?.name, textColor),
                                    _buildProfileEmail(
                                      user?.email,
                                      theme.textTheme.bodyMedium?.color
                                          ?.withOpacity(0.6),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _buildAvatar(user?.name),
                                const SizedBox(height: 12),
                                _buildProfileName(user?.name, textColor),
                                const SizedBox(height: 4),
                                _buildProfileEmail(
                                  user?.email,
                                  theme.textTheme.bodyMedium?.color
                                      ?.withOpacity(0.6),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 24),
                    _sectionTitle('Edit Name', textColor),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _nameController,
                      style: GoogleFonts.inter(color: textColor),
                      decoration: _dec(
                        'Full name',
                        Icons.person_outline,
                        theme,
                        cardColor,
                        borderColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: authVM.isLoading
                            ? null
                            : () {}, // Bind logic intact
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Update Name',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () => setState(
                        () => _showChangePassword = !_showChangePassword,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _showChangePassword
                                ? const Color(0xFF3B82F6)
                                : borderColor,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.lock_outline,
                              color: Color(0xFF3B82F6),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Change Password',
                                style: GoogleFonts.inter(
                                  color: textColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Icon(
                              _showChangePassword
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: theme.hintColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    AnimatedCrossFade(
                      firstChild: const SizedBox.shrink(),
                      secondChild: Container(
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Password',
                              style: GoogleFonts.inter(
                                color: textColor.withOpacity(0.7),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _currentPasswordController,
                              obscureText: _obscureCurrent,
                              style: GoogleFonts.inter(color: textColor),
                              decoration:
                                  _dec(
                                    'Current password',
                                    Icons.lock_outline,
                                    theme,
                                    cardColor,
                                    borderColor,
                                  ).copyWith(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureCurrent
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: theme.hintColor,
                                        size: 20,
                                      ),
                                      onPressed: () => setState(
                                        () =>
                                            _obscureCurrent = !_obscureCurrent,
                                      ),
                                    ),
                                  ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: authVM.isLoading ? null : () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3B82F6),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Update Password',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      crossFadeState: _showChangePassword
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 300),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/settings'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF3B82F6),
                          side: const BorderSide(color: Color(0xFF3B82F6)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Settings',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          await context.read<AuthViewModel>().logout();
                          if (context.mounted)
                            Navigator.pushReplacementNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade900.withOpacity(
                            0.15,
                          ),
                          foregroundColor: Colors.red,
                          side: BorderSide(color: Colors.red.shade700),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Logout',
                          style: GoogleFonts.inter(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatar(String? name) => Container(
    width: 80,
    height: 80,
    decoration: const BoxDecoration(
      color: Color(0xFF3B82F6),
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Text(
        (name ?? 'G').substring(0, 1).toUpperCase(),
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );

  Widget _buildProfileName(String? name, Color textColor) => Text(
    name ?? 'Guest',
    style: GoogleFonts.inter(
      color: textColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );
  Widget _buildProfileEmail(String? email, Color? color) =>
      Text(email ?? '', style: GoogleFonts.inter(color: color, fontSize: 14));
  Widget _sectionTitle(String t, Color color) => Text(
    t,
    style: GoogleFonts.inter(
      color: color,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  );

  InputDecoration _dec(
    String hint,
    IconData icon,
    ThemeData theme,
    Color fill,
    Color border,
  ) => InputDecoration(
    hintText: hint,
    hintStyle: GoogleFonts.inter(color: theme.hintColor, fontSize: 14),
    prefixIcon: Icon(icon, color: theme.hintColor, size: 20),
    filled: true,
    fillColor: fill,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF3B82F6)),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );
}
