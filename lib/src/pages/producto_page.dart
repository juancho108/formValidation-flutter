import 'dart:io';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/providers/productos_provider.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';


class ProductoPage extends StatefulWidget {

  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey     = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final productoProvider = new ProductosProvider();

  ProductoModel producto = new ProductoModel();
  bool _guardando = false;
  File foto;


  @override
  Widget build(BuildContext context) {

    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;

    if(prodData != null){
      producto = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton(),
              ]
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {

    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto'
      ),
      onSaved: (value) => producto.titulo = value,
      validator: (value){
        if (value.length<3){
          return 'Ingrese el nombre del producto';
        }else{
          return null;
        }
      },
    );

  }

  Widget _crearPrecio() {

    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio'
      ),
      onSaved: (value) => producto.valor = double.parse(value),
      validator: (value){
        if (utils.isNumeric(value)) {
          return null;
        }else{
          return 'Sólo Numeros';
        }
      }
    );


  }

  Widget _crearBoton() {

    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      textColor: Colors.white,
      color: Colors.deepPurple,
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed: (_guardando) ? null: _submit,
    );
  }

  void _submit(){

    if (!formKey.currentState.validate()) return;

    //hace el submit del form
    formKey.currentState.save();
    //cuando el form es valido hago estas cosas

    setState(() { _guardando = true; });
    
    if(producto.id == null){
      productoProvider.crearProducto(producto);
    }else{
      productoProvider.editarProducto(producto);
    }


    setState(() { _guardando = false; });
    //mostrarSnackbar('Registro Guardado');

    Fluttertoast.showToast(
        msg: "Producto Registrado",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2,
        backgroundColor: Colors.deepPurple,
        textColor: Colors.white,
        fontSize: 16.0
    );

    Navigator.pop(context);
    
  }

  Widget _crearDisponible() {

    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value)=> setState((){
        producto.disponible = value;
      }),
    );
  }


  void mostrarSnackbar(String mensaje){

    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 2000),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);

  }


  _mostrarFoto(){

    if (producto.fotoUrl != null){
      //TODO>: tengo que hacer esto
      return Container();
    }else{

      return Image(
        image: AssetImage('assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );

    }

  }


  _seleccionarFoto() async {

    foto = await ImagePicker.pickImage(
      source: ImageSource.gallery
    );

    if (foto != null){
      //limpieza
    }

    setState(() {});

  }


  _tomarFoto(){}


}