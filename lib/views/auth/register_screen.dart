import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) =>
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: GoogleFonts.inter(color: Colors.white)),
      backgroundColor: Colors.red.shade700,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (name.isEmpty || name.length < 2) { _showError('Please enter your full name'); return; }
    if (email.isEmpty) { _showError('Please enter your email address'); return; }
    if (!_isValidEmail(email)) { _showError('Please enter a valid email (e.g. name@gmail.com)'); return; }
    if (password.isEmpty || password.length < 6) { _showError('Password must be at least 6 characters'); return; }
    if (password != confirm) { _showError('Passwords do not match'); return; }

    final authVM = context.read<AuthViewModel>();
    final result = await authVM.register(name: name, email: email, password: password);
    if (!mounted) return;

    if (result['success'] == true) {
      if (result['requiresVerification'] == true) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) => OtpScreen(userId: result['userId'], email: email, isPasswordReset: false),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Account created! Please login.', style: GoogleFonts.inter(color: Colors.white)),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
        if (mounted) Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      _showError(result['message'] ?? 'Registration failed. Please try again.');
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
            Text('Create Account', style: GoogleFonts.inter(fontSize: w * 0.065, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: h * 0.008),
            Text('Start tracking your journeys', style: GoogleFonts.inter(fontSize: w * 0.035, color: Colors.white54)),
            SizedBox(height: h * 0.03),
            Consumer<AuthViewModel>(builder: (_, authVM, __) {
              if (authVM.errorMessage == null) return const SizedBox.shrink();
              return Container(
                width: double.infinity, padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.red.withOpacity(0.3))),
                child: Text(authVM.errorMessage!, style: GoogleFonts.inter(color: Colors.red, fontSize: 13)),
              );
            }),
            _label('Full Name'), SizedBox(height: h * 0.008),
            TextField(controller: _nameController, style: GoogleFonts.inter(color: Colors.white), textCapitalization: TextCapitalization.words, decoration: _dec('Enter your full name', Icons.person_outline)),
            SizedBox(height: h * 0.02),
            _label('Email Address'), SizedBox(height: h * 0.008),
            TextField(controller: _emailController, keyboardType: TextInputType.emailAddress, autocorrect: false, style: GoogleFonts.inter(color: Colors.white), decoration: _dec('name@example.com', Icons.email_outlined)),
            SizedBox(height: h * 0.02),
            _label('Password'), SizedBox(height: h * 0.008),
            TextField(
              controller: _passwordController, obscureText: _obscurePassword, style: GoogleFonts.inter(color: Colors.white),
              decoration: _dec('Min 6 characters', Icons.lock_outline).copyWith(suffixIcon: IconButton(icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.white38, size: 20), onPressed: () => setState(() => _obscurePassword = !_obscurePassword))),
            ),
            SizedBox(height: h * 0.02),
            _label('Confirm Password'), SizedBox(height: h * 0.008),
            TextField(
              controller: _confirmPasswordController, obscureText: _obscureConfirm, style: GoogleFonts.inter(color: Colors.white),
              decoration: _dec('Re-enter password', Icons.lock_outline).copyWith(suffixIcon: IconButton(icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility, color: Colors.white38, size: 20), onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm))),
            ),
            SizedBox(height: h * 0.03),
            Consumer<AuthViewModel>(builder: (_, authVM, __) => SizedBox(
              width: double.infinity, height: h * 0.065,
              child: ElevatedButton(
                onPressed: authVM.isLoading ? null : _register,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3B82F6), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                child: authVM.isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text('Create Account', style: GoogleFonts.inter(fontSize: w * 0.038, fontWeight: FontWeight.w600)),
              ),
            )),
            SizedBox(height: h * 0.025),
            Center(child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: RichText(text: TextSpan(
                text: "Already have an account? ",
                style: GoogleFonts.inter(color: Colors.white54, fontSize: w * 0.035),
                children: [TextSpan(text: 'Sign In', style: GoogleFonts.inter(color: const Color(0xFF3B82F6), fontWeight: FontWeight.w600, fontSize: w * 0.035))],
              )),
            )),
            SizedBox(height: h * 0.02),
          ]),
        ),
      ),
    );
  }

  Widget _label(String t) => Text(t, style: GoogleFonts.inter(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500));

  InputDecoration _dec(String hint, IconData icon) => InputDecoration(
    hintText: hint, hintStyle: GoogleFonts.inter(color: Colors.white24, fontSize: 14),
    prefixIcon: Icon(icon, color: Colors.white38, size: 20), filled: true, fillColor: const Color(0xFF1A1A1A),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2A2A2A))),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2A2A2A))),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF3B82F6))),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );
}