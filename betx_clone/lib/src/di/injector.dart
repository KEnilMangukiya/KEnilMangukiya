import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/network/api_client.dart';
import '../core/services/connectivity_service.dart';
import '../core/services/storage_service.dart';

Future<void> configureDependencies() async {
  // Network client
  Get.put<ApiClient>(ApiClient(), permanent: true);
  // Storage
  final prefs = await SharedPreferences.getInstance();
  Get.put<StorageService>(StorageService(prefs), permanent: true);
  // Connectivity
  await Get.putAsync<ConnectivityService>(() async => ConnectivityService().init());
}
