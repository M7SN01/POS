import 'package:flutter/material.dart';

import '../app/locale/locale_controller.dart';

Widget cardView({required Widget child, double paddding = 8.0}) {
  return Card(
    elevation: 4, // Adjust the elevation as needed
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    child: Padding(
      padding: EdgeInsets.all(paddding),
      child: child,
    ),
  );
}

class DashedLine extends StatelessWidget {
  final double height;
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final bool cropSide;

  const DashedLine({
    this.height = 1,
    this.color = Colors.grey,
    this.dashWidth = 5,
    this.dashSpace = 3,
    this.cropSide = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final dashCount = (constraints.maxWidth / (dashWidth + dashSpace)).floor();
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(dashCount, (x) {
          if ((x == 0 || x == dashCount - 1) && cropSide) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFf5f7f9),
                // shape: BoxShape.circle,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    LocaleController().currentLanguage == "ar"
                        ? x == 0
                            ? 10
                            : 0
                        : x == 0
                            ? 0
                            : 10,
                  ),
                  bottomLeft: Radius.circular(
                    LocaleController().currentLanguage == "ar"
                        ? x == 0
                            ? 10
                            : 0
                        : x == 0
                            ? 0
                            : 10,
                  ),
                  topRight: Radius.circular(
                    LocaleController().currentLanguage == "ar"
                        ? x != 0
                            ? 10
                            : 0
                        : x != 0
                            ? 0
                            : 10,
                  ),
                  bottomRight: Radius.circular(
                    LocaleController().currentLanguage == "ar"
                        ? x != 0
                            ? 10
                            : 0
                        : x != 0
                            ? 0
                            : 10,
                  ),
                ),
              ),
              child: const SizedBox(
                width: 20,
                height: 20,
              ),
            );
          } else {
            return SizedBox(
              width: dashWidth,
              height: height,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }
        }),
      );
    });
  }
}

/*
bool searching = false;

class CusSearchDelegate extends SearchDelegate {
  String hint;
  String statment;

  Function rollback;
  CusSearchDelegate({required this.hint, required this.rollback, required this.statment});

  //  hint text
  @override
  String get searchFieldLabel => hint;

  //Action for App bar
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(
            Icons.clear,
            color: query == "" ? Colors.transparent : Colors.grey,
          ))
    ];
  }

  //icon leading
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          rollback("", "");
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  //when click OK
  @override
  Widget buildResults(BuildContext context) {
    return InkWell(
      child: Container(),
      // onTap: gotosearch(context, query),
    );
  }

  // bool searching = false;
  @override
  Widget buildSuggestions(BuildContext context) {
    searchitems = [];
    searching = true;
    return FutureBuilder(
      // initialData: [],
      future: search_query(query, context),
      builder: (context, snapshot) {
        if (!searching) {
          if (searchitems.isNotEmpty) {
            return ListView.builder(
              itemCount: searchitems.length,
              itemBuilder: (context, index) {
                // var result = matchQuery[index];
                return ListTile(
                  leading: IconButton(onPressed: () {}, icon: const Icon(Icons.list)),
                  /****************************** */
                  title: GestureDetector(
                    onTap: () {
                      //WHEN click search result
                      // print(searchitems[index].ID);
                      rollback(searchitems[index].ID, searchitems[index].NAME);
                      close(context, null);
                      // else open public item
                    },
                    child: Text(searchitems[index].NAME),
                  ),
                );
              },
            );
          } else {
            // print("NO DATA");
            return const Center(
                child: Text(
              "لاتوجد نتائج",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            )
                // const LocaleText(
                //   "noresultlikesearch",
                //   style: TextStyle(
                //     fontSize: 20,
                //     color: Colors.grey,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                );
          }
        } else {
          return const Center(child: LoadingView());
        }
      },
    );
  }

  List<SarchItems> searchitems = [];
  Future search_query(String SearchValue, BuildContext context) async {
    // print(SearchValue);
    searching = true;

    String q = "$statment AND ( upper(item_name) LIKE upper('%$SearchValue%') OR upper(item_id) LIKE upper('%$SearchValue%') ) ";
    // print(q);
    var respone = null; // await SS.readData(sqlStatment: q, context: context);
    var decodedJson = respone.cast<Map<String, dynamic>>();
    searchitems = decodedJson.map<SarchItems>((json) => SarchItems.fromJson(json)).toList();
    searching = false;
    return searchitems;
  }
}

class SarchItems {
  factory SarchItems.fromJson(Map<String, dynamic> json) {
    return SarchItems(
      ID: json['ID'].toString(),
      NAME: json['NAME'].toString(),
    );
  }
  SarchItems({this.ID = "", this.NAME = ""});
  String ID;
  String NAME;
}

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.blue), shape: BoxShape.circle),
      child: SizedBox(
        height: 50,
        width: 50,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: -(_controller.value * 2.0 * 3.1415926535897932),
              child: Image.asset('assets/images/orca.png'),
            );
          },
        ),
      ),
    );
  }
}
*/
