import 'package:unittest/unittest.dart';
import 'package:lightning/lightning_message.dart';

import 'package:jsonx/jsonx.dart' as JSON;
import 'package:jsonx/jsonx.dart' as JSON;

main(){
  

    
test("", (){
      Header h = new Header();
      h.data = new Data()..success= true;
      h.version = 2;
      
      String json = JSON.encode( h );
      print( json);
      Header out = JSON.decode( json, type: const JSON.TypeHelper<Header<Data>>().type);
      expect( out.version, equals( 2));
      expect( out.data.success, equals( true));
      
    });  
}


class Header<V> {
  V data;
  int version = 44;
}
class Data {
  bool success = false;  
  
}