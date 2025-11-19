import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../core/ai/ai_image_service.dart';
import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  File? image;
  String? fishName;

  final picker = ImagePicker();
  final ai = AIImageService();

  Future pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        image = File(picked.path);
      });

      final result = await ai.identifyFish(image!);

      setState(() {
        fishName = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registrar Pescaria")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickImage,
              child: Text("Selecionar Foto do Peixe"),
            ),

            SizedBox(height: 20),

            image != null
                ? Image.file(image!, height: 200)
                : Container(),

            SizedBox(height: 20),

            Text(
              fishName != null
                  ? "Peixe detectado: $fishName"
                  : "Nenhuma identificação ainda.",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
