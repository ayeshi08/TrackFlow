// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import '../../viewmodels/auth_viewmodel.dart';
// import 'otp_screen.dart';
//
// class ForgotPasswordScreen extends StatefulWidget {
//   const ForgotPasswordScreen({super.key});
//
//   @override
//   State<ForgotPasswordScreen> createState() =>
//       _ForgotPasswordScreenState();
// }
//
// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//   final _controller = TextEditingController();
//   bool _usePhone = false;
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   Future<void> _submit() async {
//     final value = _controller.text.trim();
//     if (value.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             _usePhone
//                 ? 'Please enter your phone number'
//                 : 'Please enter your email',
//             style: GoogleFonts.inter(color: Colors.white),
//           ),
//           backgroundColor: Colors.red.shade700,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10)),
//         ),
//       );
//       return;
//     }
//
//     final authVM = context.read<AuthViewModel>();
//     final result = await authVM.forgotPassword(
//       emailOrPhone: value,
//       usePhone: _usePhone,
//     );
//
//     if (!mounted) return;
//
//     if (result['success'] == true && result['userId'] != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => OtpScreen(
//             userId: result['userId'],
//             email: value,
//             isPasswordReset: true,
//           ),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             result['message'] ?? 'Something went wrong',
//             style: GoogleFonts.inter(color: Colors.white),
//           ),
//           backgroundColor: Colors.red.shade700,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10)),
//         ),
//       );
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
//               Text('Forgot Password',
//                   style: GoogleFonts.inter(
//                       fontSize: 26,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white)),
//               const SizedBox(height: 8),
//               Text(
//                 'Enter your registered email or phone and we\'ll send you a reset code.',
//                 style: GoogleFonts.inter(
//                     fontSize: 14, color: Colors.white54),
//               ),
//
//               const SizedBox(height: 32),
//
//               // Email / Phone toggle
//               Row(
//                 children: [
//                   _toggleButton('Email', !_usePhone, () {
//                     setState(() {
//                       _usePhone = false;
//                       _controller.clear();
//                     });
//                   }),
//                   const SizedBox(width: 12),
//                   _toggleButton('Phone', _usePhone, () {
//                     setState(() {
//                       _usePhone = true;
//                       _controller.clear();
//                     });
//                   }),
//                 ],
//               ),
//
//               const SizedBox(height: 16),
//
//               Text(
//                 _usePhone ? 'Phone Number' : 'Email Address',
//                 style: GoogleFonts.inter(
//                     color: Colors.white70,
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: _controller,
//                 keyboardType: _usePhone
//                     ? TextInputType.phone
//                     : TextInputType.emailAddress,
//                 style: GoogleFonts.inter(color: Colors.white),
//                 autocorrect: false,
//                 inputFormatters: _usePhone
//                     ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))]
//                     : [],
//                 decoration: InputDecoration(
//                   hintText: _usePhone
//                       ? '+92xxxxxxxxxx'
//                       : 'name@example.com',
//                   hintStyle: GoogleFonts.inter(
//                       color: Colors.white24, fontSize: 14),
//                   prefixIcon: Icon(
//                     _usePhone
//                         ? Icons.phone_outlined
//                         : Icons.email_outlined,
//                     color: Colors.white38,
//                     size: 20,
//                   ),
//                   filled: true,
//                   fillColor: const Color(0xFF1A1A1A),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide:
//                       const BorderSide(color: Color(0xFF2A2A2A))),
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide:
//                       const BorderSide(color: Color(0xFF2A2A2A))),
//                   focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide:
//                       const BorderSide(color: Color(0xFF3B82F6))),
//                   contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16, vertical: 14),
//                 ),
//               ),
//
//               const SizedBox(height: 32),
//
//               Consumer<AuthViewModel>(
//                 builder: (context, authVM, _) {
//                   return SizedBox(
//                     width: double.infinity,
//                     height: 52,
//                     child: ElevatedButton(
//                       onPressed: authVM.isLoading ? null : _submit,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF3B82F6),
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12)),
//                         elevation: 0,
//                       ),
//                       child: authVM.isLoading
//                           ? const SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(
//                             color: Colors.white, strokeWidth: 2),
//                       )
//                           : Text('Send Reset Code',
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
//   Widget _toggleButton(String label, bool isActive, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding:
//         const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         decoration: BoxDecoration(
//           color: isActive
//               ? const Color(0xFF3B82F6)
//               : const Color(0xFF1A1A1A),
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: isActive
//                 ? const Color(0xFF3B82F6)
//                 : const Color(0xFF2A2A2A),
//           ),
//         ),
//         child: Text(label,
//             style: GoogleFonts.inter(
//                 color: isActive ? Colors.white : Colors.white54,
//                 fontSize: 13,
//                 fontWeight: FontWeight.w600)),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() { _emailController.dispose(); super.dispose(); }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter your email', style: GoogleFonts.inter(color: Colors.white)),
        backgroundColor: Colors.red.shade700, behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      )); return;
    }

    final authVM = context.read<AuthViewModel>();
    final result = await authVM.forgotPassword(emailOrPhone: email, usePhone: false);
    if (!mounted) return;

    if (result['success'] == true && result['userId'] != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => OtpScreen(userId: result['userId'], email: email, isPasswordReset: true)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result['message'] ?? 'Something went wrong', style: GoogleFonts.inter(color: Colors.white)),
        backgroundColor: Colors.red.shade700, behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20), onPressed: () => Navigator.pop(context))),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: w * 0.06, vertical: h * 0.01),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: h * 0.02),
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(color: const Color(0xFF3B82F6).withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.lock_reset, color: Color(0xFF3B82F6), size: 28),
            ),
            SizedBox(height: h * 0.02),
            Text('Forgot Password', style: GoogleFonts.inter(fontSize: w * 0.065, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: h * 0.008),
            Text('Enter your registered email and we\'ll send you a reset code.', style: GoogleFonts.inter(fontSize: w * 0.035, color: Colors.white54)),
            SizedBox(height: h * 0.035),
            Text('Email Address', style: GoogleFonts.inter(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
            SizedBox(height: h * 0.008),
            TextField(
              controller: _emailController, keyboardType: TextInputType.emailAddress, autocorrect: false,
              style: GoogleFonts.inter(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'name@example.com', hintStyle: GoogleFonts.inter(color: Colors.white24, fontSize: 14),
                prefixIcon: const Icon(Icons.email_outlined, color: Colors.white38, size: 20), filled: true, fillColor: const Color(0xFF1A1A1A),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2A2A2A))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2A2A2A))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF3B82F6))),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            SizedBox(height: h * 0.03),
            Consumer<AuthViewModel>(builder: (_, authVM, __) => SizedBox(
              width: double.infinity, height: h * 0.065,
              child: ElevatedButton(
                onPressed: authVM.isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3B82F6), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                child: authVM.isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text('Send Reset Code', style: GoogleFonts.inter(fontSize: w * 0.038, fontWeight: FontWeight.w600)),
              ),
            )),
          ]),
        ),
      ),
    );
  }
}