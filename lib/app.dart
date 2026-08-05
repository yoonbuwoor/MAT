import 'package:flutter/material.dart';
import 'core/app_controller.dart';
import 'core/app_theme.dart';
import 'screens/splash_screen.dart';

class MoiGeomaticienBootstrap extends StatefulWidget {
  const MoiGeomaticienBootstrap({super.key});

  @override
  State<MoiGeomaticienBootstrap> createState() => _MoiGeomaticienBootstrapState();
}

class _MoiGeomaticienBootstrapState extends State<MoiGeomaticienBootstrap> {
  final AppController controller = AppController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Moi, Géomaticien',
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: controller.themeMode,
          home: SplashScreen(controller: controller),
        );
      },
    );
  }
}
