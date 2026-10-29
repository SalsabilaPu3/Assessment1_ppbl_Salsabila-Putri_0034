
import 'package:flutter/material.dart';
import '../models/prediksi_model.dart';

class PrediksiCard extends StatelessWidget {
  final Prediksi prediksi;
  final VoidCallback onTap;

  const PrediksiCard({
    super.key,
    required this.prediksi,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: Icon(
            Icons.eco,
            color: theme.colorScheme.primary,
          ),
        ),
        title: Text(
          'Prediksi ${prediksi.petak}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            'Suhu: ${prediksi.suhu} °C\n'
            'Kelembapan: ${prediksi.kelembapan} %\n'
            'Curah hujan: ${prediksi.curahHujan} mm',
            style: theme.textTheme.bodyMedium,
          ),
        ),
        isThreeLine: true,
        trailing: IconButton(
          icon: Icon(
            Icons.arrow_forward_ios,
            color: theme.colorScheme.primary,
            size: 18,
          ),
          onPressed: onTap,
        ),
      ),
    );
  }
}
