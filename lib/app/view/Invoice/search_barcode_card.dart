import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/invoice_controller.dart';
import 'center_card.dart';
import '../../../widget/widgest.dart';

class SearchAndBarcode extends StatelessWidget {
  const SearchAndBarcode({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainInvoiceController>(builder: (controller) {
      return Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // barcode field
              Visibility(
                visible: true,
                child: TextField(
                  focusNode: controller.barcodeFieldFocusNode,
                  controller: controller.barcodeFild,
                  // onChanged: (value) => controller.barcodeScanner(value),
                  decoration: InputDecoration(
                    labelText: "barcode".tr,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    suffixIcon: const Icon(Icons.barcode_reader),
                    border: const OutlineInputBorder(
                      gapPadding: 4,
                      borderSide: BorderSide(
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),

              //Search Filed
              Container(
                height: 40,
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 45,
                  child: TextFormField(
                    focusNode: controller.searchFieldFocusNode,
                    controller: controller.searchFild,
                    textAlignVertical: const TextAlignVertical(y: -0.8),
                    decoration: InputDecoration(
                      labelText: "search".tr,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      suffixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(gapPadding: 4, borderSide: BorderSide.none),
                    ),
                    onChanged: controller.filterSearch,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              //
              Text(
                "vaforite".tr,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.solid,
                  decorationThickness: 1,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: controller.allItems.length,
                  itemBuilder: (context, index) {
                    final item = controller.allItems[index];
                    return ListTile(
                      // iconColor: Colors.yellow,
                      title: Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(child: Text(item.name)),
                        ],
                      ),
                      onTap: () => controller.addInvoiceItem(item),
                    );
                  },
                ),
              ),
              const DashedLine(
                height: 1,
                color: Colors.black26,
                dashWidth: 6,
                dashSpace: 4,
              ),
              const SizedBox(height: 8),
              //
              Text(
                "morest_sale".tr,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.solid,
                  decorationThickness: 1,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: controller.allItems.length,
                  itemBuilder: (context, index) {
                    final item = controller.allItems[index];
                    return ListTile(
                      // iconColor: Colors.yellow,
                      title: Row(
                        children: [
                          const Icon(
                            Icons.tag,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(child: Text(item.name)),
                        ],
                      ),
                      onTap: () => controller.addInvoiceItem(item),
                    );
                  },
                ),
              ),
              const DashedLine(
                height: 1,
                color: Colors.black26,
                dashWidth: 6,
                dashSpace: 4,
              ),
            ],
          ),
          //search  drop list
          if (controller.filteredItems.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.filteredItems.length,
                itemBuilder: (context, index) {
                  final item = controller.filteredItems[index];
                  return ListTile(
                    title: Text(item.name),
                    onTap: () => controller.addInvoiceItem(item),
                  );
                },
              ),
            ),
        ],
      );
    });
  }
}

class RestRight extends StatelessWidget {
  const RestRight({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildHeaderRow(),
        const Expanded(child: CenterCard()),
      ],
    );
  }
}
