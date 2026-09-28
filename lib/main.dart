// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:otlop_app/core/theme/app_colors.dart';
import 'package:otlop_app/core/theme/theme_cubit.dart';
import 'package:otlop_app/features/auth/data/auth_session.dart';
import 'package:otlop_app/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';
import 'package:otlop_app/features/auth/presentation/screens/login_screen.dart';
import 'package:otlop_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:otlop_app/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:otlop_app/features/splash/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('app_session');
  AuthSession.init();
  final settingsBox = await Hive.openBox('app_settings');
  runApp(OtlopApp(settingsBox: settingsBox));
}

class OtlopApp extends StatelessWidget {
  const OtlopApp({super.key, required this.settingsBox});

  final Box<dynamic> settingsBox;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CartCubit()),
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => OrdersCubit()),
        BlocProvider(create: (context) => ThemeCubit(settingsBox)),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) => MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryClr,
              brightness: Brightness.light,
              primary: AppColors.primaryClr,
              onPrimary: Colors.white,
              surface: AppColors.surfaceClr,
              onSurface: AppColors.blackClr,
              surfaceContainerHighest: AppColors.surfaceContainerHighest,
              onSurfaceVariant: AppColors.greyClr,
              outline: AppColors.borderClr,
              outlineVariant: AppColors.greyLightClr,
            ),
            scaffoldBackgroundColor: AppColors.scaffoldBackgroundClr,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.scaffoldBackgroundClr,
              foregroundColor: AppColors.blackClr,
              elevation: 0,
              centerTitle: true,
              scrolledUnderElevation: 0,
            ),
            cardTheme: CardThemeData(
              color: AppColors.surfaceClr,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.borderClr, width: 1),
              ),
              margin: EdgeInsets.zero,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryClr,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
            ),
            snackBarTheme: SnackBarThemeData(
              backgroundColor: AppColors.blackClr,
              contentTextStyle: const TextStyle(color: Colors.white),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryClr,
              brightness: Brightness.dark,
              primary: AppColors.primaryClr,
              onPrimary: Colors.white,
              surface: AppColors.surfaceDarkClr,
              onSurface: const Color(0xFFF5F5F7),
              surfaceContainerHighest: AppColors.surfaceContainerHighestDark,
              onSurfaceVariant: const Color(0xFFA19E9B),
              outline: AppColors.borderDarkClr,
              outlineVariant: const Color(0xFF2C2932),
            ),
            scaffoldBackgroundColor: AppColors.scaffoldBackgroundDarkClr,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.scaffoldBackgroundDarkClr,
              foregroundColor: Color(0xFFF5F5F7),
              elevation: 0,
              centerTitle: true,
              scrolledUnderElevation: 0,
            ),
            cardTheme: CardThemeData(
              color: AppColors.surfaceDarkClr,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.borderDarkClr, width: 1),
              ),
              margin: EdgeInsets.zero,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryClr,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
            ),
            snackBarTheme: SnackBarThemeData(
              backgroundColor: AppColors.surfaceContainerHighestDark,
              contentTextStyle: const TextStyle(color: Color(0xFFF5F5F7)),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
