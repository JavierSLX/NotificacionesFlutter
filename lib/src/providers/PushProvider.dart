import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushProvider
{
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  
  //Creamos un stream para dar flujo cuando llega una notificacion
  final _notificationStreamController = StreamController<String>.broadcast();
  Stream<String> get messages => _notificationStreamController.stream;

  initNotifications()
  {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((token) {
      print("=== TOKEN ===");
      print(token);
    });

    _firebaseMessaging.configure(
      //Cuando la aplicacion se encuentra abierta
      onMessage: (Map<String, dynamic> info) async
      {
        print("=== On Message ==");
        print(info);

        //Checa donde se está corriendo la app (iOS o Android)
        String argumento = "no-data";
        if(Platform.isAndroid)
        {
          argumento = info["data"]["comida"] ?? "no-data";
        }

        //Agregamos al stream la informacion de la notificacion
        _notificationStreamController.sink.add(argumento);
      },
      //Cuando la aplicacion se abre por primera vez
      onLaunch: (Map<String, dynamic> info) async
      {
        print("=== On Launch ==");
      },
      //Cuando la aplicacion se encuentra en 2do plano
      onResume: (Map<String, dynamic> info) async
      {
        print("=== On Resume ==");
        
        final notify = info["data"]["comida"];
        
        //Agregamos al stream la informacion de la notificacion
        _notificationStreamController.sink.add(notify);
      }
    );
  }

  dispose()
  {
    _notificationStreamController?.close();
  }
}