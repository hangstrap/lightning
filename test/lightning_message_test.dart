import 'package:unittest/unittest.dart';
import 'package:lightning/lightning_message.dart';


void main() {
  group("decode json", () {
    
    test("should decode auth request", (){
      String json = '{"version" : 2,"type" : "401", "data" : "please send authorisation file."}';
      AuthRequestMessage result = new LightingMessage.decodeFromJson( json);
      expect( result.version, equals(2));
      expect( result.type, equals("401"));
      expect( result.msg, equals("please send authorisation file."));
    });
    
  });
}