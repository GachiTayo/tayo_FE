// lib/config/routes.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tayo_fe/screens/create/carpool_create_room_screen.dart';
import 'package:tayo_fe/screens/create/fixed_carpool_create_room_screen.dart';
import 'package:tayo_fe/screens/create/taxi_create_room_screen.dart';
import 'package:tayo_fe/screens/home/home_screen.dart';
import 'package:tayo_fe/screens/home/home_test.dart';
import 'package:tayo_fe/screens/login/login_screen.dart';
import 'package:tayo_fe/screens/login/signin_screen.dart';
import 'package:tayo_fe/screens/mypage/mypage_screen.dart';
import 'package:tayo_fe/screens/myrides/myrides.dart';
import 'package:tayo_fe/widgets/common/main_scaffold.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signin',
        builder: (context, state) => const SignInScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const RideTestPage(),
          ),
          GoRoute(
            path: '/rides',
            builder: (context, state) => const MyRidesScreen(),
          ),
          GoRoute(
            path: '/mypage',
            builder: (context, state) => const MyPageScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/create-carpool',
        builder: (context, state) => const CarpoolCreateRoomScreen(),
      ),
      GoRoute(
        path: '/create-taxi',
        builder: (context, state) => const TaxiCreateRoomScreen(),
      ),
      GoRoute(
        path: '/create-fixed-carpool',
        builder: (context, state) => const FixedCarpoolCreateRoomScreen(),
      ),
      // TODO test route 지우기
      GoRoute(
        path: '/test-rides',
        builder: (context, state) => const RideTestPage(),
      ),
    ],
    errorBuilder:
        (context, state) =>
            const Scaffold(body: Center(child: Text('Page not found!'))),
  );
}
