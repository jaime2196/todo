import 'package:flutter/material.dart';
import 'package:to_do/models/Lista.dart';

import 'package:to_do/services/SharedPref.dart';
import 'dart:developer';
import 'package:to_do/util/utils.dart';

class DetalleLista extends StatefulWidget {
  DetalleLista({Key key}) : super(key: key);
  
  @override
  _DetalleListaState createState() => _DetalleListaState();
}

class _DetalleListaState extends State<DetalleLista> {
  Lista lista;
  int indice;
  Tarea tareaSalvar;
  int indiceTareaSalvar;
  
  @override
  Widget build(BuildContext context) {
    
    final index = ModalRoute.of(context).settings.arguments;
    indice= index;
    lista= SharedPref.getLista(index);
    final myController = TextEditingController();
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
      appBar: AppBar( title: Text(lista.nombreLista)),
      body: Builder(
        builder: (contextoCorrecto) => 
           _bodyScafold(myController, snackBar, contextoCorrecto)
      ),
    );
  }

  addTarea(String nombreTarea){
    
    Tarea tarea= Tarea( nombre: nombreTarea,completada: false);

    if(lista.tareas==null){
      lista.tareas = new List<Tarea>();
    }
    lista.tareas.add(tarea);
    List<Lista> listas= SharedPref.getListas();
    listas.removeAt(indice);
    listas.insert(indice, lista);
    SharedPref.setListas(listas);
    _renovarEstado();
  }

  _renovarEstado(){
    lista=SharedPref.getLista(indice);
    setState(() {

    });
  }

  Widget _bodyScafold(TextEditingController myController, SnackBar snackBar, BuildContext contextGeneral){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Nombre de la tarea'
            ),
            controller: myController,
            onSubmitted: (value) =>{
              if(value!=null && value.length!=0){
                addTarea(value),
                myController.clear(),
              }
            },
          ),
        ),
        SizedBox(height: 10),
        _evaluarTareas(snackBar, contextGeneral, myController),
      ],
    );
  }

  Widget _evaluarTareas(SnackBar snackBar,BuildContext contextGeneral, TextEditingController controller){
    if(lista.tareas!=null && lista.tareas.length!=0){
      return Expanded(
              child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          //separatorBuilder: (context,index) => Divider(color: Colors.black,thickness: 0.2,),
          itemCount: lista.tareas!=null?lista.tareas.length:0,
          itemBuilder: (context, indexTareas) => _generarListTile(indexTareas, snackBar, contextGeneral,controller)
    ),
      );
    }else{
      return Center(
        child: Text("No hay tareas"),
      );
    }
    
  }

  Widget _generarListTile(int indexTareas, SnackBar snackBar, BuildContext contextGeneral, TextEditingController controller){
    log("Index de tareas: $indexTareas");
    return Dismissible(
      confirmDismiss: (direccion) async{
        if(direccion== DismissDirection.startToEnd){
          return true;
        }else{
          _editarTarea(indexTareas, controller);
          //_mostrarDialogo(contextCorrecto, "Editar titulo", false, index);
          return true;
        }
      },
      background: Util.getBackgrodundDismissible(Icons.delete, Colors.red, true),
      secondaryBackground: Util.getBackgrodundDismissible(Icons.edit, Colors.blue, false),
      onDismissed: (direccion)=>{
        if(direccion== DismissDirection.startToEnd){
          eliminarTarea(indexTareas, snackBar, contextGeneral),
        }
        
      },
      key: UniqueKey(),
      child: ListTile(
        leading: Checkbox(value: lista.tareas[indexTareas].completada, onChanged: (nuevoValor)=>{
          cambiarEstadoTarea(indexTareas, nuevoValor)
        }),
        title: Text(lista.tareas[indexTareas].nombre),
        onTap: ()=>{
            cambiarEstadoTarea(indexTareas, !lista.tareas[indexTareas].completada)
        },
      ),
    );
  }

  eliminarTarea(int index, SnackBar snackBar, BuildContext contextGeneral){
    tareaSalvar=lista.tareas[index];
    indiceTareaSalvar=index;
    lista.tareas.removeAt(index);
    Scaffold.of(contextGeneral).showSnackBar(snackBar);

    List<Lista> listas= SharedPref.getListas();
    listas.removeAt(indice);
    listas.insert(indice, lista);
    SharedPref.setListas(listas);
    _renovarEstado();
  }

  cambiarEstadoTarea(int indiceTarea, bool nuevoValor){
    log("Indice de listas: $indice , indice de tareas $indiceTarea");
    lista.tareas[indiceTarea].completada=nuevoValor;
    
    List<Lista> listas= SharedPref.getListas();
    listas.removeAt(indice);
    listas.insert(indice, lista);
    SharedPref.setListas(listas);
    _renovarEstado();
  }

  void _deshacerBorrado() {
    lista.tareas.insert(indiceTareaSalvar, tareaSalvar);

    List<Lista> listas= SharedPref.getListas();
    listas.removeAt(indice);
    listas.insert(indice, lista);
    SharedPref.setListas(listas);

    _renovarEstado();
  }

  void _editarTarea(int indexTareas, TextEditingController controller){
    controller.text=lista.tareas[indexTareas].nombre;

    lista.tareas.removeAt(indexTareas);
    List<Lista> listas= SharedPref.getListas();
    listas.removeAt(indice);
    listas.insert(indice, lista);
    SharedPref.setListas(listas);
    //_renovarEstado();
  }
}