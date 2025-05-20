import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/locale/locale.dart';
import 'app/locale/locale_controller.dart';
import 'app/view/Invoice/invoice.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const Pos());
}

class Pos extends StatelessWidget {
  const Pos({super.key});

//green     #58be45
  @override
  Widget build(BuildContext context) {
    Get.put(LocaleController());
    return GetMaterialApp(
      home: const Invoice(),
      locale: Get.deviceLocale,
      translations: AppLocale(),
      theme: ThemeData(
        fontFamily: GoogleFonts.cairo().fontFamily,
        scaffoldBackgroundColor: const Color(0xFFf5f7f9),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
