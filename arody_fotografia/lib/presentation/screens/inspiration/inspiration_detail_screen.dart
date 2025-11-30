import 'package:flutter/material.dart';
import '../../../domain/entities/inspiration_item.dart';

class InspirationDetailScreen extends StatelessWidget {
  final InspirationItem item;

  const InspirationDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.title ?? 'Inspiración')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              item.imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(label: Text(item.category)),
                  const SizedBox(height: 16),
                  if (item.title != null)
                    Text(
                      item.title!,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  const SizedBox(height: 8),
                  if (item.description != null)
                    Text(
                      item.description!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
