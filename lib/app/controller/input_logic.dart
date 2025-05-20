import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'invoice_controller.dart';

class InputLogic extends MainInvoiceController {
  void barcodeScanner(String value) {
    // Check if the barcode exists in the allItems list
    if (super.allItems.any((element) => element.barcode == value)) {
      // If it exists, add it to the invoice items
      addInvoiceItem(super.allItems.firstWhere((element) => element.barcode == value));
    } else {
      print(value);
      Get.snackbar(
        "Error",
        "Barcode not found",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
    // Clear the search field and filtered items after selection
    super.barcodeFild.clear();
    super.barcodeFieldFocusNode.requestFocus();
    super.isListeningToScannerInput = true; // Enable listening
    update(); // Update the UI
  }

  // Update your _handleKeyPress to accept KeyEvent
  void handleBarcodeScanner(KeyEvent event) {
    // if (!isListeningToKeyBoardInput) return;

    // if (event is Key) {

    if (event.logicalKey == LogicalKeyboardKey.enter) {
      // isListeningToScannerInput = false;
      // barcodeFieldFocusNode.requestFocus()
      barcodeScanner(barcodeFild.text);
      // barcodeFild.clear();
      update();
    }
    // }
  }

// Update your _handleKeyPress to accept KeyEvent
  void handleKeyPress(KeyEvent event) {
    if (!isListeningToKeyBoardInput) return;

    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        qtyBuffer = "1"; // default value
        invoiceItems[lastClickedItemIndex!].qty = double.parse(qtyBuffer.replaceAll("Decimal", '.'));
        qtyBuffer = ""; // Reset the buffer for new input
        update();
      }

      final key = event.logicalKey.keyLabel.replaceAll('Numpad ', '');
      // print(key);
      if (key.isNotEmpty && (double.tryParse(key) != null || key == "Decimal")) {
        if (qtyBuffer.isEmpty && key == "0") {
          return;
        }
        qtyBuffer += key;
        if (invoiceItems.isNotEmpty) {
          invoiceItems[lastClickedItemIndex!].qty = double.parse(qtyBuffer.replaceAll("Decimal", '.'));
          // invoiceItems.last.qty = double.parse(qtyBuffer.replaceAll("Decimal", '.'));
        }
        update();
      } else if (key == "Enter") {
        isListeningToKeyBoardInput = false;
        // keyboardFocusNode.requestFocus();
        qtyBuffer = "";
        update();
      }
    }
  }
}
