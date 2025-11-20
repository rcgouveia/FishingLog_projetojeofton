import 'package:flutter/material.dart';

class FishingCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String description;
  final double price;

  const FishingCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
  }) : super(key: key);

  @override
  State<FishingCard> createState() => _FishingCardState();
}

class _FishingCardState extends State<FishingCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            widget.imageUrl,
            fit: BoxFit.cover,
            height: 180,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 180,
              color: Colors.grey[300],
              alignment: Alignment.center,
              child: const Icon(Icons.broken_image),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(widget.description),
                const SizedBox(height: 8),
                Text('R\$ ${widget.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Fishing Store",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FishingCard(
            imageUrl:
                "https://images.unsplash.com/photo-1509470698895-81bdd988ba2c",
            title: "Kit de Pesca Profissional",
            description: "Conjunto completo para pesca esportiva.",
            price: 249.90,
          ),
          const SizedBox(height: 16),
          FishingCard(
            imageUrl:
                "https://images.unsplash.com/photo-1508186225823-0963cf9ab0de",
            title: "Isca Artificial Premium",
            description: "Alta performance e super resistente.",
            price: 39.90,
          ),
          const SizedBox(height: 16),
          FishingCard(
            imageUrl:
                "https://images.unsplash.com/photo-1520256862855-398228c41684",
            title: "Vara de Pesca em Carbono",
            description: "Leve, durável e excelente para longas pescarias.",
            price: 189.00,
          ),
        ],
      ),
    );
  }
}
