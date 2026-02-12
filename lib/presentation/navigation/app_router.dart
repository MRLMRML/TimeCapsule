import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:time_capsule/domain/repository/time_capsule_repository.dart';
import 'package:time_capsule/presentation/screens/capsule_detail_screen.dart';
import 'package:time_capsule/presentation/screens/create_capsule_screen.dart';
import 'package:time_capsule/presentation/screens/home_screen.dart';
import 'package:time_capsule/presentation/viewmodel/capsule_viewmodel.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (_, __) => Consumer<TimeCapsuleRepository>(
          builder: (_, repository, __) {
            return ChangeNotifierProvider.value(
              value: CapsuleViewModel(repository),
              child: const HomeScreen(),
            );
          },
        ),
      ),
      GoRoute(
        path: '/create',
        name: 'create',
        builder: (_, __) => const CreateCapsuleScreen(),
      ),
      GoRoute(
        path: '/capsule/:id',
        name: 'detail',
        builder: (_, state) {
          final id = state.pathParameters['id']!;
          return CapsuleDetailScreen(capsuleId: id);
        },
      ),
    ],
  );
}
