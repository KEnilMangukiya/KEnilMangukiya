import 'package:flutter/material.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Balance', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('₹ 1,000.00', style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: FilledButton(onPressed: () {}, child: const Text('Deposit'))),
                const SizedBox(width: 12),
                Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Withdraw'))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
