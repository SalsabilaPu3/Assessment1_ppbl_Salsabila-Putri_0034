
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/theme_cubit.dart';
import 'navigation/app_routes.dart';

void main() {
  runApp(
    BlocProvider(
      create: (_) => ThemeCubit(),
      child: const AgriClimaApp(),
    ),
  );
}

class AgriClimaApp extends StatelessWidget {
  const AgriClimaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'AgriClima LSTM',

          themeMode: mode,

          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2E7D32),
            ),
            scaffoldBackgroundColor: const Color(0xFFF4F7F2),
            useMaterial3: true,
          ),

          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2E7D32),
              brightness: Brightness.dark,
            ),
            brightness: Brightness.dark,
            useMaterial3: true,
          ),

          initialRoute: AppRoutes.beranda,
          routes: AppRoutes.daftarRoute(),
        );
      },
    );
  }
}
