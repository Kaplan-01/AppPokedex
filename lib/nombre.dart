import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ver_detalles.dart';
import 'POKEMON.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

void main() => runApp(MaterialApp(
  home: PantallaNombres(),
));

class PantallaNombres extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<PantallaNombres> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
      ThemeData(
          brightness: Brightness.dark, primarySwatch: Colors.teal),
      darkTheme: ThemeData(
          brightness: Brightness.light, primarySwatch: Colors.teal),
      home: _buscaNombre(),
    );
  }
}

class _buscaNombre extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<_buscaNombre> {
  // var url = "https://raw.githubusercontent.com/MariaDelCarmenHernandezDiaz/pokemon2/master/pokemon.json";
  var url = "https://raw.githubusercontent.com/MariaDelCarmenHernandezDiaz/pokemon2/master/pokemon2.json";
  PokeHub pokeHub;
  get orientation => true;

  //Variables de control
  List _salidas;
  File _Imagen;
  bool _isLoading = false;

  void initState() {
    super.initState();
    bajar();
    _isLoading = true;
    loadModel().then((value){
      setState(() {
        _isLoading = false;
      });
    });
  }

  void bajar() async {
    var res = await http.get(url);
    print(res.body);
    var decodedJson = jsonDecode(res.body);
    pokeHub = PokeHub.fromJson(decodedJson);
    print(pokeHub.toJson());
    setState(() {});
  }
  _sinohay() {
    int tryo = pokeHub.pokemon
        .where((poke) =>
        poke.name.toString().toLowerCase().contains(_search.text.toLowerCase())).length;
    if (tryo == 0) {
      _showSnackbar(context, "Oh oh, no hay resultados");
    }
  }
  String _searchText = "";
  final TextEditingController _search = new TextEditingController();
  Widget _appBarTitle = new Text("Search Pokemon");
  bool _typing = false;
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        key: _scaffoldkey,
              appBar: AppBar(
          title: _typing ? TextField(
            autofocus: true,
            controller: _search,
            onChanged: (text){
              _sinohay();
              setState(() {});
            },
          ):Text("Search by name"),
          leading: IconButton(
            highlightColor: Colors.lightGreen,
            padding: EdgeInsets.all(10),
            icon: Icon(_typing ? Icons.done: Icons.search),
            onPressed: (){
              print("Its typing "+_typing.toString());
              setState(() {
                _typing = ! _typing;
                _search.text="";
              });
            },
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),

        backgroundColor: Colors.grey[700],
        body: pokeHub == null
            ? Center(
          child: LinearProgressIndicator(
            backgroundColor: Colors.amber,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
          ),
        ): OrientationBuilder(builder: (context, orientation){
          return GridView.count(
              crossAxisCount: orientation==Orientation.portrait?3:6,
              //reverse: false, scrollDirection: Axis.horizontal,
              children: pokeHub.pokemon.where((poke)=>
                  poke.name.toLowerCase().contains(_search.text.toLowerCase()))
                  .map(
                    (poke) => Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => detalles(pokemon: poke, pokeHub: pokeHub,)));
                    },
                    child: Hero(
                      tag: poke.img,
                      child: Card(
                        elevation: 3.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              height: 100.0,
                              width: 100.0,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(poke.img))),
                            ),
                            Text(
                              poke.name,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
                  .toList()
          );
        }
        ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          new FloatingActionButton(
            heroTag: "btn1",
            backgroundColor: Colors.deepOrange[500],
            onPressed: pickImage,
            child: Icon(Icons.image,  color: Colors.white),
            mini:true,
          ),
          new FloatingActionButton(
            heroTag: "btn2",
            backgroundColor: Colors.deepOrange[500],
            onPressed: pickImageC,
            child: Icon(Icons.camera_alt, color: Colors.white),
            mini:true,
          ),
        ],
      ),
    );
  }


//Cargar Imagen desde Galería

  pickImage() async { // Puede ser Future
    var imagen = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(imagen == null) return null;
    setState(() {
      _isLoading = true;
      _Imagen = imagen;
    });
    clasificar(imagen);
  }

//Cargar Imagen desde Camara

   pickImageC() async { // Puede ser Future
    var imagen = await ImagePicker.pickImage(source: ImageSource.camera);
    if(imagen == null) return null;
    setState(() {
      _isLoading = true;
      _Imagen = imagen;
    });
    clasificar(imagen);
  }

  clasificar(File image) async{
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 10,
      threshold: 0.6,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _isLoading = false;
      _salidas = output;
      print(output);
    });
    if (_salidas[0]['confidence'] >= 0.8) {
      print("Esta aqui.");
    pokeHub.pokemon.where((poke) => poke.num.toString().toLowerCase().contains(_salidas[0]['label'])).map((poke)
        =>
          Navigator.push(context, MaterialPageRoute(builder: (context) => detalles(pokemon: poke, pokeHub: pokeHub,)))).toList();
      print("Debio regresarlo.");
    }else{
      _showSnackbar(context,"Ese pokemon no esta disponible ahora");
    }
  }
//Cargar Modelo
  loadModel() async{
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }
  @override
  void dispose(){
    Tflite.close();
    super.dispose();
  }

  _showSnackbar(BuildContext context, String texto){
    final snackBar=SnackBar(
        content: new Text(texto)
    );
    _scaffoldkey.currentState.showSnackBar(snackBar);
  }
}