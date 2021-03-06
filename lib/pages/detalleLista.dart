import 'package:flutter/material.dart';
import 'package:to_do/i18n/Languages.dart';
import 'package:to_do/models/Lista.dart';

import 'package:to_do/services/SharedPref.dart';
import 'package:to_do/util/header_painter.dart';
import 'package:to_do/util/tutorialHelper.dart';

import 'package:to_do/util/utils.dart';
import 'package:tutorial/tutorial.dart';

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
  final keyInput = GlobalKey();
  final keyCheck = GlobalKey();
  final keyText = GlobalKey();
  final keyCard = GlobalKey();
  List<TutorialItens> itemTutorial = [];
  bool tutorial1=true;
  
  @override
  Widget build(BuildContext context) {
    
    final index = ModalRoute.of(context).settings.arguments;
    indice= index;
    lista= SharedPref.getLista(index);
    final myController = TextEditingController();
    final snackBar = SnackBar(
      content: Text(Languages.of(context).labelTareaEliminada),
      action: SnackBarAction(
        label: Languages.of(context).labelDeshacer,
        onPressed: ()=>{
          _deshacerBorrado(),
        },
      ),
    );

    final TextStyle style = Theme.of(context).textTheme.headline6.copyWith(
      fontSize: 20,
      fontWeight: FontWeight.normal,
      color: Colors.white
    );

    if(SharedPref.isPrimeraVez() && tutorial1){
      tutorial1=false;
      Future.delayed(Duration(milliseconds: 1000),(){
        itemTutorial.add(TutorialHelper.getAyuda(keyInput, Languages.of(context).tutorialDetalle1,ShapeFocus.square, Languages.of(context).tutorialToque));
        itemTutorial.add(TutorialHelper.getAyuda(keyCheck, Languages.of(context).tutorialDetalle2,ShapeFocus.oval, Languages.of(context).tutorialToque));
        itemTutorial.add(TutorialHelper.getAyuda(keyText, Languages.of(context).tutorialDetalle3,ShapeFocus.square, Languages.of(context).tutorialToque));
        itemTutorial.add(TutorialHelper.getAyuda(keyCard, Languages.of(context).tutorialDetalle4,ShapeFocus.square, Languages.of(context).tutorialToque));
        Tutorial.showTutorial(context, itemTutorial);
        SharedPref.setPrimeraVez(false);
      });
    }
    

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar( title: 
        Hero(
          tag: lista.id,
          child: Text(lista.nombreLista,style: style),
        )
      ),
      body: Builder(
        builder: (contextoCorrecto) => 
           _bodyScafold(myController, snackBar, contextoCorrecto)
      ),
    );
  }

  addTarea(String nombreTarea){
    
    Tarea tarea= Tarea( nombre: nombreTarea,completada: false);

    if(lista.tareas==null){
      lista.tareas = [];
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
    return CustomPaint(
      painter: HeaderPaintWaves(),
      child: Column(
        children: [
          SizedBox(height: 10),
          Card(
            elevation: 20,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                key: keyInput,
                decoration: InputDecoration(
                  hintText: Languages.of(context).labelNombreTarea
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
          ),
          SizedBox(height: 10),
          _evaluarTareas(snackBar, contextGeneral, myController),
        ],
      ),
    );
  }

  Widget _evaluarTareas(SnackBar snackBar,BuildContext contextGeneral, TextEditingController controller){
    if(SharedPref.isPrimeraVez()){
      return Expanded(
        child: ListView(
          children: [
            Card(
              key: keyCard,
              elevation: 20,
              child: ListTile(
                leading: Checkbox(key: keyCheck,value: false, onChanged: null),
                title: Text(Languages.of(context).labelNombreTarea, key:keyText),
                onTap: null
              ),
            ),
          ],
        ),
      );
    }else{
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
        return Card(
          elevation: 20,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(Languages.of(context).labelNoTareas),
            ),
          ),
        );
      }
    }
    
    
  }

  Widget _generarListTile(int indexTareas, SnackBar snackBar, BuildContext contextGeneral, TextEditingController controller){
    //log("Index de tareas: $indexTareas");
    
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
      child: Card(
        elevation: 20,
        child: ListTile(
          leading: Checkbox(value: lista.tareas[indexTareas].completada, onChanged: (nuevoValor)=>{
            cambiarEstadoTarea(indexTareas, nuevoValor)
          }),
          title: Text(lista.tareas[indexTareas].nombre),
          onTap: ()=>{
              cambiarEstadoTarea(indexTareas, !lista.tareas[indexTareas].completada)
          },
        ),
      ),
    );
    
      
    
    
  }

  eliminarTarea(int index, SnackBar snackBar, BuildContext contextGeneral){
    tareaSalvar=lista.tareas[index];
    indiceTareaSalvar=index;
    lista.tareas.removeAt(index);
    
    //Scaffold.of(contextGeneral).showSnackBar(snackBar);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    List<Lista> listas= SharedPref.getListas();
    listas.removeAt(indice);
    listas.insert(indice, lista);
    SharedPref.setListas(listas);
    _renovarEstado();
  }

  cambiarEstadoTarea(int indiceTarea, bool nuevoValor){
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