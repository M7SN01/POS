// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:pos/widget/widgest.dart';

// import '../Services/ApiServices.dart';

// class MainInvoice extends StatefulWidget {
//   const MainInvoice({super.key});

//   @override
//   State<MainInvoice> createState() => _MainInvoiceState();
// }

// class _MainInvoiceState extends State<MainInvoice> {
//   TextEditingController searchFild = TextEditingController();
//   final List<Map<String, dynamic>> _invoiceItems = [];
//   List<Map<String, dynamic>> _filteredItems = [];

//   ///
//   final FocusNode _keyboardFocusNode = FocusNode(); // FocusNode to listen to keyboard input
//   @override
//   void initState() {
//     super.initState();
//     getdata(); // Fetch data from the server
//     // Attach a listener to the focus node to listen for keyboard input
//     _keyboardFocusNode.requestFocus();
//     RawKeyboard.instance.addListener(_handleKeyPress);
//   }

//   getdata() async {
//     // Fetch data from the server
//     // var data = await Services().createRep(sqlStatment: "select * from items");
//     // print(data);
//     var respon = await Services().createRep(sqlStatment: "select ITEM_ID,ITEM_NAME,round(PRICE1,2) as PRICE, CL_1 from items ");
//     // print(respon[0]['ITEM_ID']);
//     _allItems.clear(); // Clear the existing items
//     for (var element in respon) {
//       _allItems.add({
//         'id': element['ITEM_ID'],
//         'name': element['ITEM_NAME'],
//         'price': element['PRICE'],
//         'class': element['CL_1'],
//         'discount': 0.0,
//       });
//     }

//     respon = await Services().createRep(sqlStatment: """SELECT bb.cl_1,bb.name FROM ITEMS_CLASS bb WHERE bb.CL_all in
//       (select CL_1  from items aa where aa.CL_1 IS NOT NULL group by aa.CL_1) """);
//     classes.clear(); // Clear the existing classes
//     for (var element in respon) {
//       classes.add({"Cl_1": element['CL_1'], "NAME": element['NAME']});
//     }
//   }

//   @override
//   void dispose() {
//     // Clean up the focus node and keyboard listener
//     _keyboardFocusNode.dispose();
//     RawKeyboard.instance.removeListener(_handleKeyPress);
//     super.dispose();
//   }

//   String _qtyBuffer = ""; // Buffer to store the digits for multi-digit input
//   bool _isListening = true; // Flag to control whether to listen for input

//   void _handleKeyPress(RawKeyEvent event) {
//     if (!_isListening) return; // Stop processing input if not listening

//     if (event is RawKeyDownEvent) {
//       final key = event.logicalKey.keyLabel.replaceAll('Numpad ', ''); // Get the pressed key
//       print(key); // Debugging: Print the key pressed
//       if (key.isNotEmpty && (double.tryParse(key) != null || key == "Decimal")) {
//         // If the key is a number, append it to the buffer
//         setState(() {
//           _qtyBuffer += key; // Append the digit to the buffer
//           if (_invoiceItems.isNotEmpty) {
//             _invoiceItems.last['qty'] = double.parse(_qtyBuffer.replaceAll("Decimal", '.')); // Update the qty
//           }
//         });
//         // print("Current qty buffer: $_qtyBuffer"); // Debugging: Print the buffer
//       } else if (key == "Enter") {
//         // Clear the buffer when Enter is pressed
//         setState(() {
//           _isListening = false; // Disable listening
//           _qtyBuffer = "";
//         });
//         print("Qty buffer cleared");
//       }
//     }
//   }

//   ///
//   List<Map<String, String>> classes = [{}];

//   final List<Map<String, dynamic>> _allItems = [
//     // {"id": 1, "name": "Apple", "price": 5.0, "discount": 0.0, "class": "A"},
//     // {"id": 2, "name": "Banana", "price": 5.0, "discount": 0.0, "class": "B"},
//     // {"id": 3, "name": "Orange", "price": 5.0, "discount": 0.0, "class": "A"},
//     // {"id": 4, "name": "Avocado", "price": 5.0, "discount": 0.0, "class": "C"},
//     // {"id": 5, "name": "Blueberry", "price": 5.0, "discount": 0.0, "class": "C"},
//     // {"id": 6, "name": "Strawberry", "price": 5.0, "discount": 0.0, "class": "C"},
//     // {"id": 7, "name": "Pineapple", "price": 5.0, "discount": 0.0, "class": "B"},
//     // {"id": 8, "name": "Mango", "price": 5.0, "discount": 0.0, "class": "A"},
//     // {"id": 9, "name": "Grapes", "price": 5.0, "discount": 0.0, "class": "A"},
//   ];

//   bool isRestPOS = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         // appBar: AppBar(
//         //   title: const Text('Main Invoice'),
//         // ),
//         body: Container(
//       padding: const EdgeInsets.all(8),
//       child: Row(
//         children: [
//           //right part
//           Expanded(
//             flex: isRestPOS ? 2 : 1,
//             child: cardView(
//               child: isRestPOS ? restRight() : right(),
//             ),
//           ),

//           const SizedBox(
//             width: 5,
//           ),
//           //center part

//           Expanded(
//             flex: isRestPOS ? 2 : 3,
//             child: cardView(
//               child: isRestPOS
//                   ? restCntr()
//                   : Column(
//                       children: [
//                         _buildHeaderRow(),
//                         Expanded(
//                           flex: 1,
//                           child: SizedBox(
//                             child: cntr(),
//                             height: 1,
//                           ),
//                         ),
//                       ],
//                     ),
//             ),
//           ),

//           const SizedBox(
//             width: 5,
//           ),
//           Expanded(
//             flex: 1,
//             child: cardView(paddding: 0, child: left()),
//           ),
//         ],
//       ),
//     ));
//   }

//   void _filterSearch(String query) {
//     if (query.isEmpty) {
//       setState(() => _filteredItems = []);
//     } else {
//       final results = _allItems.where((item) => item['name'].toLowerCase().contains(query.toLowerCase())).toList();
//       setState(() => _filteredItems = results);
//     }
//   }

//   right() {
//     return Stack(
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: 40,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(4),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 4,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: SizedBox(
//                 height: 45,
//                 child: TextFormField(
//                   controller: searchFild,
//                   textAlignVertical: const TextAlignVertical(y: -0.8),
//                   decoration: const InputDecoration(
//                     labelText: "بحث",
//                     labelStyle: TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                     suffixIcon: Icon(Icons.search),
//                     border: OutlineInputBorder(gapPadding: 4, borderSide: BorderSide.none),
//                   ),
//                   onChanged: _filterSearch,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             //
//             const Text(
//               "المفضلة",
//               style: TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//                 decoration: TextDecoration.underline,
//                 decorationStyle: TextDecorationStyle.solid,
//                 decorationThickness: 1,
//               ),
//             ),
//             SizedBox(
//               height: 250,
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 scrollDirection: Axis.vertical,
//                 itemCount: _allItems.length,
//                 itemBuilder: (context, index) {
//                   final item = _allItems[index];
//                   return ListTile(
//                     // iconColor: Colors.yellow,
//                     title: Row(
//                       children: [
//                         const Icon(
//                           Icons.star,
//                           color: Colors.grey,
//                         ),
//                         const SizedBox(
//                           width: 5,
//                         ),
//                         Text(item['name']),
//                       ],
//                     ),
//                     onTap: () => addInvoiceItem(item),
//                   );
//                 },
//               ),
//             ),
//             const DashedLine(
//               height: 1,
//               color: Colors.black26,
//               dashWidth: 6,
//               dashSpace: 4,
//             ),
//             const SizedBox(height: 8),
//             //
//             const Text(
//               "الاكثر مبيعاً",
//               style: TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//                 decoration: TextDecoration.underline,
//                 decorationStyle: TextDecorationStyle.solid,
//                 decorationThickness: 1,
//               ),
//             ),
//             SizedBox(
//               height: 250,
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 scrollDirection: Axis.vertical,
//                 itemCount: _allItems.length,
//                 itemBuilder: (context, index) {
//                   final item = _allItems[index];
//                   return ListTile(
//                     // iconColor: Colors.yellow,
//                     title: Row(
//                       children: [
//                         const Icon(
//                           Icons.tag,
//                           color: Colors.grey,
//                         ),
//                         const SizedBox(
//                           width: 5,
//                         ),
//                         Text(item['name']),
//                       ],
//                     ),
//                     onTap: () => addInvoiceItem(item),
//                   );
//                 },
//               ),
//             ),
//             const DashedLine(
//               height: 1,
//               color: Colors.black26,
//               dashWidth: 6,
//               dashSpace: 4,
//             ),
//           ],
//         ),
//         //search  drop list
//         if (_filteredItems.isNotEmpty)
//           Container(
//             margin: const EdgeInsets.only(top: 40),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border.all(color: Colors.grey.shade300),
//               borderRadius: BorderRadius.circular(8),
//               boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
//             ),
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: _filteredItems.length,
//               itemBuilder: (context, index) {
//                 final item = _filteredItems[index];
//                 return ListTile(
//                   title: Text(item['name']),
//                   onTap: () => addInvoiceItem(item),
//                 );
//               },
//             ),
//           ),
//       ],
//     );
//   }

//   restRight() {
//     return Column(
//       children: [
//         _buildHeaderRow(),
//         cntr(),
//       ],
//     );
//   }

//   cntr() {
//     return ListView.builder(
//       shrinkWrap: true,
//       scrollDirection: Axis.vertical,
//       itemCount: _invoiceItems.length,
//       itemBuilder: (context, index) {
//         // final item = _allItems[index];
//         return _buildCardRow(
//           index,
//           _invoiceItems[index]['name'],
//           _invoiceItems[index]['price'].toString(),
//           _invoiceItems[index]['qty'].toString(),
//           _invoiceItems[index]['discount'].toString(),
//           "${_invoiceItems[index]['price'] * _invoiceItems[index]['qty'] - _invoiceItems[index]['discount']}",
//         );
//       },
//     );
//   }

//   restCntr() {
//     return isClassGrid ? buildClassGrid() : buildItemGrid();
//   }

//   bool isClassGrid = true; // Flag to toggle between class grid and item grid
//   String selectedClass = ""; // The selected class
//   List<Map<String, dynamic>> filteredItemsByClass = []; // Filtered items for the selected class

//   Widget buildClassGrid() {
//     return GridView.builder(
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 4, // Number of columns
//         crossAxisSpacing: 8,
//         mainAxisSpacing: 8,
//         childAspectRatio: 1,
//       ),
//       itemCount: classes.length,
//       itemBuilder: (context, index) {
//         final className = classes[index]['NAME'];
//         final classId = classes[index]['Cl_1'];
//         // print(classes[index]['Cl_1']);
//         return Material(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           elevation: 2,
//           child: InkWell(
//             borderRadius: BorderRadius.circular(12),
//             splashColor: Colors.blue.withOpacity(0.2),
//             onTap: () {
//               // Filter items by the selected class
//               setState(() {
//                 selectedClass = className ?? "";
//                 filteredItemsByClass = _allItems.where((item) => item['class'] == classId).toList();
//                 isClassGrid = false; // Switch to the item grid
//               });
//             },
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(
//                   Icons.fastfood, // Replace with an appropriate icon
//                   size: 40,
//                   color: Colors.orange,
//                 ),
//                 const SizedBox(height: 8),
//                 Center(
//                   child: Text(
//                     className ?? "",
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // Grid view for items in the selected class
//   Widget buildItemGrid() {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       appBar: AppBar(
//         title: Text(
//           selectedClass,
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         leading: null,
//         backgroundColor: Colors.transparent,
//       ),
//       body: filteredItemsByClass.isNotEmpty
//           ? GridView.builder(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 4, // Number of columns
//                 crossAxisSpacing: 8,
//                 mainAxisSpacing: 8,
//                 childAspectRatio: 1,
//               ),
//               itemCount: filteredItemsByClass.length + 1, // Add 1 for the back button
//               itemBuilder: (context, index) {
//                 final item = filteredItemsByClass[index > 0 ? index - 1 : 0]; // Get the item or the back button
//                 // print(filteredItemsByClass.length);
//                 return Material(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   elevation: 2,
//                   child:
//                       // If it's the first item, show a back button
//                       index == 0
//                           ? InkWell(
//                               borderRadius: BorderRadius.circular(12),
//                               splashColor: Colors.blue.withOpacity(0.2),
//                               onTap: () {
//                                 setState(() {
//                                   isClassGrid = true; // Switch back to the class grid
//                                   selectedClass = ""; // Clear the selected class
//                                   filteredItemsByClass = []; // Clear the filtered items
//                                 });
//                               }, // Add item to the invoice on tap
//                               child: const Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Center(
//                                     child: Text(
//                                       "رجوع",
//                                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           : InkWell(
//                               borderRadius: BorderRadius.circular(12),
//                               splashColor: Colors.blue.withOpacity(0.2),
//                               onTap: () => addInvoiceItem(item), // Add item to the invoice on tap
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   const Icon(
//                                     Icons.fastfood, // Replace with an appropriate icon
//                                     size: 40,
//                                     color: Colors.orange,
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Center(
//                                     child: Text(
//                                       item['name'],
//                                       style: const TextStyle(fontSize: 16),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                 );
//               },
//             )
//           : Material(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               elevation: 2,
//               child:
//                   // If it's the first item, show a back button
//                   InkWell(
//                 borderRadius: BorderRadius.circular(12),
//                 splashColor: Colors.blue.withOpacity(0.2),
//                 onTap: () {
//                   setState(() {
//                     isClassGrid = true; // Switch back to the class grid
//                     selectedClass = ""; // Clear the selected class
//                     filteredItemsByClass = []; // Clear the filtered items
//                   });
//                 }, // Add item to the invoice on tap
//                 child: const Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Center(
//                       child: Text(
//                         "رجوع",
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _buildHeaderRow() {
//     return const Padding(
//       padding: EdgeInsets.all(8),
//       child: Row(
//         children: [
//           Expanded(flex: 2, child: Center(child: Text('صنف', style: TextStyle(fontWeight: FontWeight.bold)))),
//           Expanded(flex: 1, child: Center(child: Text('سعر', style: TextStyle(fontWeight: FontWeight.bold)))),
//           Expanded(flex: 1, child: Center(child: Text('كمية', style: TextStyle(fontWeight: FontWeight.bold)))),
//           Expanded(flex: 1, child: Center(child: Text('خصم', style: TextStyle(fontWeight: FontWeight.bold)))),
//           Expanded(flex: 1, child: Center(child: Text('اجمالي', style: TextStyle(fontWeight: FontWeight.bold)))),
//           Expanded(flex: 1, child: Center(child: Text('', style: TextStyle(fontWeight: FontWeight.bold)))),
//         ],
//       ),
//     );
//   }

//   Widget _buildCardRow(int index, String item, String price, String qty, String discount, String total) {
//     return Card(
//       surfaceTintColor: Colors.white,
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
//       child: Padding(
//         padding: const EdgeInsets.all(8),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(flex: 2, child: Center(child: Text(item, style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)))),
//                 Expanded(flex: 1, child: Center(child: Text(double.parse(price).toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)))),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFe2ecff),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   _invoiceItems[index]['qty']++;
//                                 });
//                               },
//                               icon: const Icon(Icons.add, color: Colors.blue)),
//                           const SizedBox(width: 10),
//                           Text(qty, style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
//                           const SizedBox(width: 10),
//                           IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   if (_invoiceItems[index]['qty'] > 1) {
//                                     _invoiceItems[index]['qty']--;
//                                   }
//                                 });
//                               },
//                               icon: const Icon(Icons.remove, color: Colors.red)),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFd3f9c9),
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     margin: const EdgeInsets.symmetric(horizontal: 5),
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: Center(
//                       child: Text(
//                         discount,
//                         style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(flex: 1, child: Center(child: Text(double.parse(total).toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)))),

//                 //remove item
//                 Expanded(
//                   flex: 1,
//                   child: Center(
//                     child: IconButton(
//                       onPressed: () => onRemoveInvoiceItem(index),
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   left() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           children: [
//             const SizedBox(height: 20),
//             totals(name: 'الاجمالي', value: double.parse(_invoiceItems.fold(0.0, (sum, item) => sum + (item['price'] * item['qty'])).toStringAsFixed(2))),
//             const SizedBox(height: 5),
//             const DashedLine(),
//             const SizedBox(height: 5),
//             totals(name: 'الخصم', value: double.parse(_invoiceItems.fold(0.0, (sum, item) => sum + (item['discount'])).toStringAsFixed(2))),
//             const SizedBox(height: 5),
//             const DashedLine(),
//             const SizedBox(height: 5),
//             totals(name: 'بعد الخصم', value: double.parse(_invoiceItems.fold(0.0, (sum, item) => sum + ((item['price'] * item['qty']) - item['discount'])).toStringAsFixed(2))),
//             const SizedBox(height: 5),
//             const DashedLine(),
//             const SizedBox(height: 5),
//             totals(name: 'الضريبة', value: double.parse(_invoiceItems.fold(0.0, (sum, item) => sum + (((item['price'] * item['qty']) - item['discount']) * 0.15)).toStringAsFixed(2))),
//             const SizedBox(height: 5),
//             const DashedLine(),
//             const SizedBox(height: 5),
//             totals(name: 'الاجمالي شامل الضريبة', value: double.parse(_invoiceItems.fold(0.0, (sum, item) => sum + ((item['price'] * item['qty'] - item['discount']) * 1.15)).toStringAsFixed(2))),
//             const SizedBox(height: 5),
//             const DashedLine(
//               cropSide: true,
//             ),
//             const SizedBox(height: 5),
//           ],
//         ),
//         Row(
//           children: [
//             Expanded(
//               child: TextButton(
//                 style: TextButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 30),
//                   backgroundColor: const Color(0xFF58be45),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     isRestPOS = !isRestPOS;
//                   });
//                 },
//                 child: const Text(
//                   'الدفع',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   totals({required String name, required double value}) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           Expanded(
//             child: Text(
//               name,
//               style: const TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//           // const SizedBox(width: 5),
//           Expanded(
//             child: Center(
//               child: Text(
//                 "$value",
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//           ),
//           // const Spacer(),
//           Expanded(
//             child: SvgPicture.asset(
//               'assets/images/rs.svg',
//               height: 20,
//               width: 20,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void addInvoiceItem(Map<String, dynamic> item) {
//     // Check if the item already exists in the invoice
//     if (_invoiceItems.any((element) => element['id'] == item['id'])) {
//       // If the item already exists in the invoice, just update the quantity
//       setState(() {
//         _invoiceItems.firstWhere((element) => element['id'] == item['id'])['qty']++;
//       });
//     } else {
//       // If the item doesn't exist, add it to the invoice
//       setState(() {
//         _invoiceItems.add({
//           ...item, // Copy all existing properties from the item
//           'qty': 1, // Add the qty property with a default value of 1
//         });
//       });
//     }
//     // Clear the search field and filtered items after selection
//     searchFild.clear();
//     _filteredItems.clear();
//     _qtyBuffer = ""; // Reset the buffer for new input
//     _isListening = true; // Enable listening
//     _keyboardFocusNode.requestFocus();
//   }

//   void onRemoveInvoiceItem(int index) {
//     setState(() {
//       _invoiceItems[index]['qty'] = 0; // Reset the quantity to 0
//       _invoiceItems.removeAt(index);
//     });
//   }
// }
