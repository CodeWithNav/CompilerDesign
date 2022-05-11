extension StringHelper on String {
  bool isTerminal() {
    if (isEmpty) return false;
    final asciiCode = this[0].codeUnits[0];
    return !(asciiCode >= 65 && asciiCode <= 90);
    // print("Ascii Code : ${this[0]} = $asciiCode");
    return asciiCode == 45 || (asciiCode >= 97 && asciiCode <= 122);
  }
}
