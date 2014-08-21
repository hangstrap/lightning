library lightning_messages;

import 'package:jsonx/jsonx.dart' as JSON;
import 'package:lightning/strike.dart';

LightingMessage decodeLightingMessageFromJson(String json) {
  Map result = JSON.decode(json);
  switch (result[ 'type']) {
    case "401":
      return new RequireAuthMessage();
    case "auth":
      return JSON.decode( json, type: const JSON.TypeHelper<AuthResponseMessage>().type);
    case "status":
      return JSON.decode( json, type: const JSON.TypeHelper<StatusMessage>().type);
    case "lightning":
      return JSON.decode( json, type: const JSON.TypeHelper<StrikeMessage>().type);
  }
  return null;
}

String encodeLightingMessageToJson( LightingMessage msg){
  return JSON.encode( msg);
}


class LightingMessage<T> {
  int version;
  String type ;
  T data;
}

class RequireAuthMessage extends LightingMessage<AuthRequired> {
  RequireAuthMessage();
}
class AuthDocMessage extends LightingMessage<String> {

  AuthDocMessage.create(String key){
    version =2;
    type ="auth";
    data = key;
  }
}
class AuthRequired{
  
}
class AuthResponseMessage extends LightingMessage<Success> 
{
  bool get authSuccess => data.success;
}
class Success {
  bool success;
}

class StatusMessage extends LightingMessage<Status> 
{
  String get status => data.status;
  bool get ok=> status== 'ok';
}
class Status{
  String status;
  int since;
}

class StrikeMessage extends LightingMessage<Strike>{
  
}