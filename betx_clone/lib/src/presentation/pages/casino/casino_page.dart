import 'package:flutter/material.dart';

class CasinoPage extends StatelessWidget {
  const CasinoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Casino')),
      body: Center(
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(
            8,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              width: 140,
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Text('Game ${i + 1}')),
            ),
          ),
        ),
      ),
    );
  }
}
