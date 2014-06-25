import 'dart:html';
import 'package:jsonx/jsonx.dart';
import 'package:intl/intl.dart';

void main() {
  querySelector("#runQuery_id")
      ..onClick.listen( runQuery);
}

void runQuery(MouseEvent event) {

  DateTime now = new DateTime.now();
  
  String key = '***eNo1UUluHDEM_EtfYxsitVD0OU_ILc6Bokh7gMyMMd3tLIb_HraBCIKgYpW4lN6XN7utp-tleUx3y77abXlc1td72deLbQ96PT_Ivtwtr7fr3HUL8gidbQvl20ntYfw8bX_tEpJ51f1sl0Pz_rSM636Z69Py-D3Aet23l7jfF3pId0_LL1u3gJDSJ3yx0_PLEfhPn-annIL--BGB7XS2SHE8KUQdK6ZjfURV-_16uv35KptFXUzQIOX0DeDgvxxHaNbT80W2_XZIspJ7stxQvEsnndZBRbLK7EhNgSs26gKFyZBrKW10oMq1sysYT2IvhqAD3XutqTElDxGVkXvyjFSgjqmFsoCV7rVZM6HB7CPnPC16kOkNwceUMTqDax8BSzPL06toZPBKXBKocclg00ikUq2CsZv4hEFmc0huyUWUmjNl5CTcWrVOglYke3LywiCY0SGxS68Ms5HXoVisoAFJIyZHhYSug0rFmo0ApcDMLUd_zVtCIqh9os6qVWdSzCy9cJmlacmNa5p0mKKpco8Zx8ittaRTkiqqVfapWTi3HpNF6zJnrWQS5g4jjpzQsPfg-wBUVTHtEM5ga2yaHWrQySCcZgohWPx59DQqp8P7QWoi8Rul5MFpCgxJeWobs3RMy8c_UHvX5g\$'; 
  String url = "https://lightning.metconnect.co.nz/service/API/v2/lightning/query?key=${key}&from=20140624T220000-0000";

  HttpRequest request = new HttpRequest();
  request..open( "GET", url)
  ..onLoadEnd.listen( (_)=> requestComplete( request))
  ..send( '');
}

void requestComplete( HttpRequest request){
  if( request.status ==200){
    
    print( request.responseText);    
    List<Strike> strikes = decode( request.responseText, type: const TypeHelper<List<Strike>>().type);
    print( strikes.first);
    print( strikes.last);
  }else{
    print( "request failed ${request.status} '${request.statusText}'");
  }
}



class Strike{
  int timeMillis;
  DateTime
    get time => new DateTime.fromMillisecondsSinceEpoch( timeMillis, isUtc:true );

  Duration
    get ago => new DateTime.now( ).toUtc().difference(time);
  String dateTime;
  double latitude;
  double longitude;
  double amplitude;
  String direction;
  Ellipse ellipse;
  String toString() => "Strike< time=${time.toUtc()} ago=${ago.inHours} milisec = ${timeMillis} ${dateTime} ${direction} >";
}

class Ellipse{
  double major;
  double minor;
  int bearing;
}