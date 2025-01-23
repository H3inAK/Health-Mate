import 'package:flutter/material.dart';

import '../pages/songboard.dart';
import '../utils/assets.dart';

class MindfulnessCardWidget extends StatelessWidget {
  const MindfulnessCardWidget({
    Key? key,
    required this.asset,
    this.padding,
  }) : super(key: key);

  final MindFullnessAsset asset;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                )),
                child: SongBoard(
                  title: asset.title,
                  subtitle: asset.subtitle,
                  imageSource: asset.imageSource,
                  musicSource: asset.musicSource,
                ),
              );
            },
          ),
        );
      },
      child: Card(
        elevation: Theme.of(context).brightness == Brightness.light ? 0.5 : 1,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: asset.imageSource,
                child: Image.asset(
                  'assets/mindfullness_assets/images/${asset.imageSource}',
                  height: 100,
                  width: 100,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                asset.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(asset.subtitle),
            ],
          ),
        ),
      ),
    );
  }
}
