import 'package:flutter/material.dart';

import '../atomic/skeleton_box.dart';

class ShortenedLinkSkeletonItem extends StatelessWidget {
  const ShortenedLinkSkeletonItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SkeletonBox(height: 14, width: 160),
          SizedBox(height: 8),
          SkeletonBox(height: 12),
        ],
      ),
    );
  }
}
