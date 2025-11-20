import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIImageService {
  final String apiKey = "SUA_KEY_AQUI";

  Future<String> identifyFish(File image) async {
    try {
      final model = GenerativeModel(
        model: "gemini-2.5-flash",
        apiKey: apiKey,
      );

      final bytes = await image.readAsBytes();
      final mimeType =
          image.path.endsWith(".png") ? "image/png" : "image/jpeg";

      final response = await model.generateContent([
        Content.text(
          "Você é um especialista em peixes do Brasil. "
          "Identifique a espécie presente na imagem. "
          "Responda APENAS com o nome popular (português)."
        ),
        Content.data(mimeType, bytes),
      ]);

      return response.text?.trim() ?? "Não foi possível identificar.";
    } catch (e) {
      return "Erro ao identificar: $e";
    }
  }
}
