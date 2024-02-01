import 'package:flutter/foundation.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'interceptor.dart';
import 'models/hasura_query_builder.dart';

class HasuraService {
  HasuraService({required this.apiUrl, this.isDebug = true}) {
    init();
  }
  String apiUrl;
  bool isDebug;
  String token = "";
  late HasuraConnect? hasuraConnect;
  static Snapshot? snapshot;

  init() async {
    try {
      hasuraConnect = HasuraConnect(apiUrl,
          interceptors: [TokenInterceptor(getToken: getToken)]);
    } catch (e) {
      debugPrint('error');
    }
  }

  getToken() async {
    if (isDebug) {
      return {"x-hasura-admin-secret": "vbOn4iXfdsfsdfsflSzcS"};
    } else {
      return {"Authorization": "Bearer $token"};
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


  mountedQuery({required String query, required Map<String,dynamic> variables})async{
     return await hasuraConnect!
        .query(query, variables: variables);
  }


  mountedMutation({required String query, required Map<String,dynamic> variables})async{
     return await hasuraConnect!
        .mutation(query, variables: variables);
  }


  _actionAuth({required String email, required String password}) async {
    var query = """
    mutation SignInJWT(\$email:String!,\$password:String!,) {
        SignIn(credentials: {email: \$email, password: \$password}) {
          status
          message
          data{
            token{
              type
              token
            }
            user{
              id
            }
            hasura
          }
        }
      }
    """;
    return await hasuraConnect!
        .mutation(query, variables: {"email": email, "password": password});
  }

  _actionSignUp(
      {required String email,
      required String password,
      required String phone,
      required String name,
      String? avatar}) async {
    var query = """
    mutation SignUpJWT(\$email:String!,\$password:String!,\$phone:String!,\$name:String!,\$avatar:String!,) {
        SignUp(client: {email: \$email, password: \$password,phone: \$phone,name: \$name,avatar: \$avatar,}) {
          status
          message
          
        }
      }
    """;
    return await hasuraConnect?.mutation(query, variables: {
      "email": email,
      "password": password,
      "phone": phone,
      "name": name,
      "avatar": " "
    });
  }

  _emailRequestCode(
      {required String email,
      required String code,
      required String password}) async {
    var query = """
    mutation ConfirmRequestCode(\$email:String!,\$password:String!,\$code:String!) {
        CodeConfirm(emailCodeConfirm: {email: \$email, code: \$code, password: \$password}) {
          message
          status
          data {
            hasura
            user {
              id
            }
            token {
              token
              type
            }
          }
        }
      }
    """;
    return await hasuraConnect!.mutation(query,
        variables: {"email": email, "password": password, "code": code});
  }

  _emailResendCode({
    required String email,
  }) async {
    var query = """
    mutation ResendEmailCode(\$email:String!) {
        ResendCode(resendCodeConfirm: {email: \$email}) {
          status
          message
        }
      }
    """;
    return await hasuraConnect!.mutation(query, variables: {"email": email});
  }

  _forgetPassword({required String email, required String lang}) async {
    var query = """
    mutation ForgetPasswordMutation(\$email:String!,\$lang:String!,) {
        ForgetPassword(forgetPassword: {email: \$email, lang: \$lang}) {
          status
          message
      
        }
      }
    """;
    return await hasuraConnect!
        .mutation(query, variables: {"email": email, "lang": lang});
  }

  _codeForgetPassword({
    required String email,
    required String lang,
    required String code,
  }) async {
    var query = """
    mutation ForgetPasswordCodeMutation(\$email:String!,\$lang:String!,\$code:String!,) {
        ForgetPasswordCode(forgetPasswordCode: {email: \$email, lang: \$lang, code: \$code}) {
          status
          message
        }
      }
    """;
    return await hasuraConnect!.mutation(query, variables: {
      "email": email,
      "lang": lang,
      "code": code,
    });
  }

  _changeForgetPassword(
      {required String email,
      required String lang,
      required String code,
      required String password}) async {
    var query = """
    mutation ForgetPasswordChangeMutation(\$email:String!,\$lang:String!,\$code:String!,\$password:String!,) {
        ForgetPasswordChange(forgetPasswordChange: {email: \$email, lang: \$lang, code: \$code, password: \$password}) {
          status
          message
        }
      }
    """;
    return await hasuraConnect!.mutation(query, variables: {
      "email": email,
      "lang": lang,
      "code": code,
      "password": password
    });
  }

  _changePassword(
      {required String email,
      required String password,
      required String newPassword}) async {
    var query = """
    mutation ChangePasswordMutation(\$email:String!,\$newPassword:String!,) {
        ChangePassword(changePassword: {email: \$email,   newPassword: \$newPassword}) {
          status
          message
        }
      }
    """;
    return await hasuraConnect!.mutation(query, variables: {
      "email": email,
      "newPassword": newPassword,
    });
  }





}
