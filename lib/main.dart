import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'services/storage_service.dart';
import 'services/game_state_provider.dart';
import 'services/puzzle_service.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize storage service
  final storageService = await StorageService.initialize();

  runApp(CipherAcademyApp(storageService: storageService));
}

class CipherAcademyApp extends StatelessWidget {
  final StorageService storageService;

  const CipherAcademyApp({
    super.key,
    required this.storageService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storageService),
        Provider<PuzzleService>(create: (_) => PuzzleService()),
        ChangeNotifierProvider<GameStateProvider>(
          create: (context) => GameStateProvider(
            context.read<StorageService>(),
            context.read<PuzzleService>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Cipher Academy',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    _checkInitialization();
  }

  Future<void> _checkInitialization() async {
    await Future.delayed(const Duration(milliseconds: 2500));

    if (mounted) {
      final gameState = context.read<GameStateProvider>();

      while (gameState.isLoading) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.darkNavy,
              AppTheme.burgundy.withOpacity(0.8),
              AppTheme.forestGreen.withOpacity(0.6),
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.brass,
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.auto_stories,
                      size: 80,
                      color: AppTheme.brass,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'CIPHER ACADEMY',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: AppTheme.brass,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Unlock the Mysteries',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.parchment,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                  const SizedBox(height: 48),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.brass),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
