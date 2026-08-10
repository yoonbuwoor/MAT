import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../services/location_service.dart';
import 'main_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  bool _isOpening = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, .04),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _openApplication() async {
    if (_isOpening) return;
    setState(() => _isOpening = true);
    final permission = await LocationService.permissionStatus();
    final shouldRequestLocation = permission == LocationPermission.denied
        ? await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                icon: const Icon(
                  Icons.my_location_rounded,
                  color: AppTheme.teal,
                  size: 34,
                ),
                title: const Text('Autoriser la localisation ?'),
                content: const Text(
                  'Moi, Géomaticien utilise ta position précise uniquement lorsque l’application est ouverte, pour afficher X/Y et enregistrer les points que tu décides. Les positions restent sur ton téléphone et ne sont pas transmises à Novateur221.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Pas maintenant'),
                  ),
                  FilledButton.icon(
                    onPressed: () => Navigator.pop(context, true),
                    icon: const Icon(Icons.location_on_rounded),
                    label: const Text('Autoriser'),
                  ),
                ],
              ),
            ) ??
            false
        : false;
    if (shouldRequestLocation) {
      try {
        await LocationService.requestPermission();
      } on LocationServiceException {
        // L’utilisateur peut continuer et réautoriser depuis le module Terrain.
      }
    }
    await Future<void>.delayed(const Duration(milliseconds: 180));
    if (!mounted) return;
    await Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 520),
        pageBuilder: (_, animation, __) => MainShell(
          controller: widget.controller,
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, .035),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _Background(),
          SafeArea(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/images/novateur221.png',
                              width: 34,
                              height: 34,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'NOVATEUR221',
                            style: TextStyle(
                              color: AppTheme.ink,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.25,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Center(
                        child: Container(
                          width: 148,
                          height: 148,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(44),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.coral.withOpacity(.18),
                                blurRadius: 40,
                                offset: const Offset(0, 18),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/moi_geomaticien_logo.png',
                          ),
                        ),
                      ),
                      const SizedBox(height: 26),
                      const Center(
                        child: Text(
                          'Moi, Géomaticien',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.ink,
                            fontSize: 31,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      const Center(
                        child: Text(
                          'Comprendre • Relever • Explorer',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.purple,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(24, 26, 24, 26),
                        decoration: BoxDecoration(
                          color: AppTheme.ink,
                          borderRadius: BorderRadius.circular(31),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.format_quote_rounded,
                              color: AppTheme.orange,
                              size: 31,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Que nul n’entre ici\ns’il n’est Géomaticien.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                height: 1.34,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _isOpening ? null : _openApplication,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.coral,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                                AppTheme.coral.withOpacity(.60),
                            minimumSize: const Size.fromHeight(58),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_isOpening) ...[
                                const SizedBox(
                                  width: 19,
                                  height: 19,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.3,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 11),
                              ],
                              Text(
                                _isOpening
                                    ? 'OUVERTURE…'
                                    : 'ENTRER DANS L’APPLICATION',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: .3,
                                ),
                              ),
                              if (!_isOpening) ...[
                                const SizedBox(width: 10),
                                const Icon(Icons.arrow_forward_rounded),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 13),
                      const Center(
                        child: Text(
                          'Le guide méthodologique du géomaticien',
                          style: TextStyle(
                            color: AppTheme.muted,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFBF8), Color(0xFFF5ECE8)],
        ),
      ),
      child: CustomPaint(painter: _ContourPainter()),
    );
  }
}

class _ContourPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.coral.withOpacity(.065)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (var index = 0; index < 6; index++) {
      final inset = 18.0 + index * 24;
      final rect = Rect.fromLTWH(
        -80 + inset,
        size.height * .11 + inset,
        size.width + 170 - inset * 2,
        size.height * .54 - inset * 1.2,
      );
      canvas.drawOval(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
