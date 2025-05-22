import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../locale/locale_controller.dart';
import '../restrant_invoice/main_view.dart';

import '../Invoice/main_view.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    LocaleController localeController = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () {
                    Get.to(const RestrantMainView());
                  },
                  child: const Text(
                    'Restrant POS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () {
                    Get.to(const NormalInvoice());
                  },
                  child: const Text(
                    'Normal POS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    if (localeController.currentLanguage == "ar") {
                      localeController.changeLanguage("en");
                    } else {
                      localeController.changeLanguage("ar");
                    }
                  },
                  icon: const Icon(Icons.language),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
