// import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../Services/ApiServices.dart';
import '../models/invoice_model.dart';
// import 'input_logic.dart';

class MainInvoiceController extends GetxController {
  final List<InvoiceItem> allItems = [];
  final List<InvoiceItem> invoiceItems = [];
  List<InvoiceItem> filteredItems = [];
  List<InvoiceItem> filteredItemsByClass = []; // Filtered items for the selected class
  List<Map<String, String>> classes = [];

  bool isClassGrid = true; // Flag to toggle between class grid and item grid
  String selectedClass = ""; // The selected class

  late bool Function(KeyEvent event) _hardwareKeyHandler;

  int? lastClickedItemIndex;

  TextEditingController searchFild = TextEditingController();
  TextEditingController barcodeFild = TextEditingController();
  final FocusNode keyboardFocusNode = FocusNode(); // FocusNode to listen to keyboard input
  final FocusNode searchFieldFocusNode = FocusNode(); // For the search field
  final FocusNode barcodeFieldFocusNode = FocusNode(); // For the barcode field
  String qtyBuffer = ""; // Buffer to store the digits for multi-digit input

  bool isListeningToScannerInput = true;
  bool isListeningToKeyBoardInput = false; // Flag to control whether to listen for input
  bool isListeningToNumpadInput = false;
  // late InputLogic inputLogic;

  bool enableKeyboardEditQty = false;

  ItemScrollController? itemScrollController;

  final TextEditingController qtyEditFild = TextEditingController();

  @override
  void onInit() {
    getdata(); // Fetch data from the server

    // inputLogic = InputLogic();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      barcodeFieldFocusNode.requestFocus();
    });
    print("is listening to Scanner ......................");

    // isListeningToKeyBoardInput = false;

    _hardwareKeyHandler = (event) {
      //Barcode filed has no focus && start listening
      if (!barcodeFieldFocusNode.hasFocus && isListeningToScannerInput) {
        print("is listening to Scanner ......................");
        handleBarcodeScanner(event);
        return true;
      } else if (!keyboardFocusNode.hasFocus && isListeningToNumpadInput) {
        //active when click Numpad Enter Key
        // keyboardFocusNode.requestFocus();
        print("is listening to Numpad ......................");
        handleNumpadInput(event);
        return true;
      }

      return false; // Let the event pass to the text field
    };
    HardwareKeyboard.instance.addHandler(_hardwareKeyHandler);
    super.onInit();
  }

  @override
  void onClose() {
    barcodeFieldFocusNode.dispose();
    searchFieldFocusNode.dispose();
    keyboardFocusNode.dispose();
    HardwareKeyboard.instance.removeHandler(_hardwareKeyHandler);
    super.onClose();
  }

  void barcodeScanner(String value) {
    // Check if the barcode exists in the allItems list
    if (allItems.any((element) => element.barcode == value)) {
      // If it exists, add it to the invoice items
      addInvoiceItem(allItems.firstWhere((element) => element.barcode == value));
    } else {
      Get.snackbar(
        "Error",
        "Barcode not found",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        maxWidth: Get.mediaQuery.size.width / 3,
        borderRadius: 4,
        margin: const EdgeInsets.only(top: 10),
      );
    }
    // Clear the search field and filtered items after selection
    barcodeFild.clear();
    barcodeFieldFocusNode.requestFocus();
    isListeningToScannerInput = true; // Enable listening
    update(); // Update the UI
  }

  // Update your _handleKeyPress to accept KeyEvent
  void handleBarcodeScanner(KeyEvent event) {
    // if (!isListeningToKeyBoardInput) return;
    // if (event is KeyDownEvent) {
    //   print("Key Down ---------------------------------- ");
    // }
    // if (event is KeyUpEvent) {
    //   print("Key Up Event  : ${event.logicalKey}");
    // } else if (event is KeyDownEvent) {
    //   print("Key Down Event  : ${event.logicalKey}");
    // }

    // print("""logic Key : ${event.logicalKey}  ,\n
    //  Character : ${event.character}  ,\n
    //  physicalKey :  ${event.physicalKey} , \n
    //  synthesized : ${event.synthesized}""");
    print(event.logicalKey);
    print(event.physicalKey);
    // move focus to numpod numbers to edit the Qty
    if (/*(*/ event.physicalKey.debugName == "Numpad Enter" /*|| event.physicalKey.debugName == "Arrow Right")*/ && barcodeFild.text.isEmpty) {
      print("Move Focus To Numpad #########################");
      isListeningToScannerInput = false;
      isListeningToNumpadInput = true;
      barcodeFieldFocusNode.requestFocus();
      //disable add and Subtract screen buttons
      enableKeyboardEditQty = true;

      update();
    }
    //keep focus on Barcode input
    else if (event.logicalKey == LogicalKeyboardKey.enter) {
      barcodeScanner(barcodeFild.text);
    }
  }

  void handleNumpadInput(KeyEvent event) {
    if (lastClickedItemIndex != null) {
      if (event is KeyDownEvent) {
        // print("Key Down ---------------------------------- ");
        if (event.logicalKey == LogicalKeyboardKey.backspace) {
          // qtyBuffer = "1"; // default value  0 and reomve the item if qty still 0 when close editing qty
          invoiceItems[lastClickedItemIndex!].qty = 0;
          qtyBuffer = ""; // Reset the buffer for new input
          update();
        }

        //Only handle with Numpad keys
        // print(event.logicalKey.keyLabel);
        // if (event.logicalKey.keyLabel.contains('Numpad ') || event.logicalKey == LogicalKeyboardKey.numpadEnter) {
        final key = event.logicalKey.keyLabel.replaceAll('Numpad ', '');
        print(key);
        // Number  or  . where there is no . before
        if (double.tryParse(key) != null || (key == "Decimal" && !qtyBuffer.contains('.'))) {
          if (qtyBuffer.isEmpty && (key == "0" || key == "Decimal")) {
            qtyBuffer += "0.";
            invoiceItems[lastClickedItemIndex!].qty = 0;
            update(); // update before return
            return;
          }
          qtyBuffer += key;
          // print(qtyBuffer);
          if (invoiceItems.isNotEmpty) {
            invoiceItems[lastClickedItemIndex!].qty = double.parse(qtyBuffer.replaceAll("Decimal", '.'));
            update();
          }
        } else if (key == "Add") {
          incrementQty(invoiceItems[lastClickedItemIndex!].id);
        } else if (key == "Subtract") {
          decermentQty(invoiceItems[lastClickedItemIndex!].id);
        }
        //Focus Back To Barcode Input
        else if (key == "Enter") {
          print("Focus Back To Barcode Input #########################");
          if (invoiceItems[lastClickedItemIndex!].qty == 0) {
            onRemoveInvoiceItem(invoiceItems[lastClickedItemIndex!].id);
          }
          isListeningToScannerInput = true;
          isListeningToNumpadInput = false;

          //enable add and Subtract screen buttons
          enableKeyboardEditQty = false;

          qtyBuffer = "";
        }
        // }
        update();
      }
    }
  }

// Update your _handleKeyPress to accept KeyEvent
  void handleKeyPress(KeyEvent event) {
    // if (!isListeningToKeyBoardInput) return;

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
        // isListeningToKeyBoardInput = false;
        // keyboardFocusNode.requestFocus();
        qtyBuffer = "";
        update();
      }
    }
  }

  void filterSearch(String query) {
    if (query.isEmpty) {
      filteredItems = [];
      //    update(); // Update the UI
    } else {
      final results = allItems.where((item) => item.name.toLowerCase().contains(query.toLowerCase())).toList();
      filteredItems = results;
      //   update(); // Update the UI
    }
    update(); // Update the UI
  }

  void addInvoiceItem(InvoiceItem item) {
    // Check if the item already exists in the invoice
    if (invoiceItems.any((element) => element.id == item.id)) {
      // If the item already exists in the invoice, just update the quantity

      invoiceItems.firstWhere((element) => element.id == item.id).qty++;

      //  update(); // Update the UI
    } else {
      // If the item doesn't exist, add it to the invoice
      item.qty = 1; // Set the initial quantity to 1
      invoiceItems.add(item);
    }

    lastClickedItemIndex = invoiceItems.indexWhere((element) => element.id == item.id); // Store the last clicked item ID

    if (invoiceItems.length > 5) {
      // To scroll:
      itemScrollController!.scrollTo(
        index: lastClickedItemIndex!,
        duration: const Duration(milliseconds: 300),
      );
    }
    // Clear the search field and filtered items after selection
    searchFild.clear();
    filteredItems.clear();
    qtyBuffer = ""; // Reset the buffer for new input
    barcodeFieldFocusNode.requestFocus();
    // isListeningToKeyBoardInput = true; // Enable listening
    update(); // Update the UI
  }

  void onRemoveInvoiceItem(String itemId) {
    // if (lastClickedItemIndex != null) {
    invoiceItems.firstWhere((element) => element.id == itemId).qty = 0; // Reset the quantity to 0
    //  [index].qty = 0;
    invoiceItems.removeWhere((element) => element.id == itemId); // Remove the item from the invoice
    lastClickedItemIndex = null; // Clear the last clicked item ID
    isListeningToNumpadInput = false;
    isListeningToScannerInput = true;
    enableKeyboardEditQty = false;

    barcodeFieldFocusNode.requestFocus();
    update(); // Update the UI
    // }
  }

  void incrementQty(String itemId) {
    // if (lastClickedItemIndex != null) {
    // print("incremented qty of: ${invoiceItems.firstWhere((element) => element.id == itemId).qty}  ==> + ${invoiceItems.firstWhere((element) => element.id == itemId).qty}");
    int itemIndex = invoiceItems.indexWhere((element) => element.id == itemId);
    // Increment the quantity of the item at the specified index
    invoiceItems[itemIndex].qty++; // Increment the quantity
    // isListeningToKeyBoardInput = true; // Enable listening for input
    // keyboardFocusNode.requestFocus();
    lastClickedItemIndex = itemIndex; // Store the last clicked item ID

    update(); // Update the UI
    // }
  }

  void decermentQty(String itemId) {
    // print("decerment qty of: ${invoiceItems.firstWhere((element) => element.id == itemId).qty} ==> - ${invoiceItems.firstWhere((element) => element.id == itemId).qty}");
    int itemIndex = invoiceItems.indexWhere((element) => element.id == itemId);
    // Decrement the quantity of the item at the specified index
    if (invoiceItems[itemIndex].qty > 1) {
      invoiceItems[itemIndex].qty--;
      // isListeningToKeyBoardInput = true; // Enable listening for input
      // keyboardFocusNode.requestFocus();
      lastClickedItemIndex = itemIndex; // Store the last clicked item ID
    } else {
      // invoiceItems.removeAt(itemIndex); // Remove the item if quantity is 0
      onRemoveInvoiceItem(itemId);
    }

    update(); // Update the UI
  }

  void onBackButtonPressed() {
    isClassGrid = true; // Switch back to the class grid
    selectedClass = ""; // Clear the selected class
    filteredItemsByClass = []; // Clear the filtered items
    update(); // Update the UI
  }

  void onClassSelected({required String className, required String classId}) {
    // Filter items based on the selected class
    filteredItemsByClass = allItems.where((item) => item.calss_1 == classId).toList();
    isClassGrid = false; // Switch to item grid
    selectedClass = className; // Set the selected class
    update(); // Update the UI
  }

  sumOfSubtotal(List<InvoiceItem> invoiceItems) => double.parse(invoiceItems.fold(0.0, (sum, item) => sum + (item.price * item.qty)).toStringAsFixed(2));
  sumOfDiscount(List<InvoiceItem> invoiceItems) => double.parse(invoiceItems.fold(0.0, (sum, item) => sum + (item.discount)).toStringAsFixed(2));
  sumPriceAfterDiscount(List<InvoiceItem> invoiceItems) => double.parse(invoiceItems.fold(0.0, (sum, item) => sum + ((item.price * item.qty) - item.discount)).toStringAsFixed(2));
  sumOfTax(List<InvoiceItem> invoiceItems) => double.parse(invoiceItems.fold(0.0, (sum, item) => sum + (((item.price * item.qty) - item.discount) * 0.15)).toStringAsFixed(2));
  sumPriceAfterTax(List<InvoiceItem> invoiceItems) => double.parse(invoiceItems.fold(0.0, (sum, item) => sum + ((item.price * item.qty - item.discount) * 1.15)).toStringAsFixed(2));

  //must moved to other class for database
  Future<void> getdata() async {
    // Fetch data from the server
    // var data = await Services().createRep(sqlStatment: "select * from items");
    // print(data);
    var respon = await Services().createRep(sqlStatment: "select ITEM_ID,BARCODE ,ITEM_NAME,round(PRICE1,2) as PRICE, CL_1 from items  ");
    // print("select ITEM_ID,BARCODE ,ITEM_NAME,round(PRICE1,2) as PRICE, CL_1 from items  where barcode='887276429595'");
    allItems.clear(); // Clear the existing items

    //initialize the image directories
    final dir = Directory(r"D:\image\food-101\images\bibimbap");
    final files = dir.listSync().where((f) => f is File && (f.path.endsWith('.jpg') || f.path.endsWith('.png') || f.path.endsWith('.jpeg'))).toList();

    int i = 0;
    for (var element in respon) {
      i++;
      allItems.add(
        InvoiceItem(
          id: element['ITEM_ID'],
          barcode: element['BARCODE'],
          name: element['ITEM_NAME'],
          price: element['PRICE'] ?? 0.0,
          calss_1: element['CL_1'] ?? "",
          discount: 0.0,
          imageUrl: files[i].path,
          qty: 0,
        ),
      );
    }

    respon = await Services().createRep(sqlStatment: """SELECT bb.cl_1,bb.name FROM ITEMS_CLASS bb WHERE bb.CL_all in
      (select CL_1  from items aa where aa.CL_1 IS NOT NULL group by aa.CL_1) """);
    classes.clear(); // Clear the existing classes
    for (var element in respon) {
      classes.add({"Cl_1": element['CL_1'], "NAME": element['NAME']});
    }

    update(); // Update the UI
  }
}
