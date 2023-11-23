import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'basedatos.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  String titulo = "Agencia de autos Leo";
  String subtitulo = "Insertar auto";
  int _index = 0;
  int pos = 1;
  final modelo = TextEditingController();
  final marca = TextEditingController();
  final ano = TextEditingController();
  final color = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  Text("${titulo}"),
          centerTitle: true,
          elevation: 0,
        ),
        body: dinamico(),
        bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: Colors.red,
            color: Colors.brown,
            animationDuration: Duration(milliseconds: 200),
            items: [
              Icon(Icons.home_filled, color: Colors.white,),
              Icon(Icons.add, color: Colors.white,)
            ],
            onTap: (indice){
              setState(() {
                _index = indice;
              });
            }
        )
    );
  }
  Widget dinamico(){
    switch(_index){
      case 1: return ingresar();
    }
    return inicio();
  }//dinamico()

  Widget inicio(){
    return FutureBuilder(
        future: DB.mostrarTodos(),
        builder: (context, listaJSON){
          if(listaJSON.hasData){
            return ListView.builder(
                itemCount: listaJSON.data?.length,
                itemBuilder: (context, indice){
                  return ListTile(
                    title: Text("${listaJSON.data?[indice]['modelo']}"),
                    subtitle: Text("${listaJSON.data?[indice]['marca']}"),
                    trailing: IconButton(onPressed: (){
                      DB.eliminar(listaJSON.data?[indice]['id'])
                          .then((value) {
                        setState(() {
                          titulo = "Eliminado";
                        });
                      });
                    }, icon: Icon(Icons.delete)),
                    onTap: (){
                      String IdAuto = listaJSON.data?[indice]['id'];
                      actualizar(IDAuto);
                    },
                  );
                }
            );
          }
          return Center(child: CircularProgressIndicator(),);
        }
    );
  }

  Widget ingresar(){
    return ListView(
      padding: EdgeInsets.all(30),
      children: [
        Text("${subtitulo}", textAlign: TextAlign.center,),
        SizedBox(height: 5,),
        TextField(
          controller: modelo,
          decoration: InputDecoration(
              labelText: "Modelo:"
          ),
        ),
        SizedBox(height: 5,),
        TextField(
          controller: marca,
          decoration: InputDecoration(
              labelText: "Marca:"
          ),
        ),
        SizedBox(height: 5,),
        TextField(
          controller: ano,
          decoration: InputDecoration(
              labelText: "Ano:"
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 5,),
        TextField(
          controller: color,
          decoration: InputDecoration(
              labelText: "Color:"
          ),
        ),
        SizedBox(height: 10,),
        FilledButton(
            onPressed: (){
              var baseremota = FirebaseFirestore.instance;
              baseremota.collection("autos").add({
                'modelo': modelo.text,
                'marca':marca.text,
                'ano': int.parse(ano.text),
                'color': color.text,

              }).then((value){
                setState(() {
                  titulo = "Se inserto";
                });
                modelo.text = "";
                marca.text = "";
                ano.text = "";
                color.text = "";
              });
            },
            child: const Text("Ok")
        )
      ],
    );
  }

  void actualizar(String ID) async{
    final modelo = TextEditingController();
    final marca = TextEditingController();
    final ano = TextEditingController();
    final color = TextEditingController();

    var datosAutos = await DB.mostrarAutos(ID);
    if (datosAutos.isNotEmpty) {
      setState(() {
        modelo.text = datosAutos['modelo'];
        marca.text = datosAutos['marca'];
        ano.text = datosAutos['ano']toString();
        color.text = datosAutos['color'];
      });
    }
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        elevation: 5,
        builder: (builder){
          return Container(
            padding: EdgeInsets.only(top: 15, left: 30, right: 30,
                bottom: MediaQuery.of(context).viewInsets.bottom+50
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("ID: ${ID}", style: TextStyle(fontSize: 15),),
                SizedBox(height: 10,),
                TextField(
                  controller: modelo,
                  decoration: InputDecoration(
                      labelText: "Modelo:"
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: marca,
                  decoration: InputDecoration(
                      labelText: "Marca:"
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: ano,
                  decoration: InputDecoration(
                      labelText: "Ano:"
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: color,
                  decoration: InputDecoration(
                      labelText: "Color:"
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: (){
                          var JSonTemp={
                            'id': ID,
                            'modelo': modelo.text,
                            'marca':marca.text,
                             'ano': int.parse(ano.text),
                            'color': color.text,
                          };
                          DB.actualizar(JSonTemp).then((value) {
                            setState(() {
                              titul = "Se actualizo";
                              Navigator.pop(context);
                            });
                          });
                          modelo.clear();
                          marca.clear();
                          ano.clear();
                          color.clear();
                        },
                        child: Text("Actualizar")
                    ),
                    ElevatedButton(
                        onPressed: (){
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                        child: Text("Cancelar")
                    ),
                  ],
                )

              ],
            ),
          );
        }
    );
  }
}

