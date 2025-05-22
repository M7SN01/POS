import 'package:flutter/material.dart';
// import 'package:get/get.dart';

TextEditingController textFild = TextEditingController();

class EditNumberView extends StatelessWidget {
  final Widget child;
  final String itemName;
  final double currentQty;
  final Function(String)? onEnterCallback;

  const EditNumberView({super.key, required this.child, required this.itemName, required this.currentQty, required this.onEnterCallback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            useSafeArea: true,
            // barrierDismissible: false, //dont close if click out dialog

            builder: (context) {
              textFild.text = currentQty.toStringAsFixed(2);
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Change this value for your desired radius
                ),
                // surfaceTintColor:const Color(0xFFf5f7f9),
                // clipBehavior: Clip.none,
                title: SizedBox(
                  width: 200,
                  child: Center(
                    child: Text(
                      itemName,
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
                              controller: textFild,
                              readOnly: true,
                              textAlign: TextAlign.center,
                              textAlignVertical: const TextAlignVertical(y: -0.8),
                              // decoration: const InputDecoration(
                              //   border: OutlineInputBorder(
                              //     gapPadding: 4,
                              //     borderSide: BorderSide(width: 2, color: Colors.grey),
                              //     borderRadius: BorderRadius.all(
                              //       Radius.circular(
                              //         4,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              //    onChanged: controller.filterSearch,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          numCard(keyValue: "1"),
                          numCard(keyValue: "2"),
                          numCard(keyValue: "3"),
                          numCard(keyValue: "-"),
                        ],
                      ),
                      Row(
                        children: [
                          numCard(keyValue: "4"),
                          numCard(keyValue: "5"),
                          numCard(keyValue: "6"),
                          numCard(keyValue: "+"),
                        ],
                      ),
                      Row(
                        children: [
                          numCard(keyValue: "7"),
                          numCard(keyValue: "8"),
                          numCard(keyValue: "9"),
                          numCard(keyValue: ""),
                        ],
                      ),
                      Row(
                        children: [
                          numCard(keyValue: "0"),
                          numCard(keyValue: "."),
                          numCard(keyValue: "Enter", onEnter: onEnterCallback),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).then((value) {
          textFild.text = "";
          print(value);
        });
      },
      child: child,
    );
  }
}

//very slow    very bad
/*
editQuantity({title, onEnter}) {
  Get.dialog(
    useSafeArea: true,
    barrierDismissible: true,
    AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Change this value for your desired radius
      ),
      surfaceTintColor: const Color(0xFFf5f7f9),
      // clipBehavior: Clip.none,
      title: SizedBox(
        width: 200,
        child: Center(
          child: Text(
            title,
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
                    controller: textFild,
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
                numCard(keyValue: "1"),
                numCard(keyValue: "2"),
                numCard(keyValue: "3"),
                numCard(keyValue: "-"),
              ],
            ),
            Row(
              children: [
                numCard(keyValue: "4"),
                numCard(keyValue: "5"),
                numCard(keyValue: "6"),
                numCard(keyValue: "+"),
              ],
            ),
            Row(
              children: [
                numCard(keyValue: "7"),
                numCard(keyValue: "8"),
                numCard(keyValue: "9"),
                numCard(keyValue: ""),
              ],
            ),
            Row(
              children: [
                numCard(keyValue: "0"),
                numCard(keyValue: "."),
                numCard(keyValue: "Enter", onEnter: onEnter),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
*/
Widget numCard({
  // required controller,
  required String keyValue,
  Function(String)? onEnter,
}) {
  return Expanded(
    flex: keyValue == "Enter" ? 2 : 1,
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
            if (keyValue == "Enter") {
              // Save the value and close the dialog

              if (onEnter != null && textFild.text != "" && textFild.text != "." && double.parse(textFild.text) != 0) {
                onEnter(textFild.text);
              }
              // textFild.text = "";
            } else {
              String text = textFild.text;
              if (keyValue == "") {
                // Backspace
                if (text.isNotEmpty) {
                  textFild.text = text.substring(0, text.length - 1);
                }
              } else if (keyValue == ".") {
                if (!text.contains(".")) {
                  textFild.text += keyValue;
                }
              } else if (keyValue == "+" || keyValue == "-") {
                double? qty = double.tryParse(text);
                if (qty != null) {
                  if (keyValue == "+" && qty < 9999) {
                    qty++;
                  } else if (keyValue == "-") {
                    qty--;
                    if (qty < 1) {
                      qty = 0;
                    }
                  }
                  textFild.text = qty.toString();
                }
              } else if (textFild.text.length < 4) {
                //allow  0.25 maxmum
                // Append keyValueber
                textFild.text += keyValue;
              }
            }
          },
          child: keyValue != "" ? Text(keyValue) : const Icon(Icons.backspace),
        ),
      ),
    ),
  );
}
