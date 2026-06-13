// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import '../../viewmodels/profile_viewmodel.dart';
// // import '../../core/theme.dart';
// //
// // class ProfileScreen extends StatelessWidget {
// //   const ProfileScreen({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return ChangeNotifierProvider(
// //       create: (_) => ProfileViewModel(),
// //       child: Consumer<ProfileViewModel>(
// //         builder: (context, vm, _) {
// //           final screenWidth = MediaQuery.of(context).size.width;
// //
// //           return Scaffold(
// //             appBar: AppBar(
// //               title: Text('Profile', style: Theme.of(context).textTheme.bodyLarge),
// //               backgroundColor: AppTheme.primaryColor,
// //             ),
// //             body: Padding(
// //               padding: EdgeInsets.all(screenWidth * 0.05),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   CircleAvatar(
// //                     radius: 50,
// //                     backgroundImage: AssetImage('assets/images/profile.png'),
// //                   ),
// //                   SizedBox(height: 20),
// //                   Text(vm.name,
// //                       style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: screenWidth * 0.08)),
// //                   Text(vm.role, style: Theme.of(context).textTheme.bodyMedium),
// //                   SizedBox(height: 20),
// //                   Text('ID: ${vm.id}', style: Theme.of(context).textTheme.bodyMedium),
// //                   SizedBox(height: 20),
// //                   Divider(),
// //                   SizedBox(height: 20),
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       Text('${vm.trips} Trips', style: Theme.of(context).textTheme.bodyMedium),
// //                       Text('${vm.score} Score', style: Theme.of(context).textTheme.bodyMedium),
// //                       Text('${vm.miles} Miles', style: Theme.of(context).textTheme.bodyMedium),
// //                     ],
// //                   ),
// //                   SizedBox(height: 20),
// //                   ElevatedButton(
// //                     onPressed: () {},
// //                     child: Text('Edit Profile', style: Theme.of(context).textTheme.bodyMedium),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import '../../viewmodels/auth_viewmodel.dart';
// import '../../viewmodels/home_viewmodel.dart';
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   final _nameController = TextEditingController();
//   final _currentPasswordController = TextEditingController();
//   final _newPasswordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   bool _obscureCurrent = true;
//   bool _obscureNew = true;
//   bool _obscureConfirm = true;
//
//   @override
//   void initState() {
//     super.initState();
//     final user = context.read<AuthViewModel>().currentUser;
//     _nameController.text = user?.name ?? '';
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _currentPasswordController.dispose();
//     _newPasswordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _updateName() async {
//     final name = _nameController.text.trim();
//     if (name.isEmpty) return;
//
//     final authVM = context.read<AuthViewModel>();
//     final success = await authVM.updateProfile(name: name);
//
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           success ? 'Name updated successfully' : authVM.errorMessage ?? 'Failed',
//           style: GoogleFonts.inter(color: Colors.white),
//         ),
//         backgroundColor: success ? Colors.green.shade700 : Colors.red.shade700,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );
//   }
//
//   Future<void> _changePassword() async {
//     final current = _currentPasswordController.text.trim();
//     final newPass = _newPasswordController.text.trim();
//     final confirm = _confirmPasswordController.text.trim();
//
//     if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please fill in all fields')));
//       return;
//     }
//     if (newPass.length < 6) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text('New password must be at least 6 characters')));
//       return;
//     }
//     if (newPass != confirm) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Passwords do not match')));
//       return;
//     }
//
//     final authVM = context.read<AuthViewModel>();
//     final success = await authVM.changePassword(
//       currentPassword: current,
//       newPassword: newPass,
//     );
//
//     if (!mounted) return;
//
//     if (success) {
//       _currentPasswordController.clear();
//       _newPasswordController.clear();
//       _confirmPasswordController.clear();
//     }
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           success ? 'Password changed successfully' : authVM.errorMessage ?? 'Failed',
//           style: GoogleFonts.inter(color: Colors.white),
//         ),
//         backgroundColor: success ? Colors.green.shade700 : Colors.red.shade700,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final authVM = context.watch<AuthViewModel>();
//     final user = authVM.currentUser;
//     final homeVM = context.watch<HomeViewModel>();
//
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A0A0A),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0A0A0A),
//         elevation: 0,
//         title: Text('Profile',
//             style: GoogleFonts.inter(
//                 color: Colors.white, fontWeight: FontWeight.bold)),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             // Avatar and name
//             Center(
//               child: Column(
//                 children: [
//                   Container(
//                     width: 80, height: 80,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF3B82F6),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Center(
//                       child: Text(
//                         (user?.name ?? 'G').substring(0, 1).toUpperCase(),
//                         style: GoogleFonts.inter(
//                             color: Colors.white,
//                             fontSize: 32,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Text(user?.name ?? 'Guest',
//                       style: GoogleFonts.inter(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 4),
//                   Text(user?.email ?? user?.phone ?? '',
//                       style: GoogleFonts.inter(
//                           color: Colors.white54, fontSize: 13)),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 24),
//
//             // Stats
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF1A1A1A),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   _statBox('Trips', '${homeVM.weeklyTrips}'),
//                   Container(width: 1, height: 40, color: Colors.white12),
//                   _statBox('Distance', '${homeVM.weeklyDistance.toStringAsFixed(1)} km'),
//                   Container(width: 1, height: 40, color: Colors.white12),
//                   _statBox('CO2 Saved', '${(homeVM.weeklyDistance * 0.12).toStringAsFixed(1)} kg'),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 24),
//
//             // Edit name
//             _sectionTitle('Edit Name'),
//             const SizedBox(height: 12),
//             TextField(
//               controller: _nameController,
//               style: GoogleFonts.inter(color: Colors.white),
//               decoration: _inputDecoration('Full name', Icons.person_outline),
//             ),
//             const SizedBox(height: 12),
//             SizedBox(
//               width: double.infinity,
//               height: 48,
//               child: ElevatedButton(
//                 onPressed: authVM.isLoading ? null : _updateName,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF3B82F6),
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   elevation: 0,
//                 ),
//                 child: authVM.isLoading
//                     ? const SizedBox(
//                     width: 18, height: 18,
//                     child: CircularProgressIndicator(
//                         color: Colors.white, strokeWidth: 2))
//                     : Text('Update Name',
//                     style: GoogleFonts.inter(
//                         fontWeight: FontWeight.w600)),
//               ),
//             ),
//
//             const SizedBox(height: 24),
//
//             // Change password
//             _sectionTitle('Change Password'),
//             const SizedBox(height: 12),
//             TextField(
//               controller: _currentPasswordController,
//               obscureText: _obscureCurrent,
//               style: GoogleFonts.inter(color: Colors.white),
//               decoration:
//               _inputDecoration('Current password', Icons.lock_outline)
//                   .copyWith(
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                       _obscureCurrent
//                           ? Icons.visibility_off
//                           : Icons.visibility,
//                       color: Colors.white38, size: 20),
//                   onPressed: () =>
//                       setState(() => _obscureCurrent = !_obscureCurrent),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: _newPasswordController,
//               obscureText: _obscureNew,
//               style: GoogleFonts.inter(color: Colors.white),
//               decoration:
//               _inputDecoration('New password', Icons.lock_outline)
//                   .copyWith(
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                       _obscureNew
//                           ? Icons.visibility_off
//                           : Icons.visibility,
//                       color: Colors.white38, size: 20),
//                   onPressed: () =>
//                       setState(() => _obscureNew = !_obscureNew),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: _confirmPasswordController,
//               obscureText: _obscureConfirm,
//               style: GoogleFonts.inter(color: Colors.white),
//               decoration:
//               _inputDecoration('Confirm new password', Icons.lock_outline)
//                   .copyWith(
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                       _obscureConfirm
//                           ? Icons.visibility_off
//                           : Icons.visibility,
//                       color: Colors.white38, size: 20),
//                   onPressed: () =>
//                       setState(() => _obscureConfirm = !_obscureConfirm),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//             SizedBox(
//               width: double.infinity,
//               height: 48,
//               child: ElevatedButton(
//                 onPressed: authVM.isLoading ? null : _changePassword,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF1A1A1A),
//                   foregroundColor: Colors.white,
//                   side: const BorderSide(color: Color(0xFF3B82F6)),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   elevation: 0,
//                 ),
//                 child: Text('Change Password',
//                     style: GoogleFonts.inter(
//                         color: const Color(0xFF3B82F6),
//                         fontWeight: FontWeight.w600)),
//               ),
//             ),
//
//             const SizedBox(height: 32),
//
//             // Logout
//             SizedBox(
//               width: double.infinity,
//               height: 48,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   await context.read<AuthViewModel>().logout();
//                   if (context.mounted) {
//                     Navigator.pushReplacementNamed(context, '/login');
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red.shade900.withOpacity(0.3),
//                   foregroundColor: Colors.red,
//                   side: BorderSide(color: Colors.red.shade700),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   elevation: 0,
//                 ),
//                 child: Text('Logout',
//                     style: GoogleFonts.inter(
//                         color: Colors.red,
//                         fontWeight: FontWeight.w600)),
//               ),
//             ),
//
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _statBox(String title, String value) {
//     return Expanded(
//       child: Column(
//         children: [
//           Text(value,
//               style: GoogleFonts.inter(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold)),
//           const SizedBox(height: 4),
//           Text(title,
//               style: GoogleFonts.inter(
//                   color: Colors.white54, fontSize: 11)),
//         ],
//       ),
//     );
//   }
//
//   Widget _sectionTitle(String title) {
//     return Text(title,
//         style: GoogleFonts.inter(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.bold));
//   }
//
//   InputDecoration _inputDecoration(String hint, IconData icon) {
//     return InputDecoration(
//       hintText: hint,
//       hintStyle: GoogleFonts.inter(color: Colors.white24, fontSize: 14),
//       prefixIcon: Icon(icon, color: Colors.white38, size: 20),
//       filled: true,
//       fillColor: const Color(0xFF1A1A1A),
//       border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Color(0xFF2A2A2A))),
//       enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Color(0xFF2A2A2A))),
//       focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Color(0xFF3B82F6))),
//       contentPadding:
//       const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/home_viewmodel.dart';

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
  bool _obscureNew = true;
  bool _obscureConfirm = true;
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: GoogleFonts.inter(color: Colors.white)),
      backgroundColor: success ? Colors.green.shade700 : Colors.red.shade700,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  Future<void> _updateName() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final authVM = context.read<AuthViewModel>();
    final success = await authVM.updateProfile(name: name);
    if (!mounted) return;
    _showSnack(success ? 'Name updated successfully' : authVM.errorMessage ?? 'Failed', success);
  }

  Future<void> _changePassword() async {
    final current = _currentPasswordController.text.trim();
    final newPass = _newPasswordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) { _showSnack('Please fill in all fields', false); return; }
    if (newPass.length < 6) { _showSnack('New password must be at least 6 characters', false); return; }
    if (newPass != confirm) { _showSnack('Passwords do not match', false); return; }

    final authVM = context.read<AuthViewModel>();
    final success = await authVM.changePassword(currentPassword: current, newPassword: newPass);
    if (!mounted) return;

    if (success) {
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      setState(() => _showChangePassword = false);
    }
    _showSnack(success ? 'Password changed successfully' : authVM.errorMessage ?? 'Failed', success);
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    final user = authVM.currentUser;
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A), elevation: 0,
        title: Text('Profile', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(w * 0.05),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // Avatar
          Center(child: Column(children: [
            Container(
              width: w * 0.22, height: w * 0.22,
              decoration: const BoxDecoration(color: Color(0xFF3B82F6), shape: BoxShape.circle),
              child: Center(child: Text(
                (user?.name ?? 'G').substring(0, 1).toUpperCase(),
                style: GoogleFonts.inter(color: Colors.white, fontSize: w * 0.08, fontWeight: FontWeight.bold),
              )),
            ),
            SizedBox(height: h * 0.012),
            Text(user?.name ?? 'Guest', style: GoogleFonts.inter(color: Colors.white, fontSize: w * 0.05, fontWeight: FontWeight.bold)),
            SizedBox(height: h * 0.004),
            Text(user?.email ?? '', style: GoogleFonts.inter(color: Colors.white54, fontSize: w * 0.033)),
          ])),

          SizedBox(height: h * 0.025),

          // Edit Name Section
          _sectionTitle('Edit Name', w),
          SizedBox(height: h * 0.012),
          TextField(
            controller: _nameController,
            style: GoogleFonts.inter(color: Colors.white),
            decoration: _dec('Full name', Icons.person_outline),
          ),
          SizedBox(height: h * 0.012),
          SizedBox(
            width: double.infinity, height: h * 0.06,
            child: ElevatedButton(
              onPressed: authVM.isLoading ? null : _updateName,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3B82F6), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
              child: authVM.isLoading
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text('Update Name', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: w * 0.037)),
            ),
          ),

          SizedBox(height: h * 0.025),

          // Change Password — tap to expand
          GestureDetector(
            onTap: () => setState(() => _showChangePassword = !_showChangePassword),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.018),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _showChangePassword ? const Color(0xFF3B82F6) : const Color(0xFF2A2A2A)),
              ),
              child: Row(children: [
                const Icon(Icons.lock_outline, color: Color(0xFF3B82F6), size: 20),
                SizedBox(width: w * 0.03),
                Expanded(child: Text('Change Password', style: GoogleFonts.inter(color: Colors.white, fontSize: w * 0.038, fontWeight: FontWeight.w600))),
                Icon(_showChangePassword ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.white38),
              ]),
            ),
          ),

          // Expandable password fields
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              margin: EdgeInsets.only(top: h * 0.015),
              padding: EdgeInsets.all(w * 0.04),
              decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(12)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Current Password', style: GoogleFonts.inter(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                SizedBox(height: h * 0.008),
                TextField(
                  controller: _currentPasswordController, obscureText: _obscureCurrent,
                  style: GoogleFonts.inter(color: Colors.white),
                  decoration: _dec('Current password', Icons.lock_outline).copyWith(
                    suffixIcon: IconButton(icon: Icon(_obscureCurrent ? Icons.visibility_off : Icons.visibility, color: Colors.white38, size: 20), onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent)),
                  ),
                ),
                SizedBox(height: h * 0.015),
                Text('New Password', style: GoogleFonts.inter(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                SizedBox(height: h * 0.008),
                TextField(
                  controller: _newPasswordController, obscureText: _obscureNew,
                  style: GoogleFonts.inter(color: Colors.white),
                  decoration: _dec('New password', Icons.lock_outline).copyWith(
                    suffixIcon: IconButton(icon: Icon(_obscureNew ? Icons.visibility_off : Icons.visibility, color: Colors.white38, size: 20), onPressed: () => setState(() => _obscureNew = !_obscureNew)),
                  ),
                ),
                SizedBox(height: h * 0.015),
                Text('Confirm New Password', style: GoogleFonts.inter(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                SizedBox(height: h * 0.008),
                TextField(
                  controller: _confirmPasswordController, obscureText: _obscureConfirm,
                  style: GoogleFonts.inter(color: Colors.white),
                  decoration: _dec('Re-enter new password', Icons.lock_outline).copyWith(
                    suffixIcon: IconButton(icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility, color: Colors.white38, size: 20), onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm)),
                  ),
                ),
                SizedBox(height: h * 0.015),
                SizedBox(
                  width: double.infinity, height: h * 0.06,
                  child: ElevatedButton(
                    onPressed: authVM.isLoading ? null : _changePassword,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3B82F6), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                    child: authVM.isLoading
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text('Update Password', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  ),
                ),
              ]),
            ),
            crossFadeState: _showChangePassword ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),

          SizedBox(height: h * 0.03),

          // Logout
          SizedBox(
            width: double.infinity, height: h * 0.06,
            child: ElevatedButton(
              onPressed: () async {
                await context.read<AuthViewModel>().logout();
                if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade900.withOpacity(0.3), foregroundColor: Colors.red,
                side: BorderSide(color: Colors.red.shade700),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0,
              ),
              child: Text('Logout', style: GoogleFonts.inter(color: Colors.red, fontWeight: FontWeight.w600)),
            ),
          ),
          SizedBox(height: h * 0.02),
        ]),
      ),
    );
  }

  Widget _sectionTitle(String t, double w) => Text(t, style: GoogleFonts.inter(color: Colors.white, fontSize: w * 0.042, fontWeight: FontWeight.bold));

  InputDecoration _dec(String hint, IconData icon) => InputDecoration(
    hintText: hint, hintStyle: GoogleFonts.inter(color: Colors.white24, fontSize: 14),
    prefixIcon: Icon(icon, color: Colors.white38, size: 20), filled: true, fillColor: const Color(0xFF0A0A0A),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2A2A2A))),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2A2A2A))),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF3B82F6))),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );
}