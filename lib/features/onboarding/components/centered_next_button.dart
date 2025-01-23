import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../authentication/screens/signin_screen.dart';
import '../../authentication/screens/signup_screen.dart';
import '../constants.dart';
import 'views.dart';

class NextButton extends StatefulWidget {
  const NextButton({
    super.key,
    required this.onClick,
    required this.animationController,
  });

  final VoidCallback onClick;
  final AnimationController animationController;

  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  late final Animation<Offset> _topMoveAnimation;
  late final Animation<double> _signUpMoveAnimation;
  late final Animation<Offset> _loginTextMoveAnimation;

  @override
  void initState() {
    _topMoveAnimation = Tween<Offset>(
      begin: const Offset(0, 7),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(
          0.0,
          0.2,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    _signUpMoveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(
          aiChatView,
          welcomeView,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    _loginTextMoveAnimation = Tween<Offset>(
      begin: const Offset(0.0, 5.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(
          aiChatView,
          welcomeView,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SlideTransition(
              position: _topMoveAnimation,
              child: DotDatPageView(
                animationController: widget.animationController,
              ),
            ),
            SlideTransition(
              position: _topMoveAnimation,
              child: AnimatedBuilder(
                animation: _signUpMoveAnimation,
                builder: (context, child) {
                  return Container(
                    height: 60,
                    width: 60 + (150 * _signUpMoveAnimation.value),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        8 + 30 * (1 - _signUpMoveAnimation.value),
                      ),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: PageTransitionSwitcher(
                      duration: const Duration(milliseconds: 400),
                      reverse: _signUpMoveAnimation.value < 0.7,
                      transitionBuilder:
                          (child, primaryAnimation, secondaryAnimation) {
                        return SharedAxisTransition(
                          animation: primaryAnimation,
                          secondaryAnimation: secondaryAnimation,
                          transitionType: SharedAxisTransitionType.horizontal,
                          fillColor: Colors.transparent,
                          child: child,
                        );
                      },
                      child: _signUpMoveAnimation.value > 0.7
                          ? InkWell(
                              key: const ValueKey('signup button'),
                              onTap: () {
                                if (widget.animationController.value >=
                                    welcomeView) {
                                  Navigator.of(context).pushReplacementNamed(
                                    SignUpScreen.routeName,
                                  );
                                }
                                widget.onClick();
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: .7,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Icon(
                                      CupertinoIcons.forward,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            )
                          : InkWell(
                              key: const ValueKey('next button'),
                              borderRadius: BorderRadius.circular(38),
                              onTap: widget.onClick,
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  CupertinoIcons.forward,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: SlideTransition(
                position: _loginTextMoveAnimation,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black87
                            : Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.only(left: 0),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(
                          SignInScreen.routeName,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
