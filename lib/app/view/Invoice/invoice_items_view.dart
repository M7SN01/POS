import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../controller/invoice_controller.dart';

Widget buildHeaderRow() {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Row(
      children: [
        Expanded(flex: 2, child: Center(child: Text('item'.tr, style: const TextStyle(fontWeight: FontWeight.bold)))),
        Expanded(flex: 1, child: Center(child: Text('price'.tr, style: const TextStyle(fontWeight: FontWeight.bold)))),
        Expanded(flex: 2, child: Center(child: Text('quantity'.tr, style: const TextStyle(fontWeight: FontWeight.bold)))),
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
        surfaceTintColor: Colors.white,
        elevation: 2,
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
                      child: Text(
                        item,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),

                  //price
                  Expanded(flex: 1, child: Center(child: Text(double.parse(price).toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)))),

                  //quantity
                  Expanded(
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

class CenterCard extends StatelessWidget {
  const CenterCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainInvoiceController>(
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
    );
  }
}

editQuantity({itemId}) {
  Get.dialog(
    useSafeArea: true,
    barrierDismissible: true,
    GetBuilder<MainInvoiceController>(
      builder: (controller) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Change this value for your desired radius
        ),
        surfaceTintColor: const Color(0xFFf5f7f9),
        // clipBehavior: Clip.none,
        title: SizedBox(
          width: 200,
          child: Center(
            child: Text(
              controller.invoiceItems.firstWhere((element) => element.id == itemId).name,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        titlePadding: const EdgeInsets.all(10),
        contentPadding: const EdgeInsets.all(10),
        content: SizedBox(
          height: 350,
          child: Column(
            children: [
              //Filed
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.qtyEditFild,
                      readOnly: true,
                      textAlign: TextAlign.center,
                      textAlignVertical: const TextAlignVertical(y: -0.8),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          gapPadding: 4,
                          borderSide: BorderSide(width: 2, color: Colors.grey),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              4,
                            ),
                          ),
                        ),
                      ),
                      //    onChanged: controller.filterSearch,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  numCard(controller: controller, num: "1", itemId: itemId),
                  numCard(controller: controller, num: "2", itemId: itemId),
                  numCard(controller: controller, num: "3", itemId: itemId),
                  numCard(controller: controller, num: "-", itemId: itemId),
                ],
              ),
              Row(
                children: [
                  numCard(controller: controller, num: "4", itemId: itemId),
                  numCard(controller: controller, num: "5", itemId: itemId),
                  numCard(controller: controller, num: "6", itemId: itemId),
                  numCard(controller: controller, num: "+", itemId: itemId),
                ],
              ),
              Row(
                children: [
                  numCard(controller: controller, num: "7", itemId: itemId),
                  numCard(controller: controller, num: "8", itemId: itemId),
                  numCard(controller: controller, num: "9", itemId: itemId),
                  numCard(controller: controller, num: "", itemId: itemId),
                ],
              ),
              Row(
                children: [
                  numCard(controller: controller, num: "0", itemId: itemId),
                  numCard(controller: controller, num: ".", itemId: itemId),
                  numCard(controller: controller, num: "Enter", itemId: itemId),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget numCard({required MainInvoiceController controller, required String num, required String itemId}) {
  return Expanded(
    flex: num == "Enter" ? 2 : 1,
    child: Card(
      // surfaceTintColor: const Color(0xFFf5f7f9),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: SizedBox(
        height: 60,
        // width: 60,
        child: TextButton(
          style: TextButton.styleFrom(
            // padding: const EdgeInsets.symmetric(vertical: 30),
            // backgroundColor: Color(0xFFf5f7f9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            if (num == "Enter") {
              // Save the value and close the dialog
              // Example: update the invoice item qty here
              controller.invoiceItems.firstWhere((element) => element.id == itemId).qty = double.parse(controller.qtyEditFild.text);
              controller.update();

              Get.back();
              return;
            }

            String text = controller.qtyEditFild.text;
            if (num == "") {
              // Backspace
              if (text.isNotEmpty) {
                controller.qtyEditFild.text = text.substring(0, text.length - 1);
              }
            } else if (num == ".") {
              if (!text.contains(".")) {
                controller.qtyEditFild.text += num;
              }
            } else if (num == "+" || num == "-") {
              double? qty = double.tryParse(text);
              if (qty != null) {
                if (num == "+" && qty < 9999) {
                  qty++;
                } else if (num == "-" && qty > 1) {
                  qty--;
                }
                controller.qtyEditFild.text = qty.toString();
              }
            } else {
              // Append number
              controller.qtyEditFild.text += num;
            }

            controller.update();
          },
          child: num != "" ? Text(num) : const Icon(Icons.backspace),
        ),
      ),
    ),
  );
}
