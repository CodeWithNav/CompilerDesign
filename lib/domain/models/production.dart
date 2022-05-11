class Production {
  String startingSymbol;
  String production;
  Production({this.startingSymbol = "S", this.production = "Ab|a"});

  productionToList() {
    return production.split("|");
  }
}
