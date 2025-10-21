import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'welcome': 'Welcome to BetX',
          'age_gate_title': 'Are you 18 or older?',
          'age_gate_desc': 'You must confirm you are 18+ to proceed.',
          'confirm': 'Confirm',
          'decline': 'Decline',
          'get_started': 'Get Started',
          'sports': 'Sports',
          'casino': 'Casino',
          'wallet': 'Wallet',
          'settings': 'Settings',
        },
        'hi': {
          'welcome': 'BetX में आपका स्वागत है',
          'age_gate_title': 'क्या आप 18 या उससे अधिक हैं?',
          'age_gate_desc': 'आगे बढ़ने के लिए आपको 18+ की पुष्टि करनी होगी।',
          'confirm': 'पुष्टि करें',
          'decline': 'रद्द करें',
          'get_started': 'शुरू करें',
          'sports': 'खेल',
          'casino': 'कैसीनो',
          'wallet': 'वॉलेट',
          'settings': 'सेटिंग्स',
        }
      };
}
