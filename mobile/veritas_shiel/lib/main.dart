import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_colors.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/service_locator.dart' as di;
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/vault/presentation/cubit/vault_cubit.dart';
import 'features/analysis/presentation/cubit/analysis_cubit.dart';
import 'features/profile/presentation/cubit/profile_cubit.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await di.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthCubit>()),
        BlocProvider(create: (_) => di.sl<VaultCubit>()),
        BlocProvider(create: (_) => di.sl<AnalysisCubit>()),
        BlocProvider(create: (_) => di.sl<ProfileCubit>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Close keyboard when tapping anywhere outside a focused field
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        title: 'Veritas Shield',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
          textTheme: GoogleFonts.interTextTheme(),
        ),
        initialRoute: Routes.home,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
