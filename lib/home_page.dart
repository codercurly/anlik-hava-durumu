import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:havadrmuygu/search_page.dart';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? sehir="";
  int? sicaklik;
  var locationData;
  var woeid;
  var latim;
  var arka = "Clear";
  late Position position;
  int? dene;



  Future<void> konum() async {

   try {
     position = await Geolocator.getCurrentPosition(
         desiredAccuracy: LocationAccuracy.low);
   }
   catch (error){
     sehir="konumunuza erişilemedi";
     sicaklik= "".toString() as int?;
     print(error);
   }
  }

  final spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.red : Colors.green,
        ),
      );
    },
  );

  Future<void> getlanlontemp() async {
    var data = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=${position
            .latitude}&lon=${position
            .longitude}&appid=a2c4b0170264ad4613a4ea65571e8815'));
    var sicakcevir = jsonDecode(data.body);

    setState(() {
      var cevirme1 = (sicakcevir['main']['temp'].round() - 273);
      sicaklik = cevirme1;


    });
  }


    Future<void> getlanloncity() async {
      var data = await http.get(Uri.parse(
        'http://api.openweathermap.org/geo/1.0/reverse?lat=${position.latitude}&lon=${position.longitude}&limit=5&appid=a2c4b0170264ad4613a4ea65571e8815'));
      var citybody = jsonDecode(utf8.decode(data.bodyBytes));

      setState(() {
        var cityname = citybody[0]['name'];
        sehir = cityname;

      });
    }

  Future<void> getTemp() async {
    var tempdata = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$sehir&appid=a2c4b0170264ad4613a4ea65571e8815'));
    var tempParsed = jsonDecode(tempdata.body);

    setState(() {
      var cevirme = (tempParsed['main']['temp'].round() - 273);
      sicaklik = cevirme;
      arka = tempParsed['weather'][0]['main'];
    });
  }

  Future<http.Response> havaimg ()async{
    var havadata = await http.get(Uri.parse('https://mgm.gov.tr/sunum/tahmin-show-1.aspx?m=$sehir&basla=1&bitir=4&rC=111&rZ=fff'));
    return havadata;
  }


  void getFromApi() async {
    // await  getLocationData();
   await konum();
   await getlanlontemp();
   await getlanloncity();

  }
  void getFromApinew() async {
    // await  getLocationData();
    getTemp();
  }

  @override
  void initState() {
    getFromApi();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/$arka.jpg'),
        ),
      ),
      child:
      sicaklik == null ? Center(child: spinkit) :
      Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      child: Image.asset('assets/$arka.png'),
                    ),
                    Text(
                      "$sicaklik° C",
                      style: TextStyle(
                          fontSize: 70,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                                color: Colors.black,
                                offset: Offset(-4, 4),
                                blurRadius: 10)
                          ]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$sehir",
                          style: TextStyle(fontSize: 40, shadows: [
                            Shadow(
                                color: Colors.black,
                                offset: Offset(-3, 3),
                                blurRadius: 10)
                          ]),
                        ),
                        IconButton(
                            icon: Icon(Icons.search),
                            iconSize: 60,
                            onPressed: () async {
                              sehir = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchPage()));
                              getFromApinew();
                              setState(() {
                                sehir = sehir;
                              });
                            })
                      ],
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width*0.9,
                      height: 150,
                      child: ListView(
                          scrollDirection: Axis.horizontal,
                          children:[


                          Image.network('https://mgm.gov.tr/sunum/tahmin-show-1.aspx?m=$sehir&basla=1&bitir=7&rC=100&rZ=fff',

                            width: 400,
                          height:200,

                          ),

                          ]

                      ),
                    ),


                  ],
                ),
              ),
            ),
    );
  }
}


