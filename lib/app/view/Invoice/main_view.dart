import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'payment_view.dart';
import 'search_barcode_view.dart';
import '../../../widget/widgest.dart';
import '../../controller/invoice_controller.dart';
import 'invoice_items_view.dart';

class NormalInvoice extends StatelessWidget {
  const NormalInvoice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Point Of Sales"),
        centerTitle: true,
      ),
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
                  flex: 1,
                  child: cardView(
                    child: const SearchAndBarcode(),
                  ),
                ),

                const SizedBox(
                  width: 5,
                ),

                //center part
                Expanded(
                  flex: 3,
                  child: cardView(
                    child: Column(
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
