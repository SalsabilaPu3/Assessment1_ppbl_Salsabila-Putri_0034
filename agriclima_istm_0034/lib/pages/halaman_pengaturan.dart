
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/theme_cubit.dart';

class HalamanPengaturan extends StatelessWidget {
  const HalamanPengaturan({super.key});

  @override
  Widget build(BuildContext context) {
    const hijau = Color(0xFF2E7D32);

    final mode = context.watch<ThemeCubit>().state;
    final darkMode = mode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: const Color.fromARGB(255, 53, 19, 128),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Dark Mode',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            darkMode
                ? 'Mode gelap aktif'
                : 'Mode terang aktif',
          ),
          value: darkMode,
          activeColor: const Color.fromARGB(255, 59, 46, 125),
          onChanged: (value) {
            context.read<ThemeCubit>().toggle();
          },
        ),
      ),
    );
  }
}
