import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.gradient,
    this.borderRadius,
    this.elevation,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final Gradient? gradient;
  final BorderRadius? borderRadius;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation ?? 0,
      borderRadius: borderRadius ??
          BorderRadius.circular(height != null ? height! / 2.0 : 25),
      shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
      child: Container(
        padding: padding ?? EdgeInsets.zero,
        width: padding == null
            ? width == null
                ? 200
                : width!
            : null,
        height: padding == null
            ? height == null
                ? 50
                : height!
            : null,
        decoration: BoxDecoration(
          borderRadius: borderRadius ??
              BorderRadius.circular(height != null ? height! / 2.0 : 25),
          boxShadow: elevation == null
              ? null
              : [
                  BoxShadow(
                    offset: const Offset(1, 2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  )
                ],
          gradient: gradient ??
              LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.84),
                  Theme.of(context).colorScheme.primary.withOpacity(0.92),
                  Theme.of(context).colorScheme.primary,
                ],
                stops: const [0.36, 0.59, 1.0],
              ),
        ),
        child: MaterialButton(
          minWidth: width != null ? width! : 150,
          height: height != null ? height! : 50,
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ??
                BorderRadius.circular(
                  height != null ? height! / 2.0 : 25,
                ),
          ),
          child: Stack(
            children: [
              // Positioned(
              //   top: -18,
              //   left: width != null ? width! * 0.85 : 40,
              //   child: Opacity(
              //     opacity: 0.5,
              //     child: Container(
              //       width: width != null ? width! * 0.2 : 40,
              //       height: height != null ? height! * 0.8 : 40,
              //       clipBehavior: Clip.antiAlias,
              //       decoration: BoxDecoration(
              //         shape: BoxShape.circle,
              //         color: Theme.of(context)
              //             .secondaryHeaderColor
              //             .withOpacity(0.3),
              //       ),
              //     ),
              //   ),
              // ),
              // Positioned(
              //   top: 18,
              //   left: width != null ? width! * 0.80 : 80,
              //   child: Opacity(
              //     opacity: 0.5,
              //     child: Container(
              //       width: width != null ? width! * 0.1 : 10,
              //       height: height != null ? height! * 0.4 : 40,
              //       clipBehavior: Clip.antiAlias,
              //       decoration: BoxDecoration(
              //         shape: BoxShape.circle,
              //         border: Border.fromBorderSide(
              //           BorderSide(
              //             color: Theme.of(context)
              //                 .secondaryHeaderColor
              //                 .withOpacity(0.32),
              //             width: 2.5,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Align(
                alignment: Alignment.center,
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
