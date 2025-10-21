import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  final RxBool isOnline = true.obs;
  late final Stream<ConnectivityResult> _stream;

  Future<ConnectivityService> init() async {
    final result = await Connectivity().checkConnectivity();
    isOnline.value = result != ConnectivityResult.none;
    _stream = Connectivity().onConnectivityChanged;
    _stream.listen((event) {
      isOnline.value = event != ConnectivityResult.none;
    });
    return this;
  }
}
