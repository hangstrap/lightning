

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:lightning/lightning_view_contoller.dart';
import 'package:lightning/lightning_web_socket.dart';



class MyAppModule extends Module {
  MyAppModule() {
    bind(LightningViewController);
//    type(LightningViewController);
  }
}

void main() {
  
  LightingWebSocket webSocket = new LightingWebSocket();
  applicationFactory().addModule(new MyAppModule()).run();
  

}
