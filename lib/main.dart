import 'package:flutter/material.dart';
import 'package:test_connect/nombre.dart';
import 'package:test_connect/numero.dart';
import 'package:test_connect/tipo.dart';
import 'package:test_connect/debilidad.dart';
import 'package:test_connect/app.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(App());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homePage(),
    );
  }
}

class homePage extends StatefulWidget {
  homePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<homePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    // TODO: implement build
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      //Aqui va la vista
      bottomNavigationBar: BottomNavigationBar(
        elevation: 1.0,
        iconSize: 25,
        selectedFontSize: 14.5,
        unselectedItemColor: Colors.purple[600],
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              backgroundColor: Colors.black87,
              icon: Icon(Icons.adjust, color: Colors.lightBlue[400]),
              title: Text("Name")),
          BottomNavigationBarItem(
              backgroundColor: Colors.black87,
              icon: Icon(Icons.all_inclusive, color: Colors.pink),
              title: Text("Number")),
          BottomNavigationBarItem(
              backgroundColor: Colors.black87,
              icon: Icon(Icons.whatshot, color: Colors.deepOrange),
              title: Text("Type")),
          BottomNavigationBarItem(
              backgroundColor: Colors.black87,
              icon: Icon(Icons.wb_iridescent, color: Colors.green),
              title: Text("Debilidades")),
          BottomNavigationBarItem(
              backgroundColor: Colors.black87,
              icon: Icon(Icons.wifi, color: Colors.tealAccent),
              title: Text("Wi-Fi"))
        ],
        backgroundColor: Colors.deepPurple,
        selectedItemColor: Colors.amber,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  //Lista de las pantallas
  List<Widget> _widgetOptions = <Widget>[
    PantallaNombres(),
    PantallaNumeros(),
    PantallaTipos(),
    PantallaDebilidades(),
    App()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

}
