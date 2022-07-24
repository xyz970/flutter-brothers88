import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// logout() async{
//   final prefs = await SharedPreferences.getInstance();
//   var token = prefs.getString("token");
//     final response =
//         await http.post(Uri.parse("https://api.brothers-88.com/auth/login"),
//             headers: {
//               "Accept": "application/json",
//               "Bearer-Token" : token!,
//               "Access-Control-Allow-Origin" : "*",
//               "Content-Type": "application/x-www-form-urlencoded"
//             },
//             encoding: Encoding.getByName("utf-8"));
//     print(response.body);
//     Navigator.push(context, MaterialPageRoute(builder: (context) => Crew(),));
// }

deletePref(){

}