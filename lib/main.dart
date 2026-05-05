import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'data/database.dart';
import 'firebase_options.dart';
import 'pages/home_page.dart';
import 'services/mantenimiento_repository.dart';
import 'services/mantenimiento_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final db = AppDatabase();
  final remoteService = MantenimientoRemoteService();
  final repository = MantenimientoRepository(
    localDb: db,
    remoteService: remoteService,
  );

  runApp(MantenimientoCampusApp(repository: repository));
}

class MantenimientoCampusApp extends StatelessWidget {
  final MantenimientoRepository repository;

  const MantenimientoCampusApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mantenimiento Campus UDEM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E),
        ),
      ),
      home: HomePage(repository: repository),
    );
  }
}

