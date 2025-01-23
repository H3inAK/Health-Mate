import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthmate/features/authentication/widgets/custom_button.dart';
import 'package:healthmate/features/onboarding/constants.dart';

class SplashView extends StatelessWidget {
  const SplashView({
    super.key,
    required this.animationController,
  });

  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    final moveUpAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, -1.5),
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          0.0,
          0.2,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    return SlideTransition(
      position: moveUpAnimation,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Image.asset('assets/images/medical_edu.png'),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 16.0),
            child: Text(
              'Health Mate',
              style: GoogleFonts.getFont(
                'Poppins',
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Text(
              "Start your journey towards \na healthier lifestyle. \nWe're here to guide you every step of the way!",
              style: GoogleFonts.getFont(
                'Poppins',
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Theme.of(context).brightness == Brightness.light
                ? CustomButton(
                    elevation: 0,
                    onPressed: () {
                      animationController.animateTo(habitTrackerView);
                    },
                    width: 240,
                    height: 60,
                    borderRadius: BorderRadius.circular(30.0),
                    child: const Text(
                      'Let\'s begin',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        letterSpacing: 0.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                // ? InkWell(
                //     onTap: () {
                //       animationController.animateTo(0.2);
                //     },
                //     borderRadius: BorderRadius.circular(35.0),
                //     radius: 35,
                //     splashColor: Colors.white,
                //     autofocus: true,
                //     child: Container(
                //       padding: const EdgeInsets.only(
                //         top: 16.0,
                //         bottom: 18.0,
                //         left: 42.0,
                //         right: 42.0,
                //       ),
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(35.0),
                //         color: Theme.of(context).colorScheme.primary,
                //       ),
                //       child: const Text(
                //         'Let\'s begin',
                //         style: TextStyle(color: Colors.white),
                //       ),
                //     ),
                //   )
                : CustomButton(
                    elevation: 6.0,
                    onPressed: () {
                      animationController.animateTo(habitTrackerView);
                    },
                    width: 240,
                    height: 60,
                    borderRadius: BorderRadius.circular(30.0),
                    child: const Text(
                      'Let\'s begin',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
