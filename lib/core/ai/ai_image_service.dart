import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIImageService {
  final String apiKey = "AIzaSyCHcZLewCuZfFge6vArl_NrpecD_IE-91U"; // coloque a key do AI Studio

  Future<String> identifyFish(File image) async {
    try {
      final model = GenerativeModel(
        model: "gemini-2.5-flash", // Use o alias da versão 2.5
        apiKey: apiKey,
      );

      // Lê a imagem
      final bytes = await image.readAsBytes();
      final mimeType = image.path.endsWith(".png")
          ? "image/png"
          : "image/jpeg";

      final content = [
        Content.multi([
          TextPart(
            "Você é um especialista em identificação de peixes do Brasil. "
            "Analise a imagem e identifique a espécie do peixe. "
            "Responda APENAS com o nome popular em português do Brasil. "
            "Não use nome científico. "
            "Não use nomes em inglês. "
            "Não escreva frases, apenas o nome do peixe."
          ),
          DataPart(mimeType, bytes),
        ])
      ];

      final response = await model.generateContent(content);

      if (response.text == null) {
        return "Não foi possível identificar.";
      }

      return response.text!.trim();
    } catch (e) {
      return "Erro ao identificar: $e";
    }
  }
}
