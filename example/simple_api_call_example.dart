import 'dart:convert';

import 'package:simple_api_call/simple_api_call.dart';

void main() async {
  // ! Simple GET api call
  var res = await apiCall('https://jsonplaceholder.typicode.com/todos/1');
  print(res);

  // ! POST api call
  res = await apiCall(
    'https://jsonplaceholder.typicode.com/todos',
    options: Options(
      method: HttpMethod.post,
      json: {'title': 'foo', 'body': 'bar', 'userId': 1},
    ),
  );
  print('res.ok: ${res.ok}');
  print('res.statusCode: ${res.statusCode}');
  print('res.statusMessage: ${res.statusMessage}');
  print('res.json: ${res.json}');
  print('res.body: ${res.body}');
  print('res.headers: ${res.headers}');
  print('res.error: ${res.error}');

  // ! Form Data Upload with progress updates
  res = await apiCall(
    'https://api.escuelajs.co/api/v1/files/upload',
    options: Options(
      method: HttpMethod.post,
      formData: FormData(
        fields: {'name': 'Rituraj', 'age': ['20']},
        files: {'file': 'pubspec.lock', 'songs': ['music.mp3', 'tune.mp3']},
      ), // files must exist
      onSendProgress:(sent, total) {
        print('Sent: $sent/$total (${(sent * 100 / total).toStringAsFixed(2)}%)');
      },
      onReceiveProgress:(sent, total) {
        print('Receive: $sent/$total (${(sent * 100 / total).toStringAsFixed(2)}%)');
      },
    ),
  );
  print(res);

  // ! API call with custom timeout and URL search params (query)
  res = await apiCall(
    'https://jsonplaceholder.typicode.com/todos',
    options: Options(
      timeout: Duration(milliseconds: 100),
      query: {'limit': '20', 'page': '1'},
    ),
  );
  print(res);

  // ! Form Url Encoded data api call
  res = await apiCall(
    'https://mocktarget.apigee.net/echo',
    options: Options(
      method: HttpMethod.post,
      formUrlEncoded: {'name': 'Rituraj', 'age': 30},
    ),
  );
  print(res);

  // ! Sending JSON data in POST using body field
  res = await apiCall(
    'https://jsonplaceholder.typicode.com/todos',
    options: Options(
      method: HttpMethod.post,
      body: jsonEncode({'title': 'foo', 'body': 'bar', 'userId': 1}),
      headers: {'Content-Type': 'application/json'}
    ),
  );
  print('res.ok: ${res.ok}');
  print('res.json: ${res.json}');

  // ! Server Sent Events (SSE)
  res = await apiCall(
    'https://sse-fake.andros.dev/events/',
    options: Options(stream: true),
  );
  res.stream!.listen((e) {
    var msg = String.fromCharCodes(e as List<int>);
    print(msg);
  });
}
