import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/app/Widgets/edit_quantity_view.dart';
import 'package:pos/app/controller/invoice_controller.dart';

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
        leading: const SizedBox(),
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
                  // color: Colors.white,
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
                                                      child: EditNumberView(
                                                        itemName: controller.invoiceItems.firstWhere((element) => element.id == item.id).name.toString(),
                                                        currentQty: controller.invoiceItems.firstWhere((element) => element.id == item.id).qty,
                                                        onEnterCallback: (result) {
                                                          if (result == "") {
                                                            Navigator.pop(context);
                                                            return;
                                                          }
                                                          controller.invoiceItems.firstWhere((element) => element.id == item.id).qty = double.parse(result);
                                                          controller.update();
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text(
                                                          controller.invoiceItems.firstWhere((element) => element.id == item.id).qty.toString(),
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontStyle: FontStyle.italic,
                                                          ),
                                                          textAlign: TextAlign.center,
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

class RestrantItemsGridView extends StatelessWidget {
  const RestrantItemsGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainInvoiceController>(
      builder: (controller) {
        return controller.isClassGrid ? buildClassGrid() : buildItemGrid();
      },
    );
  }
}
