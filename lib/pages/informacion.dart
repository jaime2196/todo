import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:to_do/i18n/Languages.dart';
import 'package:url_launcher/url_launcher.dart';


class InformacionPage extends StatefulWidget {
  const InformacionPage({Key key}) : super(key: key);
  

  @override
  _InformacionPageState createState() => _InformacionPageState();
}

class _InformacionPageState extends State<InformacionPage> {
  final fontSize=17.0;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: Text(Languages.of(context).labelInformacion),),
      body: FutureBuilder<PackageInfo>(
        future: getDatos(),
        builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot){
          if(snapshot.hasData){
            return SingleChildScrollView(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _cardDatosDev(),
                _cardDatosApp(snapshot),
              ],
              ),
            );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<PackageInfo> getDatos()async{
    return await PackageInfo.fromPlatform();
  }

  Widget _cardDatosApp(AsyncSnapshot<PackageInfo> snapshot){
    final style= TextStyle(fontSize: fontSize);
    return Card(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(height: 10),
          Text("Información de la app",style: TextStyle(fontSize: 18)),
          ListTile(
            title:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nombre de la app: '+snapshot.data.appName, style:style ,),
                Text('Nombre del paquete: '+snapshot.data.packageName, style:style),
                Text('Versión:'+snapshot.data.version, style:style),
                Text('Numero de compilación: '+snapshot.data.buildNumber, style:style),
                enlace("App desarrollada en ", "Flutter", "https://flutter.dev/", Icons.home_repair_service_outlined),
                SizedBox(height: 10,)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardDatosDev(){
    return Card(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(height: 10),
          Text("Información del desarrollador",style: TextStyle(fontSize: 18)),
          ListTile(
            title: //Center(
              /*child:*/ Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  enlace("App desarrollada por ","Jaime Señoret","https://jaimesenoret.web.app",Icons.work_outline_outlined),
                  SizedBox(height: 8),
                  enlace("Repositorio en ","Github","https://github.com/jaime2196/todo", Icons.add),
                  SizedBox(height: 8),
                  enlace("Página de ","Google Play","https://play.google.com/store/apps/details?id=app.web.jaimesenoret.to_do", Icons.play_arrow_outlined),
                  SizedBox(height: 10),
                ],
              ),
            ),
          //),
        ],
      ),
    );
  }

  Widget enlace(String texto,String textoEnlace, String direccion, IconData icon){
    return new RichText(
      text: new TextSpan(
        children: [
          WidgetSpan(
            child: Icon(icon, size: 25),
          ),
          new TextSpan(
            text: " "+texto,
            style: new TextStyle(color: Colors.black,fontSize: fontSize),
          ),
          new TextSpan(
            text: textoEnlace,
            style: new TextStyle(color: Colors.blue, fontSize: fontSize),
            recognizer: new TapGestureRecognizer()
              ..onTap = () { launch(direccion);
            },
          ),
        ],
      )
      );
  }

}