import 'package:flutter/material.dart';

class CustomMenuBar extends StatelessWidget {
  const CustomMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 48,
      child: TabBar(
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black54,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(width: 4.0, color: Theme.of(context).colorScheme.primary),
          insets: EdgeInsets.symmetric(horizontal: 32.0),
        ),
        tabs: const [
          Tab(text: '카풀 / 택시'),
          Tab(text: '고정카풀'),
        ],
      ),
    );
  }
}
