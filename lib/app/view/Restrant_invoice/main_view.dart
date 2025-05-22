import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/view/Restrant_invoice/invoice_items_view.dart';
import 'items_grid_view.dart';
import 'payment_view.dart';
import '../../../widget/widgest.dart';
import '../../controller/invoice_controller.dart';

class RestrantMainView extends StatelessWidget {
  const RestrantMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restrant POS"),
        centerTitle: true,
        // leading: null,
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
                  flex: 2,
                  child: cardView(
                    child: const RestrantInvoiceView(),
                  ),
                ),

                const SizedBox(
                  width: 5,
                ),

                //center part
                Expanded(
                  flex: 2,
                  child: cardView(child: const RestrantItemsGridView()),
                ),

                const SizedBox(
                  width: 5,
                ),

                Expanded(
                  flex: 1,
                  child: cardView(paddding: 0, child: const RestrantPaymentView()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
