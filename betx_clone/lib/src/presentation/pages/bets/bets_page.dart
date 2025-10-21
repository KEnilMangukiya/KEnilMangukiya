import 'package:flutter/material.dart';

class BetsPage extends StatelessWidget {
  const BetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Bets')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 6,
        itemBuilder: (_, i) => ListTile(
          leading: const Icon(Icons.receipt_long),
          title: Text('Bet #${i + 12345}'),
          subtitle: const Text('3 selections • Pending'),
          trailing: const Text('₹ 250'),
        ),
        separatorBuilder: (_, __) => const Divider(height: 1),
      ),
    );
  }
}
