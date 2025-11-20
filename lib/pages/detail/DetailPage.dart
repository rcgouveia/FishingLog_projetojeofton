import 'package:flutter/material.dart';
import '../form/FormPage.dart';
import '../../models/FishingLogModel.dart';
import '../../repositories/FishingLogRepository.dart';

class DetailPage extends StatefulWidget {
  final FishingLogModel log;
  final FishingLogRepository repository;

  const DetailPage({
    super.key,
    required this.log,
    required this.repository,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late FishingLogModel log;

  @override
  void initState() {
    super.initState();
    log = widget.log;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(log.fishName),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Excluir registro"),
                  content: const Text("Tem certeza?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancelar"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Excluir"),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await widget.repository.delete(log.id!);
                if (!mounted) return;
                Navigator.pop(context, true);
              }
            },
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _item("Peso", "${log.weight} kg"),
            _item("Comprimento", "${log.length} cm"),
            _item("Local", log.location),
            _item(
              "Data",
              "${log.date.day}/${log.date.month}/${log.date.year}",
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text("Editar registro"),
                onPressed: () async {
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FormPage(
                          repository: widget.repository,
                          existing: log,
                        ),
                    ),
                  );

                  if (updated is FishingLogModel) {
                    setState(() => log = updated);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
