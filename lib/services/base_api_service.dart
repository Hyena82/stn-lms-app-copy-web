// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:http/http.dart';
import 'dart:convert' show utf8, json;
import 'package:logger_console/logger_console.dart';

class LogHttpClient extends BaseClient {
  final Client _delegate;

  LogHttpClient(this._delegate);

  @override
  void close() {
    _delegate.close();
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    Console.groupCollapsed(
      '%c${request.method} ${request.url}',
      'color: green',
    );
    Console.log('header:', request.headers);
    if (request is Request && request.body.isNotEmpty) {
      try {
        final data = json.decode(request.body);
        Console.log('body:', data);
      } catch (e) {
        Console.log('body:', request.body);
      }
    }
    Console.groupEnd();

    final response = await _delegate.send(request);

    if (request is Request) {
      final List<int> bytes = await response.stream.toBytes();
      final String body = utf8.decode(bytes);
      Console.groupCollapsed(
        '%cResponse[${response.statusCode}]::${request.method} ${request.url}',
        'color: DodgerBlue',
      );
      var data;
      try {
        data = json.decode(body);
      } catch (e) {
        data = body;
      }
      Console.log('data:', data);
      Console.groupEnd();

      return StreamedResponse(ByteStream.fromBytes(bytes), response.statusCode,
          contentLength: response.contentLength,
          request: request,
          headers: response.headers,
          isRedirect: response.isRedirect,
          persistentConnection: response.persistentConnection,
          reasonPhrase: response.reasonPhrase);
    }

    return response;
  }
}
