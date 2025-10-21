import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

class SportsEvent extends Equatable {
  final String id;
  final String title;
  final String subtitle;

  const SportsEvent({required this.id, required this.title, required this.subtitle});

  @override
  List<Object?> get props => [id, title, subtitle];
}

class SportsController extends GetxController {
  final RxList<SportsEvent> events = <SportsEvent>[..._seed].obs;
  final RxList<SportsEvent> filtered = <SportsEvent>[..._seed].obs;
  final RxList<String> slipeventIds = <String>[].obs;

  List<SportsEvent> get filteredEvents => filtered;

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      filtered.value = [...events];
      return;
    }
    final q = query.toLowerCase();
    filtered.value = events.where((e) => e.title.toLowerCase().contains(q) || e.subtitle.toLowerCase().contains(q)).toList();
  }

  void toggleSlip(String id) {
    if (slipeventIds.contains(id)) {
      slipeventIds.remove(id);
    } else {
      slipeventIds.add(id);
    }
  }

  bool isInSlip(String id) => slipeventIds.contains(id);

  void clearSlip() => slipeventIds.clear();

  void placeBet() {
    Get.snackbar('Bet placed', 'Good luck!');
    clearSlip();
  }
}

const _seed = [
  SportsEvent(id: '1', title: 'India vs Australia', subtitle: 'Cricket • ODI'),
  SportsEvent(id: '2', title: 'Manchester Utd vs Liverpool', subtitle: 'Football • Premier League'),
  SportsEvent(id: '3', title: 'Lakers vs Celtics', subtitle: 'Basketball • NBA'),
  SportsEvent(id: '4', title: 'Djokovic vs Alcaraz', subtitle: 'Tennis • ATP'),
  SportsEvent(id: '5', title: 'MI vs CSK', subtitle: 'Cricket • IPL'),
];
