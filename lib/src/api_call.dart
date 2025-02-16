import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:mime/mime.dart';

/// A class for form data request body
///
/// e.g.
/// ```dart
/// var formData = FormData(
///   fields: {
///     'name': 'Raj',
///     'age': '30',
///     'skills': ['Dart', 'Flutter'],
///   },
///   files: {
///     'songs': ['music.mp3', 'tune.mp3'],
///     'image': '../assets/nature.png',
///   },
/// );
/// ```
class FormData {
  /// It contains the key-value pairs of form data fields. Here value can be either `String` or `List<String>`
  Map<String, Object> fields;

  /// It contains the key-value pairs of form data files. Here value can be either `String` or `List<String>`. This String is the path of the file which must exist.
  Map<String, Object> files;

  FormData({this.fields = const {}, this.files = const {}}) {
    if (fields.entries.any((e) => e.value is! String && e.value is! List<String>)) {
      throw 'All entries in FormData fields must be either String or List<String>';
    }
    if (files.entries.any((e) => e.value is! String && e.value is! List<String>)) {
      throw 'All entries in FormData files must be either String or List<String>';
    }
  }

  /// Readable string representation of `FormData`
  @override
  String toString() {
    return 'FormData(fields: $fields, fields: $files)';
  }
}

/// The list of supported HTTP methods
///
/// e.g.
/// ```dart
/// var method = HttpMethod.get;
/// method = HttpMethod.fromString('get');
/// ```
enum HttpMethod {
  get,
  post,
  put,
  patch,
  delete;

  /// Returns the HTTP methods in all uppercase
  String get upcase => name.toUpperCase();

  /// To create HttpMethod from the string. The input string is case insensitive
  ///
  /// e.g.
  /// ```dart
  /// var method = HttpMethod.fromString('POST');
  /// ```
  factory HttpMethod.fromString(String method) {
    method = method.toLowerCase();
    return switch (method) {
      'post' => HttpMethod.post,
      'put' => HttpMethod.put,
      'patch' => HttpMethod.patch,
      'delete' => HttpMethod.delete,
      'get' || _ => HttpMethod.get,
    };
  }
}

/// Contains request data and other metadata fields required for API call
class Options {
  /// (Optional) Http Method of API call. Default value is `HttpMethod.get`
  final HttpMethod method;

  /// (Optional) Timeout to abort the api call. If `null`, it assumes infinite as timeout. Default value is `null`.
  final Duration? timeout;

  /// (Optional) Form Data field for request body.
  ///
  /// e.g.
  /// ```dart
  /// var formData = FormData(
  ///   fields: {
  ///     'name': 'Raj',
  ///     'age': '30',
  ///     'skills': ['Dart', 'Flutter'],
  ///   },
  ///   files: {
  ///     'songs': ['music.mp3', 'tune.mp3'],
  ///     'image': '../assets/nature.png',
  ///   },
  /// );
  /// ```
  final FormData? formData;

  /// (Optional) Url search params (URL query)
  final Map<String, String>? query;

  /// Request headers (Optional)
  final Map<String, String>? headers;

  /// (Optional) Form URL Encoded data for request body
  final Map<String, Object>? formUrlEncoded;

  /// (Optional) Handler to perform action while uploading the data.
  /// 
  /// `sent` is the amount of bytes which are already uploaded.
  /// 
  /// `total` is the total amount of bytes to be uploaded.
  final void Function(int sent, int total)? onSendProgress;

  /// (Optional) Handler to perform action while receiving/downloading the data.
  /// 
  /// `received` is the amount of bytes which are already downloaded.
  /// 
  /// `total` is the total amount of bytes to be downloaded.
  final void Function(int received, int total)? onReceiveProgress;

  /// (Optional) JSON data for request body.
  /// 
  /// It automatically sets the json header
  final Object? json;

  /// (Optional) Data for request body
  final Object? body;

  /// (Optional) Determines if the response is a continuous stream of data.
  /// 
  /// Its generally used in SSE (Server Sent Events).
  /// 
  /// Default value is `false`
  final bool stream;

  const Options({
    this.method = HttpMethod.get,
    this.json,
    this.body,
    this.formData,
    this.formUrlEncoded,
    this.query,
    this.headers,
    this.onSendProgress,
    this.onReceiveProgress,
    this.timeout,
    this.stream = false,
  });

  /// Readable string representation of `Options` data
  @override
  String toString() {
    var message = 'Request(\n';
    message += '  Method: ${method.upcase},\n';
    if (json != null) message += '  JSON: $json,\n';
    if (body != null) message += '  Body: $body\n';
    if (formData != null) message += '  FormData: $formData\n';
    if (formUrlEncoded != null) message += '  FormUrlEncoded: $formUrlEncoded\n';
    if (query != null) message += '  Query: $query\n';
    if (headers != null) message += '  Headers: $headers\n';
    if (timeout != null) message += '  Timeout: $timeout\n';
    message += ')';
    return message;
  }
}

/// Contains the Api Call response data
class ApiResponse {
  /// Response Headers
  /// 
  /// Its a key-value pairs. Here value can be either `String` or `List<String>`
  Map<String, Object> headers;

  /// The status code of the response
  int? statusCode;

  /// The status message of the response
  String? statusMessage;

  /// Contains error message if API call fails
  String? error;

  /// Contains The JSON body, if the response body is a JSON
  Object? json;

  /// The raw body of the API response
  Object? body;

  /// The stream of the response body.
  /// 
  /// It will be present only if `stream` is `true`, in the given Options provided earlier
  Stream? stream;

  /// Its is a getter to easily check if the response was ok.
  /// 
  /// It is true if response status code satisfies this condition:
  /// 
  /// ```
  /// 200 <= statusCode <= 299
  /// ```
  bool get ok => statusCode != null && statusCode! >= 200 && statusCode! <= 299;

  ApiResponse({
    required this.headers,
    this.json,
    this.body,
    this.statusCode,
    this.statusMessage,
    this.error,
    this.stream,
  });

  /// Readable string representation of `ApiResponse` data
  @override
  String toString() {
    var message = 'ApiResponse(\n';
    message += '  Ok: $ok\n';
    message += '  Headers: $headers\n';
    if (statusCode != null) message += '  Status Code: $statusCode\n';
    if (statusMessage != null) message += '  Status Message: $statusMessage\n';
    if (json != null) message += '  JSON: $json\n';
    if (body != null) message += '  Body: $body\n';
    if (error != null) message += '  Error: $error\n';
    message += ')';
    return message;
  }
}

/// Makes an API call to the specified `url` as per the given options.
///
/// This function sends an HTTP request to the provided `url` and returns
/// the response wrapped in an `ApiResponse` object. It allows customization
/// of the request through the optional `options` parameter.
///
/// ### Parameters:
/// - `url`: The endpoint URL to which the API request is sent.
/// - `options`: Optional configuration for the request, such as headers,
///   query parameters, timeout, etc. Defaults to an empty `Options(method: HttpMethod.get)` object.
///
/// ### Returns:
/// A `Future` that completes with an `ApiResponse` object containing:
/// - The response data (if the request is successful).
/// - Error message (if the request fails).
///
/// ### Example 1: Simple GET api call
/// 
/// ```dart
/// var res = await apiCall('https://jsonplaceholder.typicode.com/todos/1');
/// print(res);
/// ```
/// 
/// **Output:**
/// ```txt
/// ApiResponse(
///   Ok: true
///   Headers: {x-ratelimit-reset: 1739370722, x-ratelimit-limit: 1000, date: Sun, 16 Feb 2025 07:15:03 GMT, transfer-encoding: chunked, vary: Origin, Accept-Encoding, content-encoding: gzip, x-ratelimit-remaining: 999, pragma: no-cache, server: cloudflare, reporting-endpoints: heroku-nel=https://nel.heroku.com/reports?ts=1739370677&sid=e11707d5-02a7-43ef-b45e-2cf4d2036f7d&s=c4034Ntzv9xG2rv4p9jTn01XXS2WI5YBk%2BZUpEh0KUI%3D, cf-ray: 912bbe898f4ce165-MRS, etag: W/"53-hfEnumeNh6YirfjyjaujcOPPT+s", connection: keep-alive, cache-control: max-age=43200, age: 2596, server-timing: cfL4;desc="?proto=TCP&rtt=275810&min_rtt=262832&rtt_var=88203&sent=5&recv=7&lost=0&retrans=0&sent_bytes=2810&recv_bytes=719&delivery_rate=12063&cwnd=223&unsent_bytes=0&cid=5ff42c7a50985390&ts=324&x=0", report-to: {"group":"heroku-nel","max_age":3600,"endpoints":[{"url":"https://nel.heroku.com/reports?ts=1739370677&sid=e11707d5-02a7-43ef-b45e-2cf4d2036f7d&s=c4034Ntzv9xG2rv4p9jTn01XXS2WI5YBk%2BZUpEh0KUI%3D"}]}, cf-cache-status: HIT, content-type: application/json; charset=utf-8, access-control-allow-credentials: true, x-powered-by: Express, alt-svc: h3=":443"; ma=86400, nel: {"report_to":"heroku-nel","max_age":3600,"success_fraction":0.005,"failure_fraction":0.05,"response_headers":["Via"]}, via: 1.1 vegur, x-content-type-options: nosniff, expires: -1}
///   Status Code: 200
///   Status Message: OK
///   JSON: {userId: 1, id: 1, title: delectus aut autem, completed: false}
///   Body: {userId: 1, id: 1, title: delectus aut autem, completed: false}
///)
/// ```
/// 
/// ### Example 2: POST api call
/// 
/// ```dart
/// res = await apiCall(
///   'https://jsonplaceholder.typicode.com/todos',
///   options: Options(
///     method: HttpMethod.post,
///     json: {'title': 'foo', 'body': 'bar', 'userId': 1},
///   ),
/// );
/// print('res.ok: ${res.ok}');
/// print('res.statusCode: ${res.statusCode}');
/// print('res.statusMessage: ${res.statusMessage}');
/// print('res.json: ${res.json}');
/// print('res.body: ${res.body}');
/// print('res.headers: ${res.headers}');
/// print('res.error: ${res.error}');
/// ```
/// 
/// **Output:**
/// 
/// ```txt
/// res.ok: true
/// res.statusCode: 201
/// res.statusMessage: Created
/// res.json: {title: foo, body: bar, userId: 1, id: 201}
/// res.body: {title: foo, body: bar, userId: 1, id: 201}
/// res.headers: {x-ratelimit-reset: 1739690470, x-ratelimit-limit: 1000, date: Sun, 16 Feb 2025 07:20:47 GMT, vary: Origin, X-HTTP-Method-Override, Accept-Encoding, x-ratelimit-remaining: 999, access-control-expose-headers: Location, pragma: no-cache, server: cloudflare, location: https://jsonplaceholder.typicode.com/todos/201, reporting-endpoints: heroku-nel=https://nel.heroku.com/reports?ts=1739690447&sid=e11707d5-02a7-43ef-b45e-2cf4d2036f7d&s=XjgxrdvNN77WuG%2FKJaG8Ak0UcXg20np1rZx0c%2F5lsdw%3D, content-length: 65, cf-ray: 912bc6f0f96ae1d0-MRS, etag: W/"41-S72XhYKRBNSGo0mxoArJPNcK+ug", connection: keep-alive, cache-control: no-cache, server-timing: cfL4;desc="?proto=TCP&rtt=273148&min_rtt=271947&rtt_var=104383&sent=5&recv=6&lost=0&retrans=0&sent_bytes=2811&recv_bytes=809&delivery_rate=13318&cwnd=251&unsent_bytes=0&cid=125845bdc8fbdb1b&ts=656&x=0", report-to: {"group":"heroku-nel","max_age":3600,"endpoints":[{"url":"https://nel.heroku.com/reports?ts=1739690447&sid=e11707d5-02a7-43ef-b45e-2cf4d2036f7d&s=XjgxrdvNN77WuG%2FKJaG8Ak0UcXg20np1rZx0c%2F5lsdw%3D"}]}, cf-cache-status: DYNAMIC, content-type: application/json; charset=utf-8, access-control-allow-credentials: true, x-powered-by: Express, alt-svc: h3=":443"; ma=86400, nel: {"report_to":"heroku-nel","max_age":3600,"success_fraction":0.005,"failure_fraction":0.05,"response_headers":["Via"]}, via: 1.1 vegur, x-content-type-options: nosniff, expires: -1}
/// res.error: null
/// ```
/// ### Example 3: Form Data Upload with progress updates
/// 
/// ```dart
/// var res = await apiCall(
///   'https://api.escuelajs.co/api/v1/files/upload',
///   options: Options(
///     method: HttpMethod.post,
///     formData: FormData(
///       fields: {'name': 'Rituraj', 'age': ['20']},
///       files: {'file': 'pubspec.lock', 'songs': ['music.mp3', 'tune.mp3']},
///     ), // files must exist
///     onSendProgress:(sent, total) {
///       print('Sent: $sent/$total (${(sent * 100 / total).toStringAsFixed(2)}%)');
///     },
///     onReceiveProgress:(sent, total) {
///       print('Receive: $sent/$total (${(sent * 100 / total).toStringAsFixed(2)}%)');
///     },
///   ),
/// );
/// print(res);
/// ```
/// 
/// **Output:**
/// 
/// ```txt
/// Sent: 29/3627 (0.80%)
/// Sent: 76/3627 (2.10%)
/// Sent: 83/3627 (2.29%)
/// Sent: 85/3627 (2.34%)
/// Sent: 114/3627 (3.14%)
/// Sent: 160/3627 (4.41%)
/// Sent: 162/3627 (4.47%)
/// Sent: 164/3627 (4.52%)
/// Sent: 193/3627 (5.32%)
/// Sent: 305/3627 (8.41%)
/// Sent: 3594/3627 (99.09%)
/// Sent: 3596/3627 (99.15%)
/// Sent: 3627/3627 (100.00%)
/// Receive: 115/115 (100.00%)
/// ApiResponse(
///   Ok: true
///   Headers: {connection: keep-alive, x-powered-by: Express, date: Sun, 16 Feb 2025 07:32:34 GMT, access-control-allow-origin: *, reporting-endpoints: heroku-nel=https://nel.heroku.com/reports?ts=1739691154&sid=c46efe9b-d3d2-4a0c-8c76-bfafa16c5add&s=apdZjJfRbz1LuU6zwa%2Frp5SCRl6oKtamUnSDbpD7XQo%3D, content-length: 115, nel: {"report_to":"heroku-nel","max_age":3600,"success_fraction":0.005,"failure_fraction":0.05,"response_headers":["Via"]}, report-to: {"group":"heroku-nel","max_age":3600,"endpoints":[{"url":"https://nel.heroku.com/reports?ts=1739691154&sid=c46efe9b-d3d2-4a0c-8c76-bfafa16c5add&s=apdZjJfRbz1LuU6zwa%2Frp5SCRl6oKtamUnSDbpD7XQo%3D"}]}, etag: W/"73-1JcWeVg6NkoEkXmerMyEq+GNFAw", via: 1.1 vegur, content-type: application/json; charset=utf-8, server: Cowboy}
///   Status Code: 201
///   Status Message: Created
///   JSON: {originalname: pubspec.lock, filename: 1591.lock, location: https://api.escuelajs.co/api/v1/files/1591.lock}
///   Body: {originalname: pubspec.lock, filename: 1591.lock, location: https://api.escuelajs.co/api/v1/files/1591.lock}
/// )
/// ```
/// 
/// ### Example 4: API call with custom timeout and URL search params (query)
/// 
/// ```dart
/// var res = await apiCall(
///   'https://jsonplaceholder.typicode.com/todos',
///   options: Options(
///     timeout: Duration(milliseconds: 100),
///     query: {'limit': '20', 'page': '1'},
///   ),
/// );
/// print(res);
/// ```
/// 
/// **Output:**
/// 
/// ```txt
/// ApiResponse(
///   Ok: false
///   Headers: {}
///   Error: The request connection took longer than 0:00:00.100000 and it was aborted. To get rid of this exception, try raising the RequestOptions.connectTimeout above the duration of 0:00:00.100000 or improve the response time of the server.
/// )
/// ```
/// 
/// ### Example 5: Form Url Encoded data api call
/// 
/// ```dart
/// var res = await apiCall(
///   'https://mocktarget.apigee.net/echo',
///   options: Options(
///     method: HttpMethod.post,
///     formUrlEncoded: {'name': 'Rituraj', 'age': 30},
///     timeout: Duration(milliseconds: 10),
///   ),
/// );
/// print(res);
/// ```
/// 
/// **Output:**
/// 
/// ```txt
/// ApiResponse(
///   Ok: true
///   Headers: {x-powered-by: Apigee, alt-svc: h3=":443"; ma=2592000,h3-29=":443"; ma=2592000, date: Sun, 16 Feb 2025 07:41:39 GMT, access-control-allow-origin: *, content-length: 441, etag: W/"1b9-WdGJtTc3EMBjFmBo/nWQS/mm5pY", via: 1.1 google, x-frame-options: ALLOW-FROM RESOURCE-URL, content-type: application/json; charset=utf-8, x-xss-protection: 1, x-content-type-options: nosniff}
///   Status Code: 200
///   Status Message: OK
///   JSON: {headers: {host: mocktarget.apigee.net, user-agent: Dart/3.7 (dart:io), content-type: application/x-www-form-urlencoded, accept-encoding: gzip, content-length: 19, x-cloud-trace-context: 6271bbc1a5430dfa12ebbb3b55070bc1/71101670834545451, via: 1.1 google, x-forwarded-for: 223.185.63.47, 35.227.194.212, x-forwarded-proto: https, connection: Keep-Alive}, method: POST, url: /, args: {}, body: name=Rituraj&age=30}
///   Body: {headers: {host: mocktarget.apigee.net, user-agent: Dart/3.7 (dart:io), content-type: application/x-www-form-urlencoded, accept-encoding: gzip, content-length: 19, x-cloud-trace-context: 6271bbc1a5430dfa12ebbb3b55070bc1/71101670834545451, via: 1.1 google, x-forwarded-for: 223.185.63.47, 35.227.194.212, x-forwarded-proto: https, connection: Keep-Alive}, method: POST, url: /, args: {}, body: name=Rituraj&age=30}
/// )
/// ```
/// 
/// ### Example 6: Sending JSON data in POST using body field
/// 
/// ```dart
/// res = await apiCall(
///   'https://jsonplaceholder.typicode.com/todos',
///   options: Options(
///     method: HttpMethod.post,
///     body: jsonEncode({'title': 'foo', 'body': 'bar', 'userId': 1}),
///     headers: {'Content-Type': 'application/json'}
///   ),
/// );
/// print('res.ok: ${res.ok}');
/// print('res.json: ${res.json}');
/// ```
/// 
/// **Output:**
/// 
/// ```txt
/// res.ok: true
/// res.json: {title: foo, body: bar, userId: 1, id: 201}
/// ```
/// 
/// ### Example 7: Server Sent Events (SSE)
/// 
/// ```dart
/// var res = await apiCall(
///   'https://sse-fake.andros.dev/events/',
///   options: Options(stream: true),
/// );
/// res.stream!.listen((e) {
///   var msg = String.fromCharCodes(e as List<int>);
///   print(msg);
/// });
/// ```
/// 
/// **Output:**
/// 
/// ```txt
/// :
/// event: stream-open
/// data:
/// 2
///
/// event: message
/// data: {"action": "User connected", "name": "Jeremy"}
/// 2
///
/// event: message
/// data: {"action": "New message", "name": "Nancy", "text": "How behind pattern world use. Reality save he where lead language.\nWhile ability likely difficult body someone. Two hope else listen never.\nHand speak town indicate else. Positive need price throw."}
/// 2
///
/// event: message
/// data: {"action": "User connected", "name": "Melissa"}
/// ...
/// ```
/// 
Future<ApiResponse> apiCall(String url, {Options options = const Options()}) async {
  try {
    var dioInstance = dio.Dio()..interceptors.clear();
    if (options.stream) {
      dioInstance.options.responseType = dio.ResponseType.stream;
    }
    dynamic body = options.body;
    if (options.timeout != null) {
      dioInstance.options.connectTimeout = options.timeout;
    }
    var headers = options.headers ?? {};
    var query = options.query ?? {};
    if (options.formData != null) {
      dio.FormData? formData;
      var map = <String, Object>{...options.formData!.fields};
      for (var e in options.formData!.files.entries) {
        if (e.value is String) {
          map[e.key] = await _toMultipartFile(e.value as String);
        } else if (e.value is List<String>) {
          var list = <dio.MultipartFile>[];
          for (var path in e.value as List<String>) {
            list.add(await _toMultipartFile(path));
          }
          map[e.key] = list;
        }
      }
      formData = dio.FormData.fromMap(map);
      body = formData;
    }
    if (options.json != null) {
      headers['content-type'] = 'application/json';
      body = options.json;
    }
    if (options.formUrlEncoded != null) {
      dioInstance.options.contentType = dio.Headers.formUrlEncodedContentType;
      body = options.formUrlEncoded;
    }
    dio.Response response;
    if (options.method == HttpMethod.get) {
      response = await dioInstance.get(url, queryParameters: query, options: dio.Options(headers: headers));
    } else if (options.method == HttpMethod.post) {
      response = await dioInstance.post(
        url,
        data: body,
        queryParameters: query,
        options: dio.Options(headers: headers),
        onSendProgress: options.onSendProgress,
        onReceiveProgress: options.onReceiveProgress,
      );
    } else if (options.method == HttpMethod.put) {
      response = await dioInstance.put(
        url,
        data: body,
        queryParameters: query,
        options: dio.Options(headers: headers),
        onSendProgress: options.onSendProgress,
        onReceiveProgress: options.onReceiveProgress,
      );
    } else if (options.method == HttpMethod.patch) {
      response = await dioInstance.patch(
        url,
        data: body,
        queryParameters: query,
        options: dio.Options(headers: headers),
        onSendProgress: options.onSendProgress,
        onReceiveProgress: options.onReceiveProgress,
      );
    } else if (options.method == HttpMethod.delete) {
      response = await dioInstance.delete(
        url,
        data: body,
        queryParameters: options.query,
        options: dio.Options(headers: headers),
      );
    } else {
      throw 'Unknown HTTP Method!';
    }

    var responseHeaders = <String, Object>{};
    for (final e in response.headers.map.entries) {
      if (e.value.length == 1) {
        responseHeaders[e.key] = e.value.first;
      } else if (e.value.length >= 2) {
        responseHeaders[e.key] = e.value;
      }
    }

    return ApiResponse(
      headers: responseHeaders,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      body: response.data,
      json:
          response.headers.map['content-type']?.any((e) => e.contains('application/json')) == true
              ? response.data
              : null,
      stream: options.stream ? response.data.stream : null,
    );
  } on dio.DioException catch (error) {
    final headers = error.response?.headers.map ?? {};
    var responseHeaders = <String, Object>{};
    for (final e in headers.entries) {
      if (e.value.length == 1) {
        responseHeaders[e.key] = e.value.first;
      } else if (e.value.length >= 2) {
        responseHeaders[e.key] = e.value;
      }
    }
    dynamic json;
    if (headers['content-type'] != null && headers['content-type']!.any((e) => e.contains('application/json'))) {
      json = error.response?.data;
    }

    return ApiResponse(
      headers: responseHeaders,
      body: error.response?.data,
      json: json,
      statusCode: error.response?.statusCode,
      statusMessage: error.response?.statusMessage,
      error: error.message,
    );
  }
}

Future<dio.MultipartFile> _toMultipartFile(String filePath) async {
  var file = File(filePath);
  var mime = lookupMimeType(file.path);
  var multipartFile = await dio.MultipartFile.fromFile(
    file.path,
    filename: file.path.split('/').last,
    contentType: mime == null ? null : dio.DioMediaType.parse(mime),
  );
  return multipartFile;
}