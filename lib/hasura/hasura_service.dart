import 'package:flutter/foundation.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'interceptor.dart';
import 'models/hasura_query_builder.dart';

class HasuraService {

  late String apiUrl;
  late bool isDebug;
  String token = "";
  late HasuraConnect? hasuraConnect;
  static Snapshot? snapshot;

  init({required String apiUrl, bool isDebug = true,required Map<String,String> token}) async {
    this.apiUrl = apiUrl;
    try {
      hasuraConnect = HasuraConnect(apiUrl,
          interceptors: [TokenInterceptor(getToken: token)]);
    } catch (e) {
      debugPrint('error');
    }
  }

  addHeader({required String key, required String value}) async {
    hasuraConnect?.headers?.addAll({key: value});
  }

  query(HasuraQueryBuilder q) async {
    var query = q.mountedQuery();
    return await hasuraConnect?.query(query, variables: q.getVariables());
  }

  mutation(HasuraQueryBuilder q) async {
    var query = q.mountedQuery();
    return await hasuraConnect?.mutation(query, variables: q.getVariables());
  }

  subscription(HasuraQueryBuilder q, callback) async {
    var query = q.mountedQuery();
    snapshot =
        await hasuraConnect?.subscription(query, variables: q.getVariables());
    snapshot?.listen((data) {
      callback(data);
    }).onError((err) {
      debugPrint(err);
    });
  }

  mountedQuery(
      {required String query, required Map<String, dynamic> variables}) async {
    return await hasuraConnect!.query(query, variables: variables);
  }

  mountedMutation(
      {required String query, required Map<String, dynamic> variables}) async {
    return await hasuraConnect!.mutation(query, variables: variables);
  }


  

 
}
