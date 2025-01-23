import 'package:flutter/material.dart';
import '../utils/assets.dart';
import '../widgets/mindfulness_card_widget.dart';
import 'songboard.dart';

class MindfulnessGrid extends StatelessWidget {
  const MindfulnessGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 12.8,
        right: 12.8,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 3.2,
      ),
      itemCount: kMindFullnessAssets.length,
      itemBuilder: (context, index) {
        final asset = kMindFullnessAssets[index];

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
          child: MindfulnessCardWidget(asset: asset),
        );
      },
    );
  }
}
