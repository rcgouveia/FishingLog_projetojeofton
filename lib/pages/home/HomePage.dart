
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/db/HiveConfig.dart';
import '../../models/FishingLogModel.dart';
import '../../repositories/FishingLogRepository.dart';
import '../../widgets/FishingCard.dart';
import '../form/FormPage.dart';
import '../detail/DetailPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final repo = FishingLogRepository();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fishing Log'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FormPage(repository: repo)),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: HiveConfig.logs.listenable(),
        builder: (context, Box<FishingLogModel> box, _) {
          final logs = box.values.toList().cast<FishingLogModel>();
          if (logs.isEmpty) {
            return const Center(child: Text("Nenhum registro de pesca ainda."));
          }
          logs.sort((a, b) => b.date.compareTo(a.date));
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: logs.length,
            itemBuilder: (context, i) {
              final log = logs[i];
              return FishingCard(
                log: log,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPage(log: log, repository: repo),
                    ),
                  );
                },
                onDelete: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Excluir registro'),
                      content: const Text('Deseja excluir este registro?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Excluir'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await repo.delete(log.id);
                    
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
