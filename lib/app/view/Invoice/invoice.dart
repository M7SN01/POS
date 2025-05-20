import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'totals_card.dart';
import 'search_barcode_card.dart';
import '../../../widget/widgest.dart';
import '../../controller/invoice_controller.dart';
import 'center_card.dart';

class Invoice extends StatelessWidget {
  const Invoice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<MainInvoiceController>(
        init: MainInvoiceController(),
        builder: (controller) {
          // controller.setContext(context);
          return Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                //right part
                Expanded(
                  flex: controller.isRestPOS ? 2 : 1,
                  child: cardView(
                    child: controller.isRestPOS ? const RestRight() : const SearchAndBarcode(),
                  ),
                ),

                const SizedBox(
                  width: 5,
                ),

                //center part
                Expanded(
                  flex: controller.isRestPOS ? 2 : 3,
                  child: cardView(
                    child: controller.isRestPOS
                        ? const RestCenterCard()
                        : Column(
                            children: [
                              buildHeaderRow(),
                              const Expanded(
                                flex: 1,
                                child: SizedBox(
                                  height: 1,
                                  child: CenterCard(),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(
                  width: 5,
                ),

                Expanded(
                  flex: 1,
                  child: cardView(paddding: 0, child: const LeftCard()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
