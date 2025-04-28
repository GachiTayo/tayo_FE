// lib/widgets/common/main_scaffold.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatefulWidget {
  final Widget child;

  const MainScaffold({Key? key, required this.child}) : super(key: key);

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 1; // Start at Home tab (middle)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          // Navigate based on tab index
          switch (index) {
            case 0:
              context.go('/rides');
              break;
            case 1:
              context.go('/home');
              break;
            case 2:
              context.go('/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: '이용중', // Rides in progress
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈', // Home
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '마이페이지', // My Page
          ),
        ],
      ),
    );
  }
}
