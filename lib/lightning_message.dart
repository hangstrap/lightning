library lightning;

import 'package:jsonx/jsonx.dart' as JSON;

class LightingMessage <T>{
  int version;
  String type;
  T data;
  LightingMessage();
  LightingMessage.clone( LightingMessage s){
    version =s.version;
    type= s.type;
    data = s.data;    
  }
  
  factory   LightingMessage.decodeFromJson( String json){
    LightingMessage s = JSON.decode(json, type: LightingMessage);
    if( s.type ==  "401"){
      return new AuthRequestMessage.clone( s);
    }
    return s;
  }
 }

class AuthRequestMessage extends LightingMessage {
  
  String msg;
  AuthRequestMessage.clone( LightingMessage s):super.clone( s){
    msg = data;
  }
  
}

