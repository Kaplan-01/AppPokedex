//Importa los archivos
import 'dart:async';
import 'package:test_connect/nombre.dart';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(PantallaNombres());

// especifica la plataforma para evitar errores

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
      ThemeData(brightness: Brightness.dark, primarySwatch: Colors.teal),
      darkTheme: ThemeData(
          brightness: Brightness.light, primarySwatch: Colors.teal),
      home: MyHomePage(title: 'CONEXION'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//Se crea la clase que define el estado de la conexion
class _MyHomePageState extends State<MyHomePage> {
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  // lo que se encarga de cambiar la conexion
  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Los mensajes son asincronos, por eso se inicia asi
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Por si la conexion llega a fallar
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // por si el estado de conexion cambia mientras se actualiza
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,

        body: Container(
          decoration: new BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple,
                  Colors.lightBlue[500],
                ],
              )
          ),
    child: FlatButton(
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) =>
    new MyApp()
    ));
    },
          child:
          Center(
              child: Text('Estado de la conexion: $_connectionStatus'),
            ),
    ),
      )
    );
  }
// se hace async por el mensaje
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        String wifiName, wifiBSSID, wifiIP;

        //todas las sentencias de if y de los casos de estado de la conexion van aqui
        try {
          if (Platform.isIOS) {
            LocationAuthorizationStatus status =
            await _connectivity.getLocationServiceAuthorization();
            if (status == LocationAuthorizationStatus.notDetermined) {
              status =
              await _connectivity.requestLocationServiceAuthorization();
            }
            if (status == LocationAuthorizationStatus.authorizedAlways ||
                status == LocationAuthorizationStatus.authorizedWhenInUse) {
              wifiName = await _connectivity.getWifiName();
            } else {
              wifiName = await _connectivity.getWifiName();
            }
          } else {
            wifiName = await _connectivity.getWifiName();
          }
        } on PlatformException catch (e) {
          print(e.toString());
          wifiName = "Failed to get Wifi Name";
        }

        try {
          if (Platform.isIOS) {
            LocationAuthorizationStatus status =
            await _connectivity.getLocationServiceAuthorization();
            if (status == LocationAuthorizationStatus.notDetermined) {
              status =
              await _connectivity.requestLocationServiceAuthorization();
            }
            if (status == LocationAuthorizationStatus.authorizedAlways ||
                status == LocationAuthorizationStatus.authorizedWhenInUse) {
              wifiBSSID = await _connectivity.getWifiBSSID();
            } else {
              wifiBSSID = await _connectivity.getWifiBSSID();
            }
          } else {
            wifiBSSID = await _connectivity.getWifiBSSID();
          }
        } on PlatformException catch (e) {
          print(e.toString());
          wifiBSSID = "Failed to get Wifi BSSID";
        }

        try {
          wifiIP = await _connectivity.getWifiIP();
        } on PlatformException catch (e) {
          print(e.toString());
          wifiIP = "Failed to get Wifi IP";
        }
        // El resultado de la conexion

        setState(() {
          _connectionStatus =
          '$result\n'
              'Wifi Name: $wifiName\n'
              'Wifi BSSID: $wifiBSSID\n'
              'Wifi IP: $wifiIP\n'
              '\n'
              '\n'
              'CON CONECTIVIDAD'

          ;
        });


        break;
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
      //por si falla la conexion
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }
  _showSnackbar(BuildContext context, String texto){
    final snackBar=SnackBar(
        content: new Text(texto)
    );
    _scaffoldkey.currentState.showSnackBar(snackBar);
  }
}