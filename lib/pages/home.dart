import 'package:flutter/material.dart';
import 'package:to_do/models/Lista.dart';
import 'package:to_do/services/SharedPref.dart';
import 'dart:developer';
import 'package:to_do/util/utils.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
 
  @override
  _HomeState createState() =>  _HomeState();
}

class _HomeState extends State<Home> {
  List<Lista> listas= SharedPref.getListas();
  Lista listaSalvar;
  int indiceListaSalvar;
  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(
    content: Text('Se ha eliminado la tarea'),
    action: SnackBarAction(
      label: "Deshacer",
      onPressed: ()=>{
        _deshacerBorrado(),
      },
    ),
  );

    return Scaffold(
      appBar: AppBar( title: Text('To Do'), ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=>{
          _mostrarDialogo(context, "Titulo de la nueva lista", true,0)
        },
      ),
      body: Builder(
              builder: (contextCorrecto) =>Container(
          child: _evaluarYObtenerLista(listas, contextCorrecto, snackBar),
        ),
      ),
    );
  }


  Widget _evaluarYObtenerLista(List<Lista> listas, BuildContext contextCorrecto, SnackBar snackBar){
    if(listas== null || listas.length==0){
      return Center(
        child: Text("No hay listas, pulse el boton para añadir") 
      );
    }else{
      return ListView.builder(
        //separatorBuilder: (context,index) => Divider(color: Colors.black,thickness: 0.2,),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: listas.length,
         itemBuilder: (context, index) => _generarListTile(index, contextCorrecto, snackBar),
      );
    }
  }

  Widget _generarListTile(int index, BuildContext contextCorrecto, SnackBar snackBar){
    return Dismissible(
      confirmDismiss: (direccion) async{
        if(direccion== DismissDirection.startToEnd){
          return true;
        }else{
          log("editar nombre");
          _mostrarDialogo(contextCorrecto, "Editar titulo", false, index);
          return false;
        }
      },
      background: Util.getBackgrodundDismissible(Icons.delete, Colors.red, true),
      secondaryBackground: Util.getBackgrodundDismissible(Icons.edit, Colors.blue, false),
      key: UniqueKey(),
      onDismissed: (direccion)=>{
        log(direccion.index.toString()),
        _eliminaroEditarLista(index, contextCorrecto, snackBar, direccion),
      },
      child: ListTile(
        //leading: Text(listas[index].tareas.length.toString()),
        subtitle: listas[index].tareas.length==1?Text('${listas[index].tareas.length.toString()} tarea'): Text('${listas[index].tareas.length.toString()} tareas'),
        title: Text(listas[index].nombreLista),
        onTap: ()=>{
          irDetallesLista(index),
        },
      ),
    );
  }


  _mostrarDialogo(BuildContext _context, String texto, bool nuevo, int index){
    final myController =TextEditingController();
    if(!nuevo){
      myController.text=listas[index].nombreLista;
    }
    showDialog(
      context: _context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(texto),
          content: TextField(
            controller: myController,
          ),
          actions: [
            FlatButton(
              child: Text("Cancelar"),
              onPressed: () =>{
                //myController.dispose(),
                Navigator.pop(context, true)
              },
            ),
            FlatButton(
              child: Text(nuevo?"Crear":"Guardar"),
              onPressed: () =>{
                if(myController.text!=null && myController.text.trim()!=''){
                  if(nuevo){
                    _nuevaLista(myController),
                    Navigator.pop(context, true),
                    _renovarEstado(),
                  }else{
                    _editarTitulo(myController, index),
                    Navigator.pop(context, true),
                    _renovarEstado(),
                  }
                }else{
                   Navigator.pop(context, true),
                   _renovarEstado(),
                }
              },
            ),
          ],
        );
      } ,
    );
  }


  _nuevaLista(TextEditingController _controller){
    Lista lista= new Lista(nombreLista: _controller.text, tareas: List<Tarea>());
    SharedPref.addLista(lista);
  }

  _editarTitulo(TextEditingController _controller, int i){
    listas[i].nombreLista=_controller.text;
    SharedPref.setListas(listas);
  }

  _renovarEstado(){
    listas = SharedPref.getListas();
    setState(() {});
  }

  irDetallesLista(int index) async{
    await Navigator.pushNamed(context, "detalles", arguments: index);
    _renovarEstado();
  }


  void _deshacerBorrado() {
    listas.insert(indiceListaSalvar, listaSalvar);
    SharedPref.setListas(listas);
    _renovarEstado();
  }

  _eliminaroEditarLista(int index, BuildContext contextCorrecto, SnackBar snackBar, DismissDirection direccion) {
    if(direccion== DismissDirection.startToEnd){
      listaSalvar=listas[index];
      indiceListaSalvar=index;
      Scaffold.of(contextCorrecto).showSnackBar(snackBar);

      listas.removeAt(index);
      SharedPref.setListas(listas);
      log('eliminar lista $index');
      _renovarEstado();
    }else{
      log("editar Lista");
    }
    
  }
}