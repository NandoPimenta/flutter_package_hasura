import 'hasura_enum.dart';

class HasuraWhereModel {
  String? column;

  List<String>? columnLogic;

  List<HasuraWhereModel>? columnLogicWhere;

  int? logic;
  List<String>? logicTypes = [
    '_and',
    '_not',
    '_or',
  ];
  HasuraWhereModel? child;

  HasuraWhereModel(
      {required this.column,
       this.columnLogic,
       this.columnLogicWhere,
      this.logic,
      this.child});

  static String whereQueryGenerate(
      {required HasuraWhereEnum e, required String value}) {
    String q = '';

    switch (e) {
      case HasuraWhereEnum.EQ:
        q += '_eq';
        break;
      case HasuraWhereEnum.GT:
        q += '_gt';
        break;
      case HasuraWhereEnum.GTE:
        q += '_gte';
        break;
      case HasuraWhereEnum.ILIKE:
        q += '_ilike';
        break;
      case HasuraWhereEnum.IN:
        q += '_in';
        break;
      case HasuraWhereEnum.IREGEX:
        q += '_iregex';
        break;
      case HasuraWhereEnum.ISNULL:
        q += '_is_null';
        break;
      case HasuraWhereEnum.LIKE:
        q += '_like';
        break;
      case HasuraWhereEnum.LT:
        q += '_lt';
        break;
      case HasuraWhereEnum.LTE:
        q += '_lte';
        break;
      case HasuraWhereEnum.NEQ:
        q += '_neq';
        break;
      case HasuraWhereEnum.NILIKE:
        q += '_nilike';
        break;
      case HasuraWhereEnum.NIN:
        q += '_nin';
        break;
      case HasuraWhereEnum.NIREGEX:
        q += '_niregex';
        break;
      case HasuraWhereEnum.NLIKE:
        q += '_nlike';
        break;
      case HasuraWhereEnum.NREGEX:
        q += '_nregex';
        break;
      case HasuraWhereEnum.NSIMILAR:
        q += '_nsimilar';
        break;
      case HasuraWhereEnum.REGEX:
        q += '_regex';
        break;
      case HasuraWhereEnum.SIMILAR:
        q += '_similar';
        break;
    }

    return '$q: $value';
  }
}
