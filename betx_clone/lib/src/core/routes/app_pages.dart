import 'package:get/get.dart';

import '../../presentation/pages/splash/splash_page.dart';
import '../../presentation/pages/onboarding/onboarding_page.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/sports/sports_page.dart';
import '../../presentation/pages/casino/casino_page.dart';
import '../../presentation/pages/wallet/wallet_page.dart';
import '../../presentation/pages/bets/bets_page.dart';
import '../../presentation/pages/settings/settings_page.dart';
import '../../presentation/pages/auth/auth_page.dart';
import '../../presentation/pages/age_gate/age_gate_page.dart';

import '../../presentation/bindings/splash_binding.dart';
import '../../presentation/bindings/home_binding.dart';
import '../../presentation/bindings/sports_binding.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingPage(),
    ),
    GetPage(
      name: AppRoutes.ageGate,
      page: () => const AgeGatePage(),
    ),
    GetPage(
      name: AppRoutes.auth,
      page: () => const AuthPage(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.sports,
      page: () => const SportsPage(),
      binding: SportsBinding(),
    ),
    GetPage(name: AppRoutes.casino, page: () => const CasinoPage()),
    GetPage(name: AppRoutes.wallet, page: () => const WalletPage()),
    GetPage(name: AppRoutes.bets, page: () => const BetsPage()),
    GetPage(name: AppRoutes.settings, page: () => const SettingsPage()),
  ];
}
