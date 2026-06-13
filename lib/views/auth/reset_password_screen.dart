// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import '../../viewmodels/auth_viewmodel.dart';
//
// class ResetPasswordScreen extends StatefulWidget {
//   const ResetPasswordScreen({super.key});
//
//   @override
//   State<ResetPasswordScreen> createState() =>
//       _ResetPasswordScreenState();
// }
//
// class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
//   final _passwordController = TextEditingController();
//   final _confirmController = TextEditingController();
//   bool _obscure1 = true;
//   bool _obscure2 = true;
//
//   @override
//   void dispose() {
//     _passwordController.dispose();
//     _confirmController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _reset() async {
//     final args = ModalRoute.of(context)!.settings.arguments
//     as Map<String, dynamic>;
//     final userId = args['userId'] as String;
//     final otp = args['otp'] as String;
//     final password = _passwordController.text.trim();
//     final confirm = _confirmController.text.trim();
//
//     if (password.isEmpty || confirm.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please fill in all fields')));
//       return;
//     }
//     if (password.length < 6) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text('Password must be at least 6 characters')));
//       return;
//     }
//     if (password != confirm) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Passwords do not match')));
//       return;
//     }
//
//     final authVM = context.read<AuthViewModel>();
//     final success = await authVM.resetPassword(
//       userId: userId,
//       otp: otp,
//       newPassword: password,
//     );
//
//     if (success && mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Password reset successfully! Please login.',
//               style: GoogleFonts.inter(color: Colors.white)),
//           backgroundColor: Colors.green.shade700,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10)),
//         ),
//       );
//       Navigator.pushReplacementNamed(context, '/login');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A0A0A),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios,
//               color: Colors.white, size: 20),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),
//               Text('New Password',
//                   style: GoogleFonts.inter(
//                       fontSize: 26,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white)),
//               const SizedBox(height: 8),
//               Text('Enter your new password below.',
//                   style: GoogleFonts.inter(
//                       fontSize: 14, color: Colors.white54)),
//               const SizedBox(height: 40),
//               _label('New Password'),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: _passwordController,
//                 obscureText: _obscure1,
//                 style: GoogleFonts.inter(color: Colors.white),
//                 decoration: _inputDecoration(
//                     'Min 6 characters', Icons.lock_outline)
//                     .copyWith(
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                         _obscure1
//                             ? Icons.visibility_off
//                             : Icons.visibility,
//                         color: Colors.white38,
//                         size: 20),
//                     onPressed: () =>
//                         setState(() => _obscure1 = !_obscure1),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               _label('Confirm Password'),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: _confirmController,
//                 obscureText: _obscure2,
//                 style: GoogleFonts.inter(color: Colors.white),
//                 decoration:
//                 _inputDecoration('Re-enter password', Icons.lock_outline)
//                     .copyWith(
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                         _obscure2
//                             ? Icons.visibility_off
//                             : Icons.visibility,
//                         color: Colors.white38,
//                         size: 20),
//                     onPressed: () =>
//                         setState(() => _obscure2 = !_obscure2),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 32),
//               Consumer<AuthViewModel>(
//                 builder: (context, authVM, _) {
//                   return SizedBox(
//                     width: double.infinity,
//                     height: 52,
//                     child: ElevatedButton(
//                       onPressed: authVM.isLoading ? null : _reset,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF3B82F6),
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12)),
//                         elevation: 0,
//                       ),
//                       child: authVM.isLoading
//                           ? const SizedBox(
//                           width: 20, height: 20,
//                           child: CircularProgressIndicator(
//                               color: Colors.white, strokeWidth: 2))
//                           : Text('Reset Password',
//                           style: GoogleFonts.inter(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w600)),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _label(String text) => Text(text,
//       style: GoogleFonts.inter(
//           color: Colors.white70,
//           fontSize: 13,
//           fontWeight: FontWeight.w500));
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

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: GoogleFonts.inter(color: Colors.white)),
      backgroundColor: Colors.red.shade700,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  Future<void> _reset() async {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final userId = args['userId'] as String;
    final otp = args['otp'] as String;
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();

    if (password.isEmpty || confirm.isEmpty) { _showError('Please fill in all fields'); return; }
    if (password.length < 6) { _showError('Password must be at least 6 characters'); return; }
    if (password != confirm) { _showError('Passwords do not match'); return; }

    final authVM = context.read<AuthViewModel>();
    final success = await authVM.resetPassword(userId: userId, otp: otp, newPassword: password);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Password reset successfully! Please login.', style: GoogleFonts.inter(color: Colors.white)),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: w * 0.06, vertical: h * 0.01),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: h * 0.02),
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(color: const Color(0xFF3B82F6).withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.lock_outline, color: Color(0xFF3B82F6), size: 28),
            ),
            SizedBox(height: h * 0.02),
            Text('New Password', style: GoogleFonts.inter(fontSize: w * 0.065, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: h * 0.008),
            Text('Enter your new password below.', style: GoogleFonts.inter(fontSize: w * 0.035, color: Colors.white54)),
            SizedBox(height: h * 0.035),
            Text('New Password', style: GoogleFonts.inter(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
            SizedBox(height: h * 0.008),
            TextField(
              controller: _passwordController, obscureText: _obscure1,
              style: GoogleFonts.inter(color: Colors.white),
              decoration: _dec('Min 6 characters', Icons.lock_outline).copyWith(
                suffixIcon: IconButton(icon: Icon(_obscure1 ? Icons.visibility_off : Icons.visibility, color: Colors.white38, size: 20), onPressed: () => setState(() => _obscure1 = !_obscure1)),
              ),
            ),
            SizedBox(height: h * 0.02),
            Text('Confirm Password', style: GoogleFonts.inter(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
            SizedBox(height: h * 0.008),
            TextField(
              controller: _confirmController, obscureText: _obscure2,
              style: GoogleFonts.inter(color: Colors.white),
              decoration: _dec('Re-enter password', Icons.lock_outline).copyWith(
                suffixIcon: IconButton(icon: Icon(_obscure2 ? Icons.visibility_off : Icons.visibility, color: Colors.white38, size: 20), onPressed: () => setState(() => _obscure2 = !_obscure2)),
              ),
            ),
            SizedBox(height: h * 0.03),
            Consumer<AuthViewModel>(builder: (_, authVM, __) => SizedBox(
              width: double.infinity, height: h * 0.065,
              child: ElevatedButton(
                onPressed: authVM.isLoading ? null : _reset,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3B82F6), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                child: authVM.isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text('Reset Password', style: GoogleFonts.inter(fontSize: w * 0.038, fontWeight: FontWeight.w600)),
              ),
            )),
          ]),
        ),
      ),
    );
  }

  InputDecoration _dec(String hint, IconData icon) => InputDecoration(
    hintText: hint, hintStyle: GoogleFonts.inter(color: Colors.white24, fontSize: 14),
    prefixIcon: Icon(icon, color: Colors.white38, size: 20), filled: true, fillColor: const Color(0xFF1A1A1A),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2A2A2A))),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2A2A2A))),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF3B82F6))),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );
}