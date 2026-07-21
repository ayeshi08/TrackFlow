// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import '../../viewmodels/auth_viewmodel.dart';
// import 'register_screen.dart';
// import 'forgot_password_screen.dart';
// import 'otp_screen.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _obscurePassword = true;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<AuthViewModel>().clearError();
//     });
//   }
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   void _showError(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(msg, style: GoogleFonts.inter(color: Colors.white)),
//         backgroundColor: Colors.red.shade700,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );
//   }
//
//   Future<void> _login() async {
//     final email = _emailController.text.trim();
//     final password = _passwordController.text.trim();
//     if (email.isEmpty || password.isEmpty) {
//       _showError('Please fill in all fields');
//       return;
//     }
//
//     final authVM = context.read<AuthViewModel>();
//     final result = await authVM.login(emailOrPhone: email, password: password);
//     if (!mounted) return;
//
//     if (result['success'] == true) {
//       Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
//     } else if (result['requiresVerification'] == true) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => OtpScreen(userId: result['userId'], email: email),
//         ),
//       );
//     }
//   }
//
//   Future<void> _continueAsGuest() async {
//     await context.read<AuthViewModel>().loginAsGuest();
//     if (mounted) Navigator.pushReplacementNamed(context, '/home');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final w = MediaQuery.of(context).size.width;
//     final h = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A0A0A),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(
//             horizontal: w * 0.06,
//             vertical: h * 0.02,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: h * 0.04),
//               Center(
//                 child: Column(
//                   children: [
//                     Container(
//                       width: w * 0.16,
//                       height: w * 0.16,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF3B82F6),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Icon(
//                         Icons.route,
//                         color: Colors.white,
//                         size: w * 0.08,
//                       ),
//                     ),
//                     SizedBox(height: h * 0.015),
//                     Text(
//                       'TrackFlow',
//                       style: GoogleFonts.inter(
//                         fontSize: w * 0.07,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(height: h * 0.006),
//                     Text(
//                       'Sign in to continue',
//                       style: GoogleFonts.inter(
//                         fontSize: w * 0.037,
//                         color: Colors.white54,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: h * 0.04),
//               Consumer<AuthViewModel>(
//                 builder: (_, authVM, __) {
//                   if (authVM.errorMessage == null)
//                     return const SizedBox.shrink();
//                   return Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(12),
//                     margin: const EdgeInsets.only(bottom: 16),
//                     decoration: BoxDecoration(
//                       color: Colors.red.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(color: Colors.red.withOpacity(0.3)),
//                     ),
//                     child: Text(
//                       authVM.errorMessage!,
//                       style: GoogleFonts.inter(color: Colors.red, fontSize: 13),
//                     ),
//                   );
//                 },
//               ),
//               Text(
//                 'Email Address',
//                 style: GoogleFonts.inter(
//                   color: Colors.white70,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               SizedBox(height: h * 0.008),
//               TextField(
//                 controller: _emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 autocorrect: false,
//                 style: GoogleFonts.inter(color: Colors.white),
//                 decoration: _dec('name@example.com', Icons.email_outlined),
//               ),
//               SizedBox(height: h * 0.02),
//               Text(
//                 'Password',
//                 style: GoogleFonts.inter(
//                   color: Colors.white70,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               SizedBox(height: h * 0.008),
//               TextField(
//                 controller: _passwordController,
//                 obscureText: _obscurePassword,
//                 style: GoogleFonts.inter(color: Colors.white),
//                 decoration: _dec('Enter your password', Icons.lock_outline)
//                     .copyWith(
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _obscurePassword
//                               ? Icons.visibility_off
//                               : Icons.visibility,
//                           color: Colors.white38,
//                           size: 20,
//                         ),
//                         onPressed: () => setState(
//                           () => _obscurePassword = !_obscurePassword,
//                         ),
//                       ),
//                     ),
//               ),
//               SizedBox(height: h * 0.01),
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: GestureDetector(
//                   onTap: () {
//                     context.read<AuthViewModel>().clearError();
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const ForgotPasswordScreen(),
//                       ),
//                     );
//                   },
//                   child: Text(
//                     'Forgot Password?',
//                     style: GoogleFonts.inter(
//                       color: const Color(0xFF3B82F6),
//                       fontSize: 13,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: h * 0.025),
//               Consumer<AuthViewModel>(
//                 builder: (_, authVM, __) => SizedBox(
//                   width: double.infinity,
//                   height: h * 0.065,
//                   child: ElevatedButton(
//                     onPressed: authVM.isLoading ? null : _login,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF3B82F6),
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       elevation: 0,
//                     ),
//                     child: authVM.isLoading
//                         ? const SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 2,
//                             ),
//                           )
//                         : Text(
//                             'Sign In',
//                             style: GoogleFonts.inter(
//                               fontSize: w * 0.038,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: h * 0.015),
//               Row(
//                 children: [
//                   const Expanded(child: Divider(color: Colors.white12)),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: Text(
//                       'or',
//                       style: GoogleFonts.inter(
//                         color: Colors.white38,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ),
//                   const Expanded(child: Divider(color: Colors.white12)),
//                 ],
//               ),
//               SizedBox(height: h * 0.015),
//               SizedBox(
//                 width: double.infinity,
//                 height: h * 0.065,
//                 child: OutlinedButton(
//                   onPressed: _continueAsGuest,
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: Colors.white,
//                     side: const BorderSide(color: Color(0xFF2A2A2A)),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(
//                         Icons.person_outline,
//                         color: Colors.white54,
//                         size: 20,
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         'Continue as Guest',
//                         style: GoogleFonts.inter(
//                           color: Colors.white54,
//                           fontSize: w * 0.037,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: h * 0.025),
//               Center(
//                 child: GestureDetector(
//                   onTap: () {
//                     context.read<AuthViewModel>().clearError();
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => const RegisterScreen()),
//                     );
//                   },
//                   child: RichText(
//                     text: TextSpan(
//                       text: "Don't have an account? ",
//                       style: GoogleFonts.inter(
//                         color: Colors.white54,
//                         fontSize: w * 0.035,
//                       ),
//                       children: [
//                         TextSpan(
//                           text: 'Sign Up',
//                           style: GoogleFonts.inter(
//                             color: const Color(0xFF3B82F6),
//                             fontWeight: FontWeight.w600,
//                             fontSize: w * 0.035,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: h * 0.02),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   InputDecoration _dec(String hint, IconData icon) => InputDecoration(
//     hintText: hint,
//     hintStyle: GoogleFonts.inter(color: Colors.white24, fontSize: 14),
//     prefixIcon: Icon(icon, color: Colors.white38, size: 20),
//     filled: true,
//     fillColor: const Color(0xFF1A1A1A),
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
//     ),
//     enabledBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: const BorderSide(color: Color(0xFF3B82F6)),
//     ),
//     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//   );
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthViewModel>().clearError();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.inter(color: Colors.white)),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      _showError('Please fill in all fields');
      return;
    }

    final authVM = context.read<AuthViewModel>();
    final result = await authVM.login(emailOrPhone: email, password: password);
    if (!mounted) return;

    if (result['success'] == true) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else if (result['requiresVerification'] == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              OtpScreen(userId: result['userId'] as String, email: email),
        ),
      );
    }
  }

  Future<void> _continueAsGuest() async {
    await context.read<AuthViewModel>().loginAsGuest();
    if (mounted) Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: OrientationBuilder(
              builder: (context, orientation) {
                final isLandscape = orientation == Orientation.landscape;

                if (isLandscape) {
                  return Row(
                    children: [
                      // Left branding block
                      Expanded(
                        flex: 5,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  Icons.route,
                                  color: theme.colorScheme.onPrimary,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'TrackFlow',
                                style: GoogleFonts.inter(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Sign in to continue',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Right form entries inputs layout
                      Expanded(
                        flex: 6,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          child: _buildFormContent(theme),
                        ),
                      ),
                    ],
                  );
                }

                // Default standard view column
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.route,
                                color: theme.colorScheme.onPrimary,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'TrackFlow',
                              style: GoogleFonts.inter(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Sign in to continue',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildFormContent(theme),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Uses structured semantic elements inside a persistent tree container object
  Widget _buildFormContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Consumer<AuthViewModel>(
          builder: (_, authVM, __) {
            if (authVM.errorMessage == null) return const SizedBox.shrink();
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Text(
                authVM.errorMessage!,
                style: GoogleFonts.inter(color: Colors.red, fontSize: 13),
              ),
            );
          },
        ),
        Text(
          'Email Address',
          style: GoogleFonts.inter(
            color: theme.colorScheme.onSurface.withOpacity(0.8),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          key: const ValueKey('login_email_field'),
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          style: GoogleFonts.inter(color: theme.colorScheme.onSurface),
          decoration: _dec('name@example.com', Icons.email_outlined, theme),
        ),
        const SizedBox(height: 16),
        Text(
          'Password',
          style: GoogleFonts.inter(
            color: theme.colorScheme.onSurface.withOpacity(0.8),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          key: const ValueKey('login_password_field'),
          controller: _passwordController,
          obscureText: _obscurePassword,
          style: GoogleFonts.inter(color: theme.colorScheme.onSurface),
          decoration: _dec('Enter your password', Icons.lock_outline, theme)
              .copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              context.read<AuthViewModel>().clearError();
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const ForgotPasswordScreen(),
                ),
              );
            },
            child: Text(
              'Forgot Password?',
              style: GoogleFonts.inter(
                color: theme.colorScheme.primary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Consumer<AuthViewModel>(
          builder: (_, authVM, __) => SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: authVM.isLoading ? null : _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: authVM.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Sign In',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Divider(
                color: theme.colorScheme.onSurface.withOpacity(0.12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'or',
                style: GoogleFonts.inter(
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: theme.colorScheme.onSurface.withOpacity(0.12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: _continueAsGuest,
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.onSurface,
              side: BorderSide(
                color: theme.colorScheme.onSurface.withOpacity(0.15),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_outline,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Continue as Guest',
                  style: GoogleFonts.inter(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: GestureDetector(
            onTap: () {
              context.read<AuthViewModel>().clearError();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegisterScreen()),
              );
            },
            child: RichText(
              text: TextSpan(
                text: "Don't have an account? ",
                style: GoogleFonts.inter(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: 'Sign Up',
                    style: GoogleFonts.inter(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _dec(String hint, IconData icon, ThemeData theme) =>
      InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          color: theme.colorScheme.onSurface.withOpacity(0.3),
          fontSize: 14,
        ),
        prefixIcon: Icon(
          icon,
          color: theme.colorScheme.onSurface.withOpacity(0.4),
          size: 20,
        ),
        filled: true,
        fillColor: theme.cardTheme.color ?? theme.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.onSurface.withOpacity(0.1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.onSurface.withOpacity(0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.primary),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      );
}
