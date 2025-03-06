import 'package:flutter_application_first/controller/Connection.dart';

class Marcas extends Connection{
  final int iden;
  final String codigo;
  final String nombre;
  //final String url;
  

  void marcas(){
    
  }

  Marcas({required this.iden, required this.codigo, required this.nombre});

  factory Marcas.fromJson(Map<String, dynamic> json) {
    return Marcas(
      iden: json['id'],
      codigo: json['codigo'],
      nombre: json['nombre'],
    );
  }
}