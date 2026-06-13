import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';

class OtpScreen extends StatefulWidget {
  final String userId;
  final String email;
  final bool isPasswordReset;

  const OtpScreen({
    super.key,
    required this.userId,
    required this.email,
    this.isPasswordReset = false,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
  List.generate(6, (_) => FocusNode());

  int _resendSeconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    // Auto focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  void _startResendTimer() {
    _resendSeconds = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_resendSeconds == 0) {
        t.cancel();
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    _timer?.cancel();
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();

  Future<void> _verify() async {
    if (_otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter all 6 digits',
              style: GoogleFonts.inter(color: Colors.white)),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    final authVM = context.read<AuthViewModel>();

    if (widget.isPasswordReset) {
      Navigator.pushReplacementNamed(
        context,
        '/reset-password',
        arguments: {'userId': widget.userId, 'otp': _otp},
      );
      return;
    }

    final success = await authVM.verifyOtp(
      userId: widget.userId,
      otp: _otp,
    );

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _resend() async {
    // Clear all fields
    for (final c in _controllers) c.clear();
    _focusNodes[0].requestFocus();

    final authVM = context.read<AuthViewModel>();
    await authVM.resendOtp(userId: widget.userId);
    _startResendTimer();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'New code sent to ${widget.email}',
            style: GoogleFonts.inter(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF3B82F6),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // Use resizeToAvoidBottomInset to handle keyboard overflow
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.mark_email_read_outlined,
                    color: Color(0xFF3B82F6), size: 28),
              ),

              const SizedBox(height: 20),

              Text(
                widget.isPasswordReset
                    ? 'Reset Password'
                    : 'Verify Your Email',
                style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),

              const SizedBox(height: 8),

              Text(
                'We sent a 6-digit code to',
                style: GoogleFonts.inter(
                    fontSize: 14, color: Colors.white54),
              ),
              Text(
                widget.email.isNotEmpty
                    ? widget.email
                    : 'your email',
                style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              Text(
                'Check your spam folder if you don\'t see it.',
                style: GoogleFonts.inter(
                    fontSize: 12, color: Colors.white38),
              ),

              const SizedBox(height: 32),

              // OTP boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) {
                  return SizedBox(
                    width: (MediaQuery.of(context).size.width - 64) / 6 - 4,
                    height: 56,
                    child: TextField(
                      controller: _controllers[i],
                      focusNode: _focusNodes[i],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: const Color(0xFF1A1A1A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xFF2A2A2A)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xFF2A2A2A)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xFF3B82F6), width: 2),
                        ),
                      ),
                      onChanged: (val) {
                        if (val.isNotEmpty && i < 5) {
                          _focusNodes[i + 1].requestFocus();
                        }
                        if (val.isEmpty && i > 0) {
                          _focusNodes[i - 1].requestFocus();
                        }
                        // Auto verify when last digit entered
                        if (i == 5 && val.isNotEmpty) {
                          _verify();
                        }
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 16),

              // Error message
              Consumer<AuthViewModel>(
                builder: (context, authVM, _) {
                  if (authVM.errorMessage == null) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Text(
                      authVM.errorMessage!,
                      style: GoogleFonts.inter(
                          color: Colors.red, fontSize: 13),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Verify button
              Consumer<AuthViewModel>(
                builder: (context, authVM, _) {
                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: authVM.isLoading ? null : _verify,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: authVM.isLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2),
                      )
                          : Text(
                        widget.isPasswordReset
                            ? 'Continue'
                            : 'Verify Email',
                        style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Resend
              Center(
                child: _resendSeconds > 0
                    ? RichText(
                  text: TextSpan(
                    text: 'Resend code in ',
                    style: GoogleFonts.inter(
                        color: Colors.white38, fontSize: 14),
                    children: [
                      TextSpan(
                        text: '${_resendSeconds}s',
                        style: GoogleFonts.inter(
                            color: Colors.white54,
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                      ),
                    ],
                  ),
                )
                    : GestureDetector(
                  onTap: _resend,
                  child: Text(
                    'Resend Code',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF3B82F6),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}