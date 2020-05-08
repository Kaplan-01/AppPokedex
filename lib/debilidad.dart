import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ver_detalles.dart';
import 'POKEMON.dart';
import 'package:flutter/services.dart';


void main() => runApp(PantallaDebilidades());

class PantallaDebilidades extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme:
      ThemeData(brightness: Brightness.dark, primarySwatch: Colors.teal),
      darkTheme: ThemeData(
          brightness: Brightness.light, primarySwatch: Colors.teal),
      home: _buscaDebilidad(),
    );
  }
}

class _buscaDebilidad extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<_buscaDebilidad> {
  var url = "https://raw.githubusercontent.com/MariaDelCarmenHernandezDiaz/pokemon2/master/pokemon2.json";
  PokeHub pokeHub;

  void initState() {
    super.initState();
    bajar();
  }
  void bajar() async {
    var res = await http.get(url);
    print(res.body);
    var decodedJson = jsonDecode(res.body);
    pokeHub = PokeHub.fromJson(decodedJson);
    print(pokeHub.toJson());
    setState(() {});
  }

  String _searchText = "";
  final TextEditingController _search = new TextEditingController();
  Widget _appBarTitle = new Text("Search Pokemon");
  bool _typing = false;
  final _scaffoldkey = GlobalKey<ScaffoldState>();

    _sinohay() {
    int tryo = pokeHub.pokemon
        .where((poke) =>
        poke.weaknesses.toList().toList().toString().toLowerCase().contains(_search.text.toLowerCase()))
        .length;
    if (tryo == 0) {
    _showSnackbar(context, "Oh oh, no hay resultados");
    }}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        key: _scaffoldkey,

        appBar: AppBar(
          title: _typing ? TextField(
            autofocus: true,
            controller: _search,
            onChanged: (List){
              _sinohay();
              setState(() {});
            },
          ):Text("Search by weaknesses"),
          leading: IconButton(
            icon: Icon(_typing ? Icons.done: Icons.search),
            highlightColor: Colors.lightGreen,
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
          ),      )
            : OrientationBuilder(builder: (context, orientation){
          return GridView.count(
              crossAxisCount: orientation==Orientation.portrait?3:6,
              children:
              pokeHub.pokemon.where((poke) =>poke.type.toList().toList().toString().toLowerCase().contains(_search.text.toLowerCase()))
                  .map(
                    (poke) => Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  detalles(pokemon: poke)));
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
        })
    );
  }
  _showSnackbar(BuildContext context, String texto){
    final snackBar=SnackBar(
        content: new Text(texto)
    );
    _scaffoldkey.currentState.showSnackBar(snackBar);
  }
}