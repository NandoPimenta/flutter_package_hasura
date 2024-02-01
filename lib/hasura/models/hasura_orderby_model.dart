
class HasuraOrderByModel {
  String column;
  int type;
  List<String> types = [
    'asc',
    'asc_nulls_first',
    'asc_nulls_last',
    'desc',
    'desc_nulls_first',
    'desc_nulls_last',
  ];

  HasuraOrderByModel({required this.column, required this.type});
}
