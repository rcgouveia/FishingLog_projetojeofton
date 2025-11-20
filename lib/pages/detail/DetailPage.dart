
import 'package:flutter/material.dart';
import '../../models/FishingLogModel.dart';
import '../../repositories/FishingLogRepository.dart';
import '../form/FormPage.dart';

class DetailPage extends StatefulWidget {
  final FishingLogModel log;
  final FishingLogRepository repository;

  const DetailPage({super.key, required this.log, required this.repository});

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
        title: Text(log.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Excluir registro'),
                  content: const Text('Deseja excluir este registro?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir')),
                  ],
                ),
              );
              if (ok == true) {
                await widget.repository.delete(log.id);
                if (!mounted) return;
                Navigator.pop(context, true); 
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row('Peso', '${log.weight.toStringAsFixed(2)} kg'),
            _row('Comprimento', '${log.height.toStringAsFixed(1)} cm'),
            _row('Local', log.location),
            _row('Data', '${log.date.day}/${log.date.month}/${log.date.year}'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text('Editar'),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FormPage(repository: widget.repository, existing: log)),
                );
                final updated = await widget.repository.getById(log.id);
                if (updated != null) {
                  setState(() => log = updated);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
