import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/storage_service.dart';

class AgeGatePage extends StatelessWidget {
  const AgeGatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('age_gate_title'.tr, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text('age_gate_desc'.tr),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.close(0),
                      child: Text('decline'.tr),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        final storage = Get.find<StorageService>();
                        await storage.setBool(StorageKeys.acceptedAgeGate, true);
                        Get.offAllNamed(AppRoutes.onboarding);
                      },
                      child: Text('confirm'.tr),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
