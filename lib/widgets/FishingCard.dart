import 'package:flutter/material.dart';
import '../models/FishingLogModel.dart';

class FishingCard extends StatelessWidget {
  final FishingLogModel log;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const FishingCard({
    super.key,
    required this.log,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        onTap: onTap,
        title: Text(
          log.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
            "${log.weight.toStringAsFixed(2)} kg • ${log.height.toStringAsFixed(1)} cm\nLocal: ${log.location}\n${log.date.day}/${log.date.month}/${log.date.year}"),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
