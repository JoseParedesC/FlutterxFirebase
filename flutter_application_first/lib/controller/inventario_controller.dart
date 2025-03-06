import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_first/Entidad/marcas.dart';

class marcas_controller extends Marcas{

  Future<List<Marcas>> getByCode() async {
    String url = getUrl();
    final response = await http.get(Uri.parse('$url/Marcas/Get'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((user) => Marcas.fromJson(user)).toList();
    } else {
      throw Exception('Error al cargar las Marcas');
    }
  }

}
