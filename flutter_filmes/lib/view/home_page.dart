import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search = "";
  int _offset = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 13, 37, 63),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/imgs/tmdb.svg',
                fit: BoxFit.contain,
                height: 20,
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(children: <Widget>[
            TextField(
              autofocus: true,
              cursorColor: Color.fromARGB(255, 13, 37, 63),
              decoration: const InputDecoration(
                labelText: "Escreva o filme que quer consultar",
                labelStyle: TextStyle(color: Color.fromARGB(255, 13, 37, 63)),
                border: OutlineInputBorder(), // Borda padrão
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 13, 37, 63),
                      width: 2.0), // Cor da borda quando habilitado
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 13, 37, 63),
                      width: 2.0), // Cor da borda quando em foco
                ),
              ),
              style: TextStyle(
                  color: Color.fromARGB(255, 13, 37, 63), fontSize: 18),
              onSubmitted: (value) {
                setState(() {
                  _search = value;
                });
              },
            ),
            Expanded(
              child: FutureBuilder(
              // future: getAPI2(_search, _offset),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return _createMovieTable(context, snapshot);
                }
              },
            ))
          ]),
        ));
  }

  Widget _createMovieTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
        itemCount: _getCount(snapshot.data["data"]),
        itemBuilder: (context, index) {
          if (_search == null || index < snapshot.data["data"].length) {
            return GestureDetector(
                child: Image.network(
                  snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                  height: 300.0,
                  fit: BoxFit.cover,
                ),
                onTap: () {});
          } else {
            return Container(
              child: GestureDetector(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 70.0,
                      ),
                      Text(
                        "Carregar mais...",
                        style: TextStyle(color: Colors.white, fontSize: 22.0),
                      )
                    ]),
                onTap: () {
                  setState(() {
                    _offset += 25;
                  });
                },
              ),
            );
          }
        });
  }

  int _getCount(List data) {
    if (_search == null) {
      return data.length;
    }
    return data.length + 1;
  }
}
