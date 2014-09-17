import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:lightning/lightning_view_contoller.dart';
import 'package:logging/logging.dart';


class MyAppModule extends Module {

  MyAppModule() {
   bind(LightningViewController);
  }
}

void main() {

  Logger.root.level = Level.FINEST;
  Logger.root.onRecord.listen((LogRecord r) {
    print(r.message);
  });
  applicationFactory().addModule(new MyAppModule()).run();


}

