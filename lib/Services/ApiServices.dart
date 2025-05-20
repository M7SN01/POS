import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String protocol = "http";
String ip = "localhost";
String port = '881';
// String docurl = "$protocol://$ip:$port/GsApi/api/gsEmp/GetImage/";
// String imagesUrl = "$protocol://$ip:$port/gsHr/assets/img/";
// String domain = "$protocol://$ip:$port/GsApi/api/";
var url = '$protocol://$ip:$port/pos/api/values/CMD/1';

// var notification_url = "$protocol://$ip:$port/FireNotification/api/values/push";

class Services {
  Future<List<dynamic>> createRep({required String sqlStatment, BuildContext? context, Function(String error)? errorCallback}) async {
    var sql = {"CMD": sqlStatment};
    // print(sqlStatment);
    // print(dotenv.env['URL']!);
    final response = await http.post(Uri.parse(url), body: sql);
    if (response.statusCode == 200) {
      try {
        final jsonResponse = json.decode(response.body);
        return jsonResponse;
      } catch (e) {
        String exceptionMessage = "";
        int startIdx = response.body.toString().indexOf('"ExceptionMessage":"');
        if (startIdx != -1) {
          startIdx += '"ExceptionMessage":"'.length;

          int endIdx = response.body.toString().indexOf('","ExceptionType"', startIdx);
          if (endIdx != -1) {
            exceptionMessage = response.body.toString().substring(startIdx, endIdx);
          }
        }
        errorCallback!(exceptionMessage);

        return [];
      }
    } else {
      errorCallback!("${response.body} فشل الإتصال بالسيرفر");
      return [];
    }
  }
}
