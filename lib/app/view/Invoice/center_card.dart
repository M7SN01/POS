import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../controller/invoice_controller.dart';
import '../../locale/locale_controller.dart';

Widget buildHeaderRow() {
  LocaleController localeController = Get.find();
  return GetBuilder<MainInvoiceController>(builder: (controller) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Stack(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (localeController.currentLanguage == "ar") {
                    localeController.changeLanguage("en");
                  } else {
                    localeController.changeLanguage("ar");
                  }
                },
                icon: const Icon(Icons.language),
              ),
              Checkbox(
                value: controller.isRestPOS,
                onChanged: (value) => controller.changeRestPOS(),
              )
            ],
          ),
          Row(
            children: [
              Expanded(flex: 2, child: Center(child: Text('item'.tr, style: const TextStyle(fontWeight: FontWeight.bold)))),
              Expanded(flex: 1, child: Center(child: Text('price'.tr, style: const TextStyle(fontWeight: FontWeight.bold)))),
              Visibility(visible: !controller.isRestPOS, child: Expanded(flex: 2, child: Center(child: Text('quantity'.tr, style: const TextStyle(fontWeight: FontWeight.bold))))),
              Expanded(flex: 1, child: Center(child: Text('discount'.tr, style: const TextStyle(fontWeight: FontWeight.bold)))),
              Expanded(flex: 1, child: Center(child: Text('total_price'.tr, style: const TextStyle(fontWeight: FontWeight.bold)))),
              const Expanded(flex: 1, child: Center(child: Text('', style: TextStyle(fontWeight: FontWeight.bold)))),
            ],
          ),
        ],
      ),
    );
  });
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                          ),
                          Text(
                            controller.isRestPOS ? " X $qty" : "",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //price
                  Expanded(flex: 1, child: Center(child: Text(double.parse(price).toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)))),

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
                        icon: const Icon(Icons.delete, color: Colors.red),
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

Widget buildClassGrid() {
  return GetBuilder<MainInvoiceController>(
    builder: (controller) => GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // Number of columns
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: controller.classes.length,
      itemBuilder: (context, index) {
        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          elevation: 2,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            splashColor: Colors.blue.withOpacity(0.2),
            onTap: () => controller.onClassSelected(classId: controller.classes[index]['Cl_1'] ?? "", className: controller.classes[index]['NAME'] ?? ""), // Add item to the invoice on tap
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.fastfood, // Replace with an appropriate icon
                  size: 40,
                  color: Colors.orange,
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    controller.classes[index]['NAME'] ?? "",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

// File getRandomImageFromFolder() {
//   final dir = Directory(r"D:\image\food-101\images\bibimbap");
//   final files = dir.listSync().where((f) => f is File && (f.path.endsWith('.jpg') || f.path.endsWith('.png') || f.path.endsWith('.jpeg'))).toList();
//   // if (files.isEmpty) return null;
//   final random = Random();
//   return files[random.nextInt(files.length)] as File;
// }

Widget buildItemGrid() {
  return GetBuilder<MainInvoiceController>(
    builder: (controller) => Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          controller.selectedClass,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: null,
        backgroundColor: Colors.transparent,
      ),
      body: controller.filteredItemsByClass.isNotEmpty
          ? GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Number of columns
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1, //3/4
              ),
              itemCount: controller.filteredItemsByClass.length + 1, // Add 1 for the back button
              itemBuilder: (context, index) {
                final item = controller.filteredItemsByClass[index > 0 ? index - 1 : 0]; // Get the item or the back button
                // print(filteredItemsByClass.length);
                return Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  elevation: 2,
                  child:
                      // If it's the first item, show a back button
                      index == 0
                          ? InkWell(
                              borderRadius: BorderRadius.circular(8),
                              splashColor: Colors.blue.withOpacity(0.2),
                              onTap: () => controller.onBackButtonPressed(), // Add item to the invoice on tap
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      "back".tr,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : InkWell(
                              borderRadius: BorderRadius.circular(8),
                              splashColor: Colors.blue.withOpacity(0.2),
                              onTap: () => controller.addInvoiceItem(item), // Add item to the invoice on tap
                              child: Stack(
                                children: [
                                  Container(
                                    // height: 400,
                                    // width: 400,
                                    // margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey, width: 0.5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          item.imageUrl == null
                                              ? const Icon(
                                                  Icons.fastfood,
                                                  size: 40,
                                                  color: Colors.orange,
                                                )
                                              : Image.file(
                                                  File(item.imageUrl ?? ""),
                                                  fit: BoxFit.fill,
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                            //  Icon(
                                            //   Icons.fastfood, // Replace with an appropriate icon
                                            //   size: 40,
                                            //   color: Colors.orange,
                                            ),
                                      ),
                                      // const SizedBox(height: 80),
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(0.8),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    item.name,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      controller.invoiceItems.any((element) {
                                        if (element.id == item.id) {
                                          // print("element['id']  ${element['id']}");
                                          // print("item ['id']  ${item['id']}");
                                          return true;
                                        } else {
                                          // print("not in the invoice");
                                          return false;
                                        }
                                      })
                                          ? Expanded(
                                              flex: 1,
                                              child: GestureDetector(
                                                onTap: () {},
                                                child: Container(
                                                  // margin: const EdgeInsets.only(top: 5),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFf5f7f9),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Row(
                                                    // mainAxisAlignment: MainAxisAlignment.center,
                                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: IconButton(
                                                          padding: const EdgeInsets.all(5),
                                                          onPressed: () => controller.incrementQty(item.id),
                                                          icon: const Icon(
                                                            Icons.add,
                                                            color: Colors.blue,
                                                          ),
                                                        ),
                                                      ),
                                                      // const SizedBox(width: 5),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Center(
                                                          child: Text(
                                                            controller.invoiceItems.firstWhere((element) => element.id == item.id).qty.toString(),
                                                            style: const TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontStyle: FontStyle.italic,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      // const SizedBox(width: 5),
                                                      Expanded(
                                                        flex: 2,
                                                        child: IconButton(
                                                          padding: const EdgeInsets.all(5),
                                                          onPressed: () => controller.decermentQty(item.id),
                                                          icon: const Icon(
                                                            Icons.remove,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                );
              },
            )
          // If there are no items
          : Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              elevation: 2,
              child:
                  // If it's the first item, show a back button
                  InkWell(
                borderRadius: BorderRadius.circular(12),
                splashColor: Colors.blue.withOpacity(0.2),
                onTap: () => controller.onBackButtonPressed(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "back".tr,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
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

class RestCenterCard extends StatelessWidget {
  const RestCenterCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainInvoiceController>(
      builder: (controller) {
        return controller.isClassGrid ? buildClassGrid() : buildItemGrid();
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
                  numCard(controller: controller, num: "1", item_id: itemId),
                  numCard(controller: controller, num: "2", item_id: itemId),
                  numCard(controller: controller, num: "3", item_id: itemId),
                  numCard(controller: controller, num: "-", item_id: itemId),
                ],
              ),
              Row(
                children: [
                  numCard(controller: controller, num: "4", item_id: itemId),
                  numCard(controller: controller, num: "5", item_id: itemId),
                  numCard(controller: controller, num: "6", item_id: itemId),
                  numCard(controller: controller, num: "+", item_id: itemId),
                ],
              ),
              Row(
                children: [
                  numCard(controller: controller, num: "7", item_id: itemId),
                  numCard(controller: controller, num: "8", item_id: itemId),
                  numCard(controller: controller, num: "9", item_id: itemId),
                  numCard(controller: controller, num: "", item_id: itemId),
                ],
              ),
              Row(
                children: [
                  numCard(controller: controller, num: "0", item_id: itemId),
                  numCard(controller: controller, num: ".", item_id: itemId),
                  numCard(controller: controller, num: "Enter", item_id: itemId),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget numCard({required MainInvoiceController controller, required String num, required String item_id}) {
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
              controller.invoiceItems.firstWhere((element) => element.id == item_id).qty = double.parse(controller.qtyEditFild.text);
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
