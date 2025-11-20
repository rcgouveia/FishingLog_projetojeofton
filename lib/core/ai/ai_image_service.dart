import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIImageService {
  final String apiKey = "AIzaSyCHcZLewCuZfFge6vArl_NrpecD_IE-91U";

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
          "Você é um especialista em identificação de peixes do Brasil. "
          "Analise a imagem e identifique a espécie do peixe. "
          "Responda APENAS com o nome popular em português do Brasil. "
          "Não use nome científico. "
          "Não use nomes em inglês. "
          "Não escreva frases, apenas o nome do peixe."
        ),
        Content.data(mimeType, bytes),
      ]);

      return response.text?.trim() ?? "Não foi possível identificar.";
    } catch (e) {
      return "Erro ao identificar: $e";
    }
  }
}
