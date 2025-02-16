# Introduction

**simple_api_call** is a super simple dart package to perform api call. Its SDK is much easier to use so that you can focus on business logic. Its build on top of [dio package](https://pub.dev/packages/dio).

# Features

- Supported HTTP methods: GET, POST, PUT, PATCH, DELETE
- JSON Request Body (sets headers automatically)
- Form Data Request Body (with easy interface for single/multiple - fields and files)
- Form URL Encoded Body
- URL search params (aka URL Query)
- Request headers
- Request body
- Timeout for API Call abort
- On upload progress update handler
- On download progress update handler
- Streams feature for SSE based response

# Examples

## Example 1: Simple GET api call

```dart
import 'package:simple_api_call/simple_api_call.dart';

void main() async {
  var res = await apiCall('https://jsonplaceholder.typicode.com/todos/1');
  print(res);
}
```

**Output:**

```txt
ApiResponse(
  Ok: true
  Headers: {x-ratelimit-reset: 1739370722, x-ratelimit-limit: 1000, date: Sun, 16 Feb 2025 08:01:31 GMT, transfer-encoding: chunked, vary: Origin, Accept-Encoding, content-encoding: gzip, x-ratelimit-remaining: 999, pragma: no-cache, server: cloudflare, reporting-endpoints: heroku-nel=https://nel.heroku.com/reports?ts=1739370677&sid=e11707d5-02a7-43ef-b45e-2cf4d2036f7d&s=c4034Ntzv9xG2rv4p9jTn01XXS2WI5YBk%2BZUpEh0KUI%3D, cf-ray: 912c029eaf420da6-MRS, etag: W/"53-hfEnumeNh6YirfjyjaujcOPPT+s", connection: keep-alive, cache-control: max-age=43200, age: 5384, server-timing: cfL4;desc="?proto=TCP&rtt=256732&min_rtt=255916&rtt_var=97601&sent=5&recv=6&lost=0&retrans=0&sent_bytes=2809&recv_bytes=719&delivery_rate=14288&cwnd=252&unsent_bytes=0&cid=7168a6c4413b1290&ts=304&x=0", report-to: {"group":"heroku-nel","max_age":3600,"endpoints":[{"url":"https://nel.heroku.com/reports?ts=1739370677&sid=e11707d5-02a7-43ef-b45e-2cf4d2036f7d&s=c4034Ntzv9xG2rv4p9jTn01XXS2WI5YBk%2BZUpEh0KUI%3D"}]}, cf-cache-status: HIT, content-type: application/json; charset=utf-8, access-control-allow-credentials: true, x-powered-by: Express, alt-svc: h3=":443"; ma=86400, nel: {"report_to":"heroku-nel","max_age":3600,"success_fraction":0.005,"failure_fraction":0.05,"response_headers":["Via"]}, via: 1.1 vegur, x-content-type-options: nosniff, expires: -1}
  Status Code: 200
  Status Message: OK
  JSON: {userId: 1, id: 1, title: delectus aut autem, completed: false}
  Body: {userId: 1, id: 1, title: delectus aut autem, completed: false}
)
```

## Example 2: POST api call

```dart
import 'package:simple_api_call/simple_api_call.dart';

void main() async {
  var res = await apiCall(
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
}
```

**Output:**

```txt
res.ok: true
res.statusCode: 201
res.statusMessage: Created
res.json: {title: foo, body: bar, userId: 1, id: 201}
res.body: {title: foo, body: bar, userId: 1, id: 201}
res.headers: {x-ratelimit-reset: 1739693050, x-ratelimit-limit: 1000, date: Sun, 16 Feb 2025 08:03:50 GMT, vary: Origin, X-HTTP-Method-Override, Accept-Encoding, x-ratelimit-remaining: 999, access-control-expose-headers: Location, pragma: no-cache, server: cloudflare, location: https://jsonplaceholder.typicode.com/todos/201, reporting-endpoints: heroku-nel=https://nel.heroku.com/reports?ts=1739693030&sid=e11707d5-02a7-43ef-b45e-2cf4d2036f7d&s=8toGMSh4ryWYsHycTphGd5%2B01FspBh5NXllaidi2q1s%3D, content-length: 65, cf-ray: 912c06004b73b6c4-MRS, etag: W/"41-S72XhYKRBNSGo0mxoArJPNcK+ug", connection: keep-alive, cache-control: no-cache, server-timing: cfL4;desc="?proto=TCP&rtt=259667&min_rtt=254705&rtt_var=79955&sent=5&recv=6&lost=0&retrans=0&sent_bytes=2810&recv_bytes=809&delivery_rate=13078&cwnd=252&unsent_bytes=0&cid=af55f34cf6f28bc5&ts=580&x=0", report-to: {"group":"heroku-nel","max_age":3600,"endpoints":[{"url":"https://nel.heroku.com/reports?ts=1739693030&sid=e11707d5-02a7-43ef-b45e-2cf4d2036f7d&s=8toGMSh4ryWYsHycTphGd5%2B01FspBh5NXllaidi2q1s%3D"}]}, cf-cache-status: DYNAMIC, content-type: application/json; charset=utf-8, access-control-allow-credentials: true, x-powered-by: Express, alt-svc: h3=":443"; ma=86400, nel: {"report_to":"heroku-nel","max_age":3600,"success_fraction":0.005,"failure_fraction":0.05,"response_headers":["Via"]}, via: 1.1 vegur, x-content-type-options: nosniff, expires: -1}
res.error: null
```

## Example 3: Form Data Upload with progress updates

```dart
import 'package:simple_api_call/simple_api_call.dart';

void main() async {
  var res = await apiCall(
    'https://api.escuelajs.co/api/v1/files/upload',
    options: Options(
      method: HttpMethod.post,
      formData: FormData(
        fields: {
          'name': 'Rituraj',
          'age': ['20'],
        },
        files: {
          'file': 'pubspec.lock',
          'songs': ['music.mp3', 'tune.mp3'],
        },
      ), // files must exist
      onSendProgress: (sent, total) {
        print('Sent: $sent/$total (${(sent * 100 / total).toStringAsFixed(2)}%)');
      },
      onReceiveProgress: (sent, total) {
        print('Receive: $sent/$total (${(sent * 100 / total).toStringAsFixed(2)}%)');
      },
    ),
  );
  print(res);
}
```

**Output:**

```txt
Sent: 29/3627 (0.80%)
Sent: 76/3627 (2.10%)
Sent: 83/3627 (2.29%)
Sent: 85/3627 (2.34%)
Sent: 114/3627 (3.14%)
Sent: 160/3627 (4.41%)
Sent: 162/3627 (4.47%)
Sent: 164/3627 (4.52%)
Sent: 193/3627 (5.32%)
Sent: 305/3627 (8.41%)
Sent: 3594/3627 (99.09%)
Sent: 3596/3627 (99.15%)
Sent: 3627/3627 (100.00%)
Receive: 115/115 (100.00%)
ApiResponse(
  Ok: true
  Headers: {connection: keep-alive, x-powered-by: Express, date: Sun, 16 Feb 2025 08:04:57 GMT, access-control-allow-origin: *, reporting-endpoints: heroku-nel=https://nel.heroku.com/reports?ts=1739693097&sid=c46efe9b-d3d2-4a0c-8c76-bfafa16c5add&s=pThExivs6OFFk10FdWiMWDPpdrYPBMn2JwAw2nfMGyY%3D, content-length: 115, nel: {"report_to":"heroku-nel","max_age":3600,"success_fraction":0.005,"failure_fraction":0.05,"response_headers":["Via"]}, report-to: {"group":"heroku-nel","max_age":3600,"endpoints":[{"url":"https://nel.heroku.com/reports?ts=1739693097&sid=c46efe9b-d3d2-4a0c-8c76-bfafa16c5add&s=pThExivs6OFFk10FdWiMWDPpdrYPBMn2JwAw2nfMGyY%3D"}]}, etag: W/"73-SLAWrBZ33uCwI32OGJXhg1FCtdU", via: 1.1 vegur, content-type: application/json; charset=utf-8, server: Cowboy}
  Status Code: 201
  Status Message: Created
  JSON: {originalname: pubspec.lock, filename: b610.lock, location: https://api.escuelajs.co/api/v1/files/b610.lock}
  Body: {originalname: pubspec.lock, filename: b610.lock, location: https://api.escuelajs.co/api/v1/files/b610.lock}
)
```

## Example 4: API call with custom timeout and URL search params (query)

```dart
import 'package:simple_api_call/simple_api_call.dart';

void main() async {
  var res = await apiCall(
    'https://jsonplaceholder.typicode.com/todos',
    options: Options(
      timeout: Duration(milliseconds: 100),
      query: {'limit': '20', 'page': '1'},
    ),
  );
  print(res);
}
```

**Output:**

```txt
ApiResponse(
  Ok: false
  Headers: {}
  Error: The request connection took longer than 0:00:00.100000 and it was aborted. To get rid of this exception, try raising the RequestOptions.connectTimeout above the duration of 0:00:00.100000 or improve the response time of the server.
)
```

## Example 5: Form Url Encoded data api call

```dart
import 'package:simple_api_call/simple_api_call.dart';

void main() async {
  var res = await apiCall(
    'https://mocktarget.apigee.net/echo',
    options: Options(
      method: HttpMethod.post,
      formUrlEncoded: {'name': 'Rituraj', 'age': 30},
    ),
  );
  print(res);
}
```

**Output:**

```txt
ApiResponse(
  Ok: true
  Headers: {x-powered-by: Apigee, alt-svc: h3=":443"; ma=2592000,h3-29=":443"; ma=2592000, date: Sun, 16 Feb 2025 08:06:38 GMT, access-control-allow-origin: *, content-length: 444, etag: W/"1bc-+bZufFj37PLWVN5Lb9i9Z3e9/lE", via: 1.1 google, x-frame-options: ALLOW-FROM RESOURCE-URL, content-type: application/json; charset=utf-8, x-xss-protection: 1, x-content-type-options: nosniff}
  Status Code: 200
  Status Message: OK
  JSON: {headers: {host: mocktarget.apigee.net, user-agent: Dart/3.7 (dart:io), content-type: application/x-www-form-urlencoded, accept-encoding: gzip, content-length: 19, x-cloud-trace-context: c539756f3f0b14f63c988f6d0b6d2491/16056943780855021050, via: 1.1 google, x-forwarded-for: 223.185.63.47, 35.227.194.212, x-forwarded-proto: https, connection: Keep-Alive}, method: POST, url: /, args: {}, body: name=Rituraj&age=30}
  Body: {headers: {host: mocktarget.apigee.net, user-agent: Dart/3.7 (dart:io), content-type: application/x-www-form-urlencoded, accept-encoding: gzip, content-length: 19, x-cloud-trace-context: c539756f3f0b14f63c988f6d0b6d2491/16056943780855021050, via: 1.1 google, x-forwarded-for: 223.185.63.47, 35.227.194.212, x-forwarded-proto: https, connection: Keep-Alive}, method: POST, url: /, args: {}, body: name=Rituraj&age=30}
)
```

## Example 6: Sending JSON data in POST using body field

```dart
import 'dart:convert';

import 'package:simple_api_call/simple_api_call.dart';

void main() async {
  var res = await apiCall(
    'https://jsonplaceholder.typicode.com/todos',
    options: Options(
      method: HttpMethod.post,
      body: jsonEncode({'title': 'foo', 'body': 'bar', 'userId': 1}),
      headers: {'Content-Type': 'application/json'}
    ),
  );
  print('res.ok: ${res.ok}');
  print('res.json: ${res.json}');
}
```

**Output:**

```txt
res.ok: true
res.json: {title: foo, body: bar, userId: 1, id: 201}
```

## Example 7: Server Sent Events (SSE)

```dart
import 'package:simple_api_call/simple_api_call.dart';

void main() async {
  var res = await apiCall(
    'https://sse-fake.andros.dev/events/',
    options: Options(stream: true),
  );
  res.stream!.listen((e) {
    var msg = String.fromCharCodes(e as List<int>);
    print(msg);
  });
}
```

**Output:**

```txt
:

event: stream-open
data:
2

event: message
data: {"action": "User disconnected", "name": "Terri"}
2

event: message
data: {"action": "New message", "name": "Angelica", "text": "Up into professional six indicate. Example begin live. Shoulder pattern since.\nMission adult standard blood American. Both company occur parent better."}
2

event: message
data: {"action": "User connected", "name": "Stephen"}
...
```

# References

- **Equivalent Go Plugin:** [https://pkg.go.dev/github.com/riturajshakti/apicall](https://pkg.go.dev/github.com/riturajshakti/apicall)
- **Learning Dart by Examples:** [https://github.com/riturajshakti/learn-dart-by-examples](https://github.com/riturajshakti/learn-dart-by-examples)
- **Learning Go by Examples:** [https://github.com/riturajshakti/learn-go-by-examples](https://github.com/riturajshakti/learn-go-by-examples)
- **Learning Node by Examples:** [https://github.com/riturajshakti/learn-node-by-examples](https://github.com/riturajshakti/learn-node-by-examples)
- **Validation Plugin Node.js:** [https://www.npmjs.com/package/super-easy-validator](https://www.npmjs.com/package/super-easy-validator)
- **More Learning Resources & Code Samples:** [https://github.com/riturajshakti?tab=repositories](https://github.com/riturajshakti?tab=repositories)

# Feedback

If you like this plugin, then please add stars to this [github repository](https://github.com/riturajshakti/dart_simple_api_call). Also if you have any feedback or suggestions to add more features to this packages, don't hesitate to contact me at [riturajshakti@gmail.com](mailto:riturajshakti@gmail.com).

I hope this packages add value to your life 😀

Thankyou