import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../core/constants/storage_keys.dart';
import '../../core/services/storage_service.dart';

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  final RxDouble scale = 0.8.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 120), () {
      scale.value = 1.0;
    });
    Future.delayed(const Duration(milliseconds: 1600), () {
      final storage = Get.find<StorageService>();
      final accepted = storage.getBool(StorageKeys.acceptedAgeGate);
      if (accepted) {
        Get.offAllNamed(AppRoutes.onboarding);
      } else {
        Get.offAllNamed(AppRoutes.ageGate);
      }
    });
  }
}
