extension StringHelper on String {
  bool isChar() {
    if (isEmpty) return false;
    final asciiCode = this[0].codeUnits[0];
    // print("Ascii Code : ${this[0]} = $asciiCode");
    return asciiCode == 45 || (asciiCode >= 97 && asciiCode <= 122);
  }
}
