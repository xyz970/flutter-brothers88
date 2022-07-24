import 'dart:convert';

import 'package:brothers88/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Admin extends StatefulWidget {
  Admin({Key? key}) : super(key: key);

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  late Future<List<Order>> futureData;
  @override
  void initState() {
    super.initState();
    futureData = fetchData();
    setState(() {
      fetchData();
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
       child: Scaffold(
         backgroundColor: Colors.black,
         appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text("Data Pesanan"),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(onPressed: (){
                  setState(() {
                    
                  });
                }, icon: Icon(Icons.refresh)),
                IconButton(
                    tooltip: "Logout",
                    onPressed: () {
                      logout();
                    },
                    icon: Icon(
                      Icons.door_back_door_outlined,
                      color: Colors.red,
                    ))
              ],
            ),
            body: RefreshIndicator(
                onRefresh: (){
                  return fetchData();
                },
                child: Center(
                  child: FutureBuilder<List<Order>>(
                    future: futureData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Order>? data = snapshot.data;
                        if (data?.length == 0) {
                          print(data?.length);
                          return Center(
                          child: Text("Data kosong"),
                        );
                        } else {
                          return ListView.builder(
                            itemCount: data?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)
                                ),
                                onTap: (){
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => 
                                  // DetailOrder(
                                  //   id: data![index].id,
                                  //   meja: data[index].table_id,
                                  //   nama: data[index].costumer_name,
                                  //   note: data[index].note,
                                  //   ),));

                                },
                                textColor: Colors.white,
                                title: Text(data![index].costumer_name, style: TextStyle(color: Colors.white),),
                                // subtitle: RichText(text: Text.rich()),
                                subtitle: Text("Rp. ${data[index].total}"),
                                trailing: Icon(Icons.chevron_right_rounded,color: Colors.white,),
                                leading: Icon(Icons.price_check_outlined,color: Colors.white,),
                              );
                            });
                        }
                        
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      // By default show a loading spinner.
                      return Center(child: CircularProgressIndicator(),);
                    },
                  ),
                ))
       ),
    );
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

Future<List<Order>> fetchData() async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("token");
  final response = await http
      .get(Uri.parse("https://api.brothers-88.com/admin/order/list"), headers: {
    "Accept": "application/json",
    "Access-Control-Allow-Origin": "*",
    "Authorization": 'Bearer $token',
  });
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body)['data'];

    // return "";
    return jsonResponse.map((data) => Order.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class Order {
  final String id;
  final String table_id;
  final String? note;
  final int total;
  final String costumer_name;
  final String costumer_number;

  Order(
      {required this.id,
      required this.table_id,
      required this.note,
      required this.total,
      required this.costumer_name,
      required this.costumer_number});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        id: json['id'],
        table_id: json['table_id'],
        note: json['note'],
        total: json['total'],
        costumer_name: json['costumer_name'],
        costumer_number: json['costumer_number']);
  }
}