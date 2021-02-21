import 'package:flutter/material.dart';
import 'package:to_do/i18n/Languages.dart';
import 'package:to_do/models/Lista.dart';
import 'package:to_do/services/SharedPref.dart';
import 'package:to_do/util/tutorialHelper.dart';
import 'dart:developer';
import 'package:to_do/util/utils.dart';
import 'package:tutorial/tutorial.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
 
  @override
  _HomeState createState() =>  _HomeState();
}

class _HomeState extends State<Home> {
  List<Lista> listas= SharedPref.getListas();
  Lista listaSalvar;
  int indiceListaSalvar;
  List<TutorialItens> itens = [];
  final keyFAB = GlobalKey();
  bool tutorial=true;
  
  @override
  Widget build(BuildContext context) {
    itens.add(TutorialHelper.getAyuda(keyFAB,"Pulse en el botón para crear su primera lista.", ShapeFocus.oval),);
    
  
    final snackBar = SnackBar(
      content: Text(Languages.of(context).labelTareaEliminada),
      action: SnackBarAction(
        label: Languages.of(context).labelDeshacer,
        onPressed: ()=>{
          _deshacerBorrado(),
        },
      ),
    );

    if(SharedPref.isPrimeraVez() && tutorial){
      tutorial=false;
      Future.delayed(Duration(milliseconds: 3000),(){
        Tutorial.showTutorial(context, itens);
      });
    }
    

    return Scaffold(
      appBar: _crearAppBar(),
      floatingActionButton: FloatingActionButton(
        key: keyFAB,
        child: Icon(Icons.add),
        onPressed: ()=>{
          _mostrarDialogo(context, Languages.of(context).labelNuevaLista, true,0)
        },
      ),
      body: Builder(
              builder: (contextCorrecto) =>Container(
          child: _evaluarYObtenerLista(listas, contextCorrecto, snackBar),
        ),
      ),
    );
    
  }

  Widget _crearAppBar(){
    return AppBar(
        title: Text(Languages.of(context).appName),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {Languages.of(context).labelOpciones, Languages.of(context).labelInformacion}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      );
  }

  void handleClick(String value)async {
    if(Languages.of(context).labelOpciones==value){
      await Navigator.pushNamed(context, "opciones");
      setState(() {
        
      });
    }else if(Languages.of(context).labelInformacion==value){
      log("informacion");
    }
}


  Widget _evaluarYObtenerLista(List<Lista> listas, BuildContext contextCorrecto, SnackBar snackBar){
    if(listas== null || listas.length==0){
      return Center(
        child: Text(Languages.of(context).labelNoListas) 
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
    final TextStyle style = Theme.of(context).textTheme.headline6.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.normal,
    );

    return Dismissible(
      confirmDismiss: (direccion) async{
        if(direccion== DismissDirection.startToEnd){
          return true;
        }else{
          //log("editar nombre");
          _mostrarDialogo(contextCorrecto, Languages.of(context).labelEditarTitulo, false, index);
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
      child:  ListTile(
          //leading: Text(listas[index].tareas.length.toString()),
          subtitle: listas[index].tareas.length==1?Text('${listas[index].tareas.length.toString()} ${Languages.of(context).labeltarea}'): Text('${listas[index].tareas.length.toString()} ${Languages.of(context).labelTareas}'),
          title: Hero(
            tag: listas[index].id,
            child: Text(listas[index].nombreLista,style: style,)),
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
            autofocus: true,
            controller: myController,
          ),
          actions: [
            FlatButton(
              child: Text(Languages.of(context).labelCancelar),
              onPressed: () =>{
                //myController.dispose(),
                Navigator.pop(context, true)
              },
            ),
            FlatButton(
              child: Text(nuevo?Languages.of(context).labelCrear:Languages.of(context).labelGuardar),
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
    Lista lista= new Lista(nombreLista: _controller.text, tareas: List<Tarea>(), id: DateTime.now().millisecondsSinceEpoch);
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
      //log('eliminar lista $index');
      _renovarEstado();
    }
    
  }

  
}