import 'dart:ui';
import 'package:get/get.dart';

class LocaleController extends GetxController {
  String get currentLanguage => Get.locale?.languageCode ?? 'en';

  void changeLanguage(String languageCode) {
    Locale locale = Locale(languageCode);
    Get.updateLocale(locale);
  }
}
