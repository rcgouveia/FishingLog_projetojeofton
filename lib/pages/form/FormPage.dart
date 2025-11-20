import 'package:flutter/material.dart';
import '../../models/FishingLogModel.dart';
import '../../repositories/FishingLogRepository.dart';

class FormPage extends StatefulWidget {
  final FishingLogRepository repository;
  final FishingLogModel? existing;

  const FormPage({super.key, required this.repository, this.existing});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final weightCtrl = TextEditingController();
  final heightCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final e = widget.existing!;
      nameCtrl.text = e.name;
      weightCtrl.text = e.weight.toString();
      heightCtrl.text = e.height.toString();
      locationCtrl.text = e.location;
      date = e.date;
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    weightCtrl.dispose();
    heightCtrl.dispose();
    locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => date = picked);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar registro' : 'Novo registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nome do peixe'),
                validator: (v) => (v == null || v.isEmpty) ? 'Preencha o nome' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: weightCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Peso (kg)'),
                validator: (v) {
                  final x = double.tryParse(v ?? '');
                  if (x == null || x <= 0) return 'Peso inválido';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: heightCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Comprimento (cm)'),
                validator: (v) {
                  final x = double.tryParse(v ?? '');
                  if (x == null || x <= 0) return 'Comprimento inválido';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: locationCtrl,
                decoration: const InputDecoration(labelText: 'Local'),
                validator: (v) => (v == null || v.isEmpty) ? 'Preencha o local' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: Text("${date.day}/${date.month}/${date.year}"),
                    onPressed: _pickDate,
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Container()),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final model = FishingLogModel(
                    id: widget.existing?.id ?? DateTime.now().millisecondsSinceEpoch,
                    name: nameCtrl.text,
                    weight: double.tryParse(weightCtrl.text) ?? 0.0,
                    height: double.tryParse(heightCtrl.text) ?? 0.0,
                    location: locationCtrl.text,
                    date: date,
                  );

                  if (isEditing) {
                    await widget.repository.update(model.id, model);
                  } else {
                    await widget.repository.create(model);
                  }

                  if (!mounted) return;
                  Navigator.pop(context);
                },
                child: Text(isEditing ? 'Salvar' : 'Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
