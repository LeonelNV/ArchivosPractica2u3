import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
var baseRemota = FirebaseFirestore.instance;
class DB{
  static Future insertar(Map<String, dynamic> autos) async{
    return await baseRemota.collection("autos").add(autos);
  }

  static Future<List> mostrarTodos() async{
    List temp = [];
    var query = await baseRemota.collection("autos").get();
    query.docs.forEach((element) {
      Map<String, dynamic> dataTemp = element.data();
      dataTemp.addAll({'id':element.id});
      temp.add(dataTemp);
    });
    return temp;
  }

  static Future eliminar(String id) async{
    return await baseRemota.collection("autos")
        .doc(id).delete();
  }

  static Future actualizar(Map<String, dynamic> autos) async{
    String idActualizar = autos['id'];
    autos.remove('id');
    return await baseRemota.collection("autos")
        .doc(idActualizar).update(autos);
  }

  static Future<Map<String, dynamic>> mostrarAutos(String id) async {
    var doc = await baseRemota.collection("autos").doc(id).get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data()!;
      data.addAll({'id': doc.id});
      return data;
    } else {
      return {};
    }
  }




}