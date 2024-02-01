

import 'hasura_enum.dart';
import 'hasura_orderby_model.dart';
import 'hasura_return_model.dart';
import 'hasura_set_model.dart';
import 'hasura_variable_model.dart';
import 'hasura_where_model.dart';

class HasuraQueryBuilder {
  HasuraENUM type;
  HasuraMutationENUM? mutationType;
  String table;
  String? requestQueryName;
  int? offset;
  String? distinctOn;
  int? limit;
  bool isAggregate;
  List<HasuraWhereModel>? where;
  List<HasuraSetModel>? update;
  List<HasuraOrderByModel>? orderby;
  List<String>? params;
  List<String>? returned;
  List<HasuraReturnModel>? complexReturned;
  List<HasuraVariableModel>? variables;
  List<HasuraQueryBuilder>? hasuraModel;

  HasuraQueryBuilder(
      {required this.type,
      required this.table,
      this.params,
      this.returned,
      this.variables,
      this.orderby,
      this.distinctOn,
      this.limit,
      this.offset,
      this.where,
      this.update,
      this.requestQueryName,
      this.hasuraModel,
      this.complexReturned,
      this.isAggregate = false,
      this.mutationType = HasuraMutationENUM.QUERY});

  String mountedQuery() {
    var typeOfRequest = 'mutation';
    var typeOfMutation = '';

    switch (type) {
      case HasuraENUM.QUERY:
        typeOfRequest = 'query';
        break;
      case HasuraENUM.MUTATION:
        typeOfRequest = 'mutation';
        break;
      case HasuraENUM.SUBSCRIPTION:
        typeOfRequest = 'subscription';
        break;
    }

    switch (mutationType) {
      case HasuraMutationENUM.QUERY:
        typeOfMutation = '';
        break;
      case HasuraMutationENUM.INSERT:
        typeOfMutation = 'insert_';
        break;
      case HasuraMutationENUM.UPDATE:
        typeOfMutation = 'update_';
        break;
      case HasuraMutationENUM.DELETE:
        typeOfMutation = 'delete_';
        break;
      case HasuraMutationENUM.SUBSCRIPTION:
        typeOfMutation = '';
        break;
      default:
        typeOfMutation = '';
    }

    return ''' 
    
    $typeOfRequest ${requestQueryName ?? typeOfRequest + table}  ${_mountedVariables()} {
            ${type == HasuraENUM.MUTATION ? _mioloMutatio(typeOfMutation) : _mioloQuery()}
      }

    
    ''';
  }

  String _mioloMutatio(typeOfMutation) {
    return ''' 
    
        $typeOfMutation$table${mutationType != HasuraMutationENUM.INSERT ? _mountedQueryVariable() : _mountedMutationObject()} {
          ${returned != null ? 'returning{${returned!.join(' ')}}' : ' affected_rows'}
        }
      

    
    ''';
  }

  String _mioloQuery() {
    var str = '';

    if (hasuraModel != null)
      {
        for (var element in hasuraModel!) {
        str += '${element._mioloQuery()} ';
      }
      }

    if (isAggregate) {
      return '''
      $table${_mountedQueryVariable()} {
         
         nodes { 
           $str
           ${returned!.join(' ')}
            ${mioloReturned(complexReturned: complexReturned)}
                 }
          
        }
    
    ''';
    } else {
      return '''
      $table${_mountedQueryVariable()} {
          $str
          ${returned!.join(' ')}
          ${mioloReturned(complexReturned: complexReturned)}
        }
    
    ''';
    }
  }

  // melhorar a complexidade de filhos
  String mioloReturned({List<HasuraReturnModel>? complexReturned}) {
    String str = ' ';
    if (complexReturned != null) {
      for (var element in complexReturned) {
        str += '${element.column!}{${element.returned!.join(' ')}${mioloReturned(complexReturned: element.hassuraReturnModel)}}';
      }
    }
    return str;
  }

  String _mountedMutationObject() {
    if (variables == null) return '';
    var strVariable = '(objects:{';

    for (var element in variables!) {
      strVariable += '${element.column}:\$${element.column},';
    }

    return '$strVariable})';
  }

  String _mountedVariables() {
    if (variables == null) return '';
    var strVariable = '(';

    for (var element in variables!) {
      strVariable += '\$${element.column}:${element.type}${element.isRequired ? '!,' : ','}';
    }

    return '$strVariable)';
  }

  String _mountedQueryVariable() {
    var str = '';

    var qwhere = where != null ? mountedWhere() : '';

    var qupdate = update != null ? mountedSet() : '';

    var qorderby = orderby != null ? mountedOrderBy() : '';

    var qlimit = limit != null ? 'limit:$limit' : '';

    var qoffset = offset != null ? 'offset:$offset' : '';

    var qdistinctOn = distinctOn != null ? 'distinct_on:${distinctOn!}' : '';

    str = qwhere + qupdate + qorderby + qlimit + qoffset + qdistinctOn;
    if (str.length > 1) {
      return '($str)';
    } else {
      return '';
    }
  }

  String mountedOrderBy() {
    String strOrderby = ', order_by:{';
    for (var element in orderby!) {
      strOrderby += '${element.column}:${element.types[element.type]}';
    }
    strOrderby += ' },';
    return strOrderby;
  }

  String mountedWhere() {
    String whereQuery = 'where:{';

    whereQuery += _mioloWhere(where);

    return '$whereQuery },';
  }

  String _mioloWhere(w) {
    String whereQuery = '';
    w!.forEach((element) {
      if (element.columnLogicWhere == null) {
        whereQuery += element.column! + ':{';
        var str = '';
        element.columnLogic!.forEach((e) {
          str += e + ',';
        });
        whereQuery += '$str},';
      } else {
        whereQuery += element.column! +
            ':{' +
            _mioloWhere(element.columnLogicWhere) +
            '}';
      }
    });
    return whereQuery;
  }

  String mountedSet() {
    String setQuery = '_set:{';
    for (var element in update!) {
      setQuery += '${element.column}:${element.value},';
    }
    return '$setQuery },';
  }

  setVariables({required List<HasuraVariableModel> variables}) {
    this.variables = variables;
  }

  getVariables() {
    if (variables == null) return null;
    Map<String, dynamic> allVariables = {};
    for (var element in variables!) {
      allVariables.addAll(element.getVariable());
    }
    return allVariables;
  }
}
