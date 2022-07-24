import 'dart:convert';

import 'package:brothers88/login_page.dart';
import 'package:brothers88/super_admin/menu.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

class SupperAdmin extends StatefulWidget {
  SupperAdmin({Key? key}) : super(key: key);

  @override
  _SupperAdminState createState() => _SupperAdminState();
}

class _SupperAdminState extends State<SupperAdmin> {
  GlobalKey<SliderDrawerState> _drawer = GlobalKey<SliderDrawerState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SliderDrawer(
            key: _drawer,
            appBar: const SliderAppBar(
              appBarColor: Colors.black,
              // appBarPadding: EdgeInsets.only(right: ),
              title: Text(
                "SuperAdmin",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              drawerIconColor: Colors.white,
              trailing: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.person, color: Colors.white, size: 25),
              ),
              isTitleCenter: true,
            ),
            slider: Container(
                color: Colors.grey[900],
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: ListView(
                    children: [
                      Container(
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: MediaQuery.of(context).size.height / 5,
                          width: MediaQuery.of(context).size.width / 5,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text("SuperAdmin",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        thickness: 5,
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Menu(),
                              ));
                        },
                        title: Text("Menu",
                            style:
                                TextStyle(color: Colors.white, fontSize: 15)),
                        leading: FaIcon(
                          FontAwesomeIcons.mugSaucer,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                      ListTile(
                        title: Text("Kategori",
                            style:
                                TextStyle(color: Colors.white, fontSize: 15)),
                        leading: FaIcon(
                          FontAwesomeIcons.tags,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                      // ListTile(
                      //   title: Text("Transaksi",
                      //       style:
                      //           TextStyle(color: Colors.white, fontSize: 15)),
                      //   leading: FaIcon(
                      //     FontAwesomeIcons.dollarSign,
                      //     color: Colors.white,
                      //     size: 15,
                      //   ),
                      // ),
                      ListTile(
                        onTap: () {
                          logout();
                        },
                        title: Text("Logout",
                            style:
                                TextStyle(color: Colors.white, fontSize: 15)),
                        leading: FaIcon(
                          FontAwesomeIcons.doorOpen,
                          color: Colors.red,
                          size: 15,
                        ),
                      )
                    ],
                  ),
                )),
            child: ListView()),
      ),
    );
  }

  Future<Map> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    final response = await http.get(
        Uri.parse("https://api.brothers-88.com/superadmin/main"),
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Authorization": 'Bearer $token',
        });
    print(response.body);
    if (response.statusCode == 200) {
      return json.decode(response.body);
      // List jsonResponse = json.decode(response.body)['data'];

      // return "";
      // return jsonResponse.map((data) => Order.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  logout() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    final response = await http.get(
      Uri.parse("https://api.brothers-88.com/auth/logout"),
      headers: {
        "Accept": "application/json",
        "Authorization": 'Bearer $token',
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/x-www-form-urlencoded"
      },
    );
    prefs.remove("token");
    print(response.body);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
  }
}
