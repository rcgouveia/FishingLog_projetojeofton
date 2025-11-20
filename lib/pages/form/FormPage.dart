import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/FishingLogModel.dart';
import '../../repositories/FishingLogRepository.dart';
import '../../core/ai/ai_image_service.dart';

class FormPage extends StatefulWidget {
  final FishingLogRepository repository;
  final FishingLogModel? existing;

  /// opcional: caminho local para imagem já disponível (ex: /mnt/data/xxx.png)
  final String? initialImagePath;

  const FormPage({
    super.key,
    required this.repository,
    this.existing,
    this.initialImagePath,
  });

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final weightCtrl = TextEditingController();
  final heightCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final baitCtrl = TextEditingController();
  DateTime date = DateTime.now();

  final ImagePicker _picker = ImagePicker();
  final AIImageService _ai = AIImageService();

  File? selectedImage;
  bool loadingAI = false;

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

    // Se o chamador passou um caminho de imagem local, carrega e tenta detectar o peixe
    if (widget.initialImagePath != null && widget.initialImagePath!.isNotEmpty) {
      final f = File(widget.initialImagePath!);
      if (f.existsSync()) {
        selectedImage = f;
        // executa a detecção sem bloquear initState (chamada assíncrona após frame)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _detectFishFromFile(f);
        });
      }
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

  Future<void> _pickImage({required bool camera}) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: camera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 75,
      );

      if (picked != null) {
        final file = File(picked.path);
        setState(() {
          selectedImage = file;
        });
        await _detectFishFromFile(file);
      }
    } catch (e) {
      // tratar erros de permissão, etc.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao selecionar imagem: $e')),
      );
    }
  }

  Future<void> _detectFishFromFile(File file) async {
    setState(() => loadingAI = true);
    try {
      final suggestion = await _ai.identifyFish(file);
      if (suggestion.trim().isNotEmpty) {
        setState(() {
          nameCtrl.text = suggestion.trim();
        });
      } else {
        // IA não retornou sugestão
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('IA não identificou o peixe.')),
        );
      }
    } catch (e) {
      // captura NoSuchMethod/JSON issues e outros
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro IA: $e')),
      );
    } finally {
      setState(() => loadingAI = false);
    }
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
              // --- Imagem selecionada / botão para escolher ---
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.camera_alt),
                            title: const Text('Tirar foto'),
                            onTap: () {
                              Navigator.pop(context);
                              _pickImage(camera: true);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.photo_album),
                            title: const Text('Escolher da galeria'),
                            onTap: () {
                              Navigator.pop(context);
                              _pickImage(camera: false);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    image: selectedImage != null
                        ? DecorationImage(
                            image: FileImage(selectedImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: selectedImage == null
                      ? const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.camera_alt, size: 40, color: Colors.black54),
                            SizedBox(height: 8),
                            Text('Toque para adicionar foto'),
                          ],
                        )
                      : null,
                ),
              ),

              const SizedBox(height: 12),
              // botão que também dispara detecção caso queira reprocessar
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(labelText: 'Nome do peixe'),
                      validator: (v) => (v == null || v.isEmpty) ? 'Preencha o nome' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Detectar nome pela imagem',
                    icon: loadingAI
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.image_search),
                    onPressed: selectedImage == null || loadingAI
                        ? null
                        : () => _detectFishFromFile(selectedImage!),
                  )
                ],
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
              const SizedBox(height: 10),

              TextFormField(
                controller: baitCtrl,
                decoration: const InputDecoration(labelText: 'Isca usada'),
                validator: (v) => (v == null || v.isEmpty) ? 'Informe a isca usada' : null,
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
                    id: widget.existing?.id ?? (DateTime.now().microsecondsSinceEpoch & 0xFFFFFFFF),
                    name: nameCtrl.text,
                    weight: double.tryParse(weightCtrl.text) ?? 0.0,
                    height: double.tryParse(heightCtrl.text) ?? 0.0,
                    location: locationCtrl.text,
                    date: date,
                    imagePath: selectedImage!.path, // <-- SALVA A FOTO
                    bait: baitCtrl.text,
                    // se quiser salvar caminho da imagem no modelo, adicione um campo e passe selectedImage?.path
                  );

                  if (isEditing) {
                    await widget.repository.update(model.id, model);
                  } else {
                    await widget.repository.create(model);
                  }

                  if (!mounted) return;
                  Navigator.pop(context, model);
                },
                child: Text(isEditing ? 'Salvar' : 'Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get isEditing => widget.existing != null;
}
