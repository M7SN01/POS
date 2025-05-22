import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pos/app/controller/invoice_controller.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

Widget buildHeaderRow() {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Row(
      children: [
        Expanded(flex: 2, child: Center(child: Text('item'.tr, style: const TextStyle(fontWeight: FontWeight.bold)))),
        Expanded(flex: 1, child: Center(child: Text('price'.tr, style: const TextStyle(fontWeight: FontWeight.bold)))),
        Expanded(flex: 1, child: Center(child: Text('discount'.tr, style: const TextStyle(fontWeight: FontWeight.bold)))),
        Expanded(flex: 1, child: Center(child: Text('total_price'.tr, style: const TextStyle(fontWeight: FontWeight.bold)))),
        const Expanded(flex: 1, child: Center(child: Text('', style: TextStyle(fontWeight: FontWeight.bold)))),
      ],
    ),
  );
}

Widget buildCardRow(int index, String itemId, String item, String price, String qty, String discount, String total) {
  return GetBuilder<MainInvoiceController>(
    builder: (controller) => GestureDetector(
      onTap: () {
        if (!controller.enableKeyboardEditQty) {
          controller.lastClickedItemIndex = index;
          controller.update();
        }
      },
      child: Card(
        // surfaceTintColor: Colors.white,
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(4),
            ),
            border: Border.all(
              width: 2,
              color: controller.lastClickedItemIndex == index ? Colors.blue : Colors.transparent,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  //item name
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                          ),
                          Text(
                            " X $qty",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //price
                  Expanded(flex: 1, child: Center(child: Text(double.parse(price).toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)))),
/*
                  //quantity
                  Visibility(
                    visible: !controller.isRestPOS,
                    child: Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFe2ecff),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        // height: 80,
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: IconButton(
                                onPressed: () => /*controller.enableKeyboardEditQty ?*/ controller.incrementQty(itemId) /*: null*/,
                                icon: Icon(
                                  controller.enableKeyboardEditQty && controller.lastClickedItemIndex == index ? Icons.keyboard : Icons.add,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            // const SizedBox(width: 5),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  controller.qtyEditFild.clear();
                                  editQuantity(itemId: itemId);
                                },
                                child: Center(
                                  child: Text(
                                    qty,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // const SizedBox(width: 5),
                            Expanded(
                              flex: 2,
                              child: IconButton(
                                onPressed: () => /* controller.enableKeyboardEditQty ? */ controller.decermentQty(itemId) /* : null*/,
                                icon: Icon(
                                  controller.enableKeyboardEditQty && controller.lastClickedItemIndex == index ? Icons.keyboard : Icons.remove,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
*/
                  //discount
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFd3f9c9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          discount,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ),

                  //total
                  Expanded(flex: 1, child: Center(child: Text(double.parse(total).toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)))),

                  //remove item
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: IconButton(
                        onPressed: () => controller.onRemoveInvoiceItem(itemId),
                        icon: const Icon(Icons.clear, color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class RestrantInvoiceView extends StatelessWidget {
  const RestrantInvoiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildHeaderRow(),
        Expanded(
          child: GetBuilder<MainInvoiceController>(
            builder: (controller) {
              controller.itemScrollController = ItemScrollController(); // <-- create here
              return ScrollablePositionedList.builder(
                itemScrollController: controller.itemScrollController,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: controller.invoiceItems.length,
                itemBuilder: (context, index) {
                  // final item = _allItems[index];
                  return buildCardRow(
                    index,
                    controller.invoiceItems[index].id,
                    controller.invoiceItems[index].name,
                    controller.invoiceItems[index].price.toString(),
                    controller.invoiceItems[index].qty.toString(),
                    controller.invoiceItems[index].discount.toString(),
                    controller.invoiceItems[index].total.toString(),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
