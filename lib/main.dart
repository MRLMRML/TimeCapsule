import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:time_capsule/data/local/time_capsule_box.dart';
import 'package:time_capsule/domain/model/time_capsule.dart';
import 'package:time_capsule/domain/repository/time_capsule_repository.dart';
import 'package:time_capsule/domain/repository/time_capsule_repository_impl.dart';
import 'package:time_capsule/presentation/navigation/app_router.dart';
import 'package:time_capsule/presentation/theme/app_theme.dart';
import 'package:time_capsule/presentation/viewmodel/capsule_viewmodel.dart';
import 'package:time_capsule/utils/notification_helper.dart';
import 'package:time_capsule/workers/notification_worker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await TimeCapsuleBox.openBox();

  await NotificationHelper.initialize();

  runApp(
    MultiProvider(
      providers: [
        Provider<TimeCapsuleRepository>(
          create: (_) => TimeCapsuleRepositoryImpl(
            TimeCapsuleBox.repository,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => CapsuleViewModel(
            context.read<TimeCapsuleRepository>(),
          ),
        ),
      ],
      child: const TimeCapsuleApp(),
    ),
  );

  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );
}

class TimeCapsuleApp extends StatelessWidget {
  const TimeCapsuleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Time Capsule',
      theme: AppTheme.theme,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
