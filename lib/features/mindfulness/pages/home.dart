import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../authentication/widgets/custom_button.dart';
import 'dashboard.dart';

class MindfullnessPage extends StatelessWidget {
  const MindfullnessPage({
    super.key,
  });

  static const String routeName = '/mindfullness-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 20,
          left: 20,
          right: 20,
          bottom: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset("assets/mindfullness_assets/images/meditation.png"),
            Text(
              "Time to meditate",
              style: GoogleFonts.getFont(
                'Ubuntu',
                fontSize: 36,
                letterSpacing: .6,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Text(
                "Take a breath,\nand ease your mind",
                style: GoogleFonts.getFont(
                  'Ubuntu',
                  fontSize: 24,
                  letterSpacing: .6,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 32.0,
              ),
              child: Theme.of(context).brightness == Brightness.light
                  ? CustomButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MindfulnessGrid(),
                        ),
                      ),
                      child: Text(
                        "Let's Get Started",
                        style: GoogleFonts.aboreto(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 32,
                        ),
                        elevation: 1.2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MindfulnessGrid(),
                        ),
                      ),
                      child: Text(
                        "Let's Get Started",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
