library  lightning;

import 'package:angular/angular.dart';
import 'package:lightning/strike.dart';

@Controller(selector: '[current-strikes]', publishAs: 'lightingViewController')
class LightningViewController {

  List currentStrikes = [new Strike.createWithCurrentTime(), new Strike.createWithCurrentTime()];
  

  LightningViewController() {
//  currentStrikes = [new Strike.createWithCurrentTime(), new Strike.createWithCurrentTime()];
  }
  
  void addStrike(){
    currentStrikes.add(  new Strike.createWithCurrentTime());
  }
  
}

