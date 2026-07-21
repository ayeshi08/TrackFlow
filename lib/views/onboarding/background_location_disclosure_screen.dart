import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BackgroundLocationDisclosureScreen extends StatelessWidget {
  const BackgroundLocationDisclosureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.06,
            vertical: h * 0.03,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: h * 0.04),
              Container(
                width: w * 0.18,
                height: w * 0.18,
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.my_location,
                  color: const Color(0xFF3B82F6),
                  size: w * 0.09,
                ),
              ),
              SizedBox(height: h * 0.03),
              Text(
                'Background Location',
                style: GoogleFonts.inter(
                  fontSize: w * 0.065,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: h * 0.015),
              Text(
                'TrackFlow records your trip continuously — even when '
                'your screen is off or you switch to another app.',
                style: GoogleFonts.inter(
                  fontSize: w * 0.038,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              SizedBox(height: h * 0.03),
              _buildPoint(
                w,
                Icons.check_circle_outline,
                'Accurate distance and route, no matter what you\'re doing on your phone',
              ),
              SizedBox(height: h * 0.018),
              _buildPoint(
                w,
                Icons.check_circle_outline,
                'Your location is only recorded during an active trip',
              ),
              SizedBox(height: h * 0.018),
              _buildPoint(
                w,
                Icons.check_circle_outline,
                'You can stop tracking anytime from the app',
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.all(w * 0.04),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2A2A2A)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.white38,
                      size: w * 0.05,
                    ),
                    SizedBox(width: w * 0.03),
                    Expanded(
                      child: Text(
                        'On the next screen, please choose "Allow all the time" '
                        'for the most accurate tracking.',
                        style: GoogleFonts.inter(
                          fontSize: w * 0.032,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: h * 0.025),
              SizedBox(
                width: double.infinity,
                height: h * 0.065,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Continue',
                    style: GoogleFonts.inter(
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: h * 0.012),
              SizedBox(
                width: double.infinity,
                height: h * 0.055,
                child: TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    'Not now',
                    style: GoogleFonts.inter(
                      fontSize: w * 0.035,
                      color: Colors.white38,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPoint(double w, IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF3B82F6), size: w * 0.05),
        SizedBox(width: w * 0.03),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: w * 0.035,
              color: Colors.white70,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
