import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final myController = TextEditingController();

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("HATA"),
          content: new Text("geçersiz şehir"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("tamam"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/search.jpg'),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: myController,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25),
                  decoration: InputDecoration(
                    hintText: "Şehir seçin",
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
              FlatButton(
                  onPressed: () async {
                    var bosmu = await http.get(Uri.parse(
                        'https://api.openweathermap.org/data/2.5/weather?q=${myController.text}&appid=a2c4b0170264ad4613a4ea65571e8815'));
                 if(jsonDecode(bosmu.body).isEmpty){

                   _showDialog();

                 }
                    else {
                   Navigator.pop(context, myController.text);

                 }
                  },
                  child: Text("şehir seç"))
            ],
          ),
        ),
      ),
    );
  }
}
