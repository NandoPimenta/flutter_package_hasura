class HasuraVariableModel {
  String column;
  dynamic value;
  String type;
  bool isRequired;

  HasuraVariableModel(
      {required this.column,
      required this.value,
      required this.type,
      this.isRequired = false});

  Map<String, dynamic > getVariable() {
    return {column: value};
  }

  
}
