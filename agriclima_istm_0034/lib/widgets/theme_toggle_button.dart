import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/theme_cubit.dart';

class HalamanPengaturan extends StatelessWidget {
  const HalamanPengaturan({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = context.watch<ThemeCubit>().state;
    final gelap = mode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListTile(
        title: const Text('Dark Mode'),
        subtitle: Text(gelap ? 'Mode gelap aktif' : 'Mode terang aktif'),
        trailing: Switch(
          value: gelap,
          onChanged: (_) {
            context.read<ThemeCubit>().toggle();
          },
        ),
      ),
    );
  }
}
