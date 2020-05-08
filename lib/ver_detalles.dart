import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:test_connect/SecondScreen.dart';
import 'POKEMON.dart';
import 'search_test.dart';
import 'nombre.dart';
import 'numero.dart';
//import 'package:test_connect/search_test.dart';

class detalles extends StatelessWidget {
  final Pokemon pokemon;
  PokeHub pokeHub;
  var prueba;
  var intento;

  detalles({this.pokemon,this.pokeHub});

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    final _scaffoldkey = GlobalKey<ScaffoldState>();

// TODO: implement build
    return Scaffold(
        key: _scaffoldkey,
        appBar: new AppBar(
          title: Text(pokemon.name),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
          automaticallyImplyLeading: false,
        ),
    backgroundColor: Colors.purple[900],
        body: SingleChildScrollView(

    child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Hero(
                    tag: "fondo",
                    child: Container(
                      height: 500.0,
                      width: 500.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage("https://www.stickpng.com/assets/images/5a0596df9cf05203c4b60445.png"),
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  height: MediaQuery.of(context).size.height / 0.1,
                  width: MediaQuery.of(context).size.width - 20,
                  left: 10.0,
                  top: MediaQuery.of(context).size.height * 0.0001,
                    child: SingleChildScrollView(
                      child: Card(
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            SizedBox(
                              height: 70.0,
                            ),
                            Hero(
                              tag: pokemon.img,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  height: 140.0,
                                  width: 140.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.contain,
                                      image: NetworkImage(pokemon.img),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              pokemon.name,
                              style: TextStyle(fontSize: 37.0),
                            ),
                            Text('Height: ${pokemon.height}'),
                            Text('Weight: ${pokemon.weight}'),
                            Text(
                              'Types: ',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: pokemon.type
                                  .map((t) => FilterChip(
                                  backgroundColor: Colors.amber[700],
                                  label: Text(t),
                                  onSelected: (b) {Navigator.push(context, MaterialPageRoute(builder: (context) => homePagess(t)));
                                  }
                              )
                              ).toList(),
                            ),
                            Text(
                              'Evolutions: ',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: pokemon.nextEvolution
                                  .map((t) => FilterChip(
                                  backgroundColor: Colors.red[800],
                                  label: Text(t.name),
                                  onSelected: (b) {}))
                                  .toList(),
                            ),
                            Text(
                              'Weakness: ',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: pokemon.weaknesses
                                  .map((t) => FilterChip(
                                  pressElevation: 10.0,
                                  backgroundColor: Colors.green[600],
                                  label: Text(t),
                                  selectedShadowColor: Colors.yellow,
                                  onSelected: (b) {Navigator.push(context, MaterialPageRoute(builder: (context) => homePagess2(t)));
                                  }
                              ),
                              )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                ),
              ],
            ),
          ),
    );
  }
}
