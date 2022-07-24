import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class DetailMenu extends StatefulWidget {
  final int id;
  final int price;
  final String nama;
  DetailMenu({Key? key, required this.id, required this.price,required this.nama}) : super(key: key);

  @override
  _DetailMenuState createState() => _DetailMenuState();
}

class _DetailMenuState extends State<DetailMenu> {
  late String nama = widget.nama;
  
  @override
  Widget build(BuildContext context) {
    TextEditingController _price = TextEditingController(
    text: widget.price.toString(),
  );
  TextEditingController _nama = TextEditingController(
    text: widget.nama,
  );
    return SafeArea(
       child: Scaffold(
         backgroundColor: Colors.black,
         appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text("Detail Menu"),
              actions: [
              ],
            ),
            body: Padding(
              padding: EdgeInsets.only(left: 6,top: 5),
              child: ListView(
              children: [
                 Text("Nama",style: TextStyle(color: Colors.white),),
                TextField(
                  style: TextStyle(color: Colors.white),
                  controller: _nama,
                  decoration:  InputDecoration(
                    hintText: "Nama Menu"
                  ),
                ),
                Text("Harga",style: TextStyle(color: Colors.white),),
                TextField(
                  style: TextStyle(color: Colors.white),
                  controller: _price,
                  decoration:  InputDecoration(
                    hintText: "Harga"
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height/9,
                ),
                 Center(
                   child: SizedBox(
                  width: MediaQuery.of(context).size.width/3,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (){
                      update(_price.text, _nama.text, widget.id);
                    },
                  child: Text("Update",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),),
                ),
                 ))
              ],
            ),
            )
       ),
    );
  }
  update(price,name,id) async{
     final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    final response = await http.post(
        Uri.parse("https://api.brothers-88.com/superadmin/menu/update/${widget.id}"),
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Authorization": 'Bearer $token',
        },body: {
          "_method" : "PUT",
          "price": price,
          "name":name
        });
        print(response.body);
    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }
}