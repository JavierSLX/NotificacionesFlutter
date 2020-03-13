import 'package:flutter/material.dart';
import 'package:pushflutter/src/pages/HomePage.dart';
import 'package:pushflutter/src/pages/MensajePage.dart';
import 'package:pushflutter/src/providers/PushProvider.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //Lanza la configuracion de las notificaciones
    final provider = PushProvider();
    provider.initNotifications();

    //Escucha el stream cuando se produce la llegada de una notificacion
    provider.messages.listen((String data){
      print("Argumento push: " + data);

      //Navega a la siguiente página gracias a la navigatorkey (es necesaria debido a que este proceso se está realizando en el initState)
      navigatorKey.currentState.pushNamed("mensaje", arguments: data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Notifications',
      initialRoute: "home",
      routes: {
        "home": (BuildContext context) => HomePage(),
        "mensaje": (BuildContext context) => MensajePage(),
      },
    );
  }
}