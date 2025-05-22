import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'app/controller/invoice_controller.dart';

import 'app/view/Login/home.dart';
import 'app/view/Restrant_invoice/main_view.dart';
import 'locale/locale.dart';
import 'locale/locale_controller.dart';
import 'app/view/Invoice/main_view.dart';

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
    // Get.put(MainInvoiceController());
    return GetMaterialApp(
      home: Home(),
      //  const RestrantMainView(),
      // const Invoice(),
      locale: Get.deviceLocale,
      translations: AppLocale(),
      theme: ThemeData(
        fontFamily: GoogleFonts.cairo().fontFamily,
        scaffoldBackgroundColor: const Color(0xFFf5f7f9),
        cardColor: const Color.fromRGBO(0, 0, 0, 1),
        primaryColor: Colors.green,

        // work-----------------------
        dialogBackgroundColor: Colors.yellow,
        cardTheme: const CardTheme(
          color: Colors.white,
        ),

        //Work #text Filed &Form
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            gapPadding: 4,
            borderSide: BorderSide(width: 2, color: Colors.grey),
            borderRadius: BorderRadius.all(
              Radius.circular(
                4,
              ),
            ),
          ),
          focusColor: Color(0xFF00932a),
        ),
      ),

      debugShowCheckedModeBanner: false,
    );
  }
}
