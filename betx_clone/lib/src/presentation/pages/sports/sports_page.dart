import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/sports_controller.dart';

class SportsPage extends GetView<SportsController> {
  const SportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sports')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: controller.onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Search teams, leagues...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.separated(
                itemBuilder: (_, i) {
                  final item = controller.filteredEvents[i];
                  return ListTile(
                    title: Text(item.title),
                    subtitle: Text(item.subtitle),
                    trailing: AnimatedScale(
                      duration: const Duration(milliseconds: 200),
                      scale: controller.isInSlip(item.id) ? 1.1 : 1.0,
                      child: FilledButton.tonal(
                        onPressed: () => controller.toggleSlip(item.id),
                        child: Text(controller.isInSlip(item.id) ? 'Added' : 'Add'),
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemCount: controller.filteredEvents.length,
              ),
            ),
          ),
          _BetSlip(),
        ],
      ),
    );
  }
}

class _BetSlip extends GetView<SportsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: const [
            BoxShadow(
              blurRadius: 12,
              color: Colors.black26,
              offset: Offset(0, -4),
            )
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text('Bet Slip • ${controller.slipeventIds.length}'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.clear_all),
                  onPressed: controller.clearSlip,
                )
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: controller.slipeventIds.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(bottom: 6),
                      child: Align(alignment: Alignment.centerLeft, child: Text('No selections')),
                    )
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 8,
                        children: controller.slipeventIds
                            .map((e) => Chip(
                                  label: Text('Pick $e'),
                                  onDeleted: () => controller.toggleSlip(e),
                                ))
                            .toList(),
                      ),
                    ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: controller.slipeventIds.isEmpty ? null : controller.placeBet,
                    child: const Text('Place Bet'),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
