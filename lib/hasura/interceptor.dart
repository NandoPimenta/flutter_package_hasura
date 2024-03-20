import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:hasura_connect/hasura_connect.dart';

class TokenInterceptor extends Interceptor {
 
  Map<String,String> getToken;
 
  TokenInterceptor({required this.getToken});
 
 
  @override
  Future<void>? onConnected(HasuraConnect connect) async {
    debugPrint('----------------------------------------------------------');
    debugPrint('Hasura onConnected');
    debugPrint('----------------------------------------------------------');
  }

  @override
  Future<void>? onDisconnected() async {
    debugPrint('----------------------------------------------------------');
    debugPrint('Hasura onDisconnected');
    debugPrint('----------------------------------------------------------');
  }

  @override
  Future? onError(HasuraError request, HasuraConnect connect) async {
    debugPrint('----------------------------------------------------------');
    debugPrint('Hasura onError');
    log('Message: ${request.message}');
    log('Query: ${request.request.query}');
    debugPrint('----------------------------------------------------------');
    return request;
  }

  @override
  Future? onRequest(Request request, HasuraConnect connect) async {

      request.headers.addAll( getToken);

    debugPrint('----------------------------------------------------------');
    debugPrint('Hasura onRequest');
    log('Type: ${request.type}');
    log('Query: ${request.query}');
    debugPrint('----------------------------------------------------------');
    return request;
   /*  try {
      /* if (app.token.length > 0) {
        request.headers["Authorization"] = "Bearer ${app.token}";
      } */
      request.headers["x-hasura-admin-secret"] = "vbOn4iXfdsfsdfsflSzcS";
      return request;
    } catch (e) {
      return null;
    } */
  }

  @override
  Future? onResponse(Response data, HasuraConnect connect) async {
    debugPrint('----------------------------------------------------------');
    debugPrint('Hasura onResponse');
    log('StatusCode: ${data.statusCode}');
    log('Data: $data');
    debugPrint('----------------------------------------------------------');

    return data;
  }

  @override
  Future<void>? onSubscription(Request request, Snapshot snapshot) async {
    debugPrint('----------------------------------------------------------');
    debugPrint('Hasura onSubscription');
    log('Type: ${request.type}');
    log('Query: ${snapshot.query}');
    log('Value: ${snapshot.value}');
    debugPrint('----------------------------------------------------------');
  }

  @override
  Future<void>? onTryAgain(HasuraConnect connect) async {
    debugPrint('----------------------------------------------------------');
    debugPrint('Hasura onTryAgain');
    debugPrint('----------------------------------------------------------');
  }
}
