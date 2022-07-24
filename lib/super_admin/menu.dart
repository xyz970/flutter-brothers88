import 'dart:convert';
import 'package:brothers88/super_admin/menu/detail_menu.dart';
import 'package:brothers88/super_admin/menu/tambah_menu.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatefulWidget {
  Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  late Future<List<MenuList>> futureData;
  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

// Future void _refresh(BuildContext context){
//   return fetchData();
// }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          floatingActionButton: CircleAvatar(
            child: IconButton(
              tooltip: "Tambah Menu",
            color: Colors.white,
            icon: Icon(Icons.add),
            onPressed: (){
               Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TambahMenu(),
                              ));
            },
          ),
          ),
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text("Data Menu"),
              actions: [
                // Icon(Icons.search)
                IconButton(
                    color: Colors.white,
                    onPressed: () {
                      showSearch(
                        useRootNavigator: true,
                          context: context, delegate: CustomSearchDelegate());
                    },
                    icon: Icon(Icons.search))
              ],
            ),
            body: RefreshIndicator(
                onRefresh: ()=>fetchData(),
                  child: FutureBuilder<List<MenuList>>(
                    future: futureData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<MenuList>? data = snapshot.data;
                        if (data?.length == 0) {
                          print(data?.length);
                          return Center(
                            child:
                                Text("Data kosong"),
                          );
                        } else {
                          return ListView.builder(
                              itemCount: data?.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                      DetailMenu(
                                        id: data![index].id,
                                        nama: data[index].name,
                                        price: data[index].price,
                                        ),));
                                    },
                                    textColor: Colors.white,
                                    title: Text(
                                      data![index].name,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text("Rp. ${data[index].price}"),
                                    leading: FaIcon(
                                      FontAwesomeIcons.plateWheat,
                                      color: Colors.white,
                                    ),
                                    trailing: Switch(
                                        value: data[index].status == "true"
                                            ? true
                                            : false,
                                        onChanged: (value) {
                                          setState(() {
                                            update(data[index].id);
                                          initState();
                                            fetchData();
                                          });
                                        }));
                              });
                        }
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      // By default show a loading spinner.
                      return Center(child: CircularProgressIndicator(),);
                    },
                  ),
                )));
  }

  update(id) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    final response = await http.post(
        Uri.parse(
            "https://api.brothers-88.com/superadmin/menu/change/status/$id"),
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Authorization": 'Bearer $token',
        },
        body: {
          "_method": "PUT"
        });
    print(response.body);
    if (response.statusCode == 200) {
      //  fetchData();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    // TODO: implement appBarTheme
    return Theme.of(context).copyWith(
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        // color: Colors.white,
        titleTextStyle: TextStyle(color: Colors.white),
        // color: Colors.black,
        toolbarTextStyle: TextStyle(color: Colors.white)
      ),
    );
  }
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> q = [];
    for (var search in q) {
      if (search.toLowerCase().contains(query.toLowerCase())) {
        q.add(search);
      }
    }
    return Container(
      
      color: Colors.black,
      child: ListView.builder(
        itemCount: q.length,
        itemBuilder: (context, index) {
          var result = q[index];
          return ListTile(
            title: Text(result),
          );
        }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> q = [];
    for (var search in q) {
      if (search.toLowerCase().contains(query.toLowerCase())) {
        q.add(search);
      }
    }
    return ListView.builder(
        itemCount: q.length,
        itemBuilder: (context, index) {
          var result = q[index];
          return ListTile(
            title: Text(result),
          );
        });
  }
}

Future<List<MenuList>> fetchData() async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("token");
  final response = await http.get(
      Uri.parse("https://api.brothers-88.com/superadmin/menu/list"),
      headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Authorization": 'Bearer $token',
      });
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body)['data'];

    // return "";
    return jsonResponse.map((data) => MenuList.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class MenuList {
  final int id;
  final String name;
  final int price;
  final String status;

  MenuList({
    required this.id,
    required this.name,
    required this.price,
    required this.status,
  });

  factory MenuList.fromJson(Map<String, dynamic> json) {
    return MenuList(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      status: json['status'],
    );
  }
}
