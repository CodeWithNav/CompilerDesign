import '../../helper/string_helper.dart';

class FirstFinder {
  late Map<String, List<String>> cfgMap = {};
  FirstFinder({required this.cfgMap});

  Map<String, Set<String>> findFirst() {
    final Map<String, Set<String>> res = {};

    for (String nonTerminal in cfgMap.keys) {
      res[nonTerminal] = firstFromTerminal(terminal: nonTerminal) ?? {"-"};
    }

    return res;
  }

  // final Map<String, Set<String>> alreadyCalculated = {};

  // first from terminal
  /*
  * A -> a | -
  * here first of A = {a,-}
  * */
  Set<String>? firstFromTerminal({required String terminal}) {
    // if (alreadyCalculated.containsKey(terminal))
    //   return alreadyCalculated[terminal];
    if (terminal.isEmpty ||
        terminal.length > 1 ||
        !cfgMap.containsKey(terminal)) return null;
    final Set<String> res = {};
    for (String rightSide in cfgMap[terminal]!) {
      var rightSideFirst = firstFromString(string: rightSide);
      if (rightSideFirst != null) {
        res.addAll(rightSideFirst);
      }
    }
    // print("terminal $terminal => ${res.toString()}");
    // alreadyCalculated[terminal] = res;
    return res;
  }

  // first from string
  /*
  * S-> ABa
  * A -> a | -
  * B -> b | -
  * firstFromTerminal(S) = firstFromString(ABa) = {a,b}
  * */
  Set<String>? firstFromString({required String string}) {
    if (string.isEmpty) return {"-"};
    final n = string.length;
    Set<String> res = {};
    int i = 0;
    for (; i < n; i++) {
      if (string[i].isChar()) {
        res.add(string[i]);
        break;
      } else {
        var terminalSet = firstFromTerminal(terminal: string[i]);
        final have = terminalSet == null ||
            terminalSet.contains("-") ||
            terminalSet.isEmpty;
        if (terminalSet != null && terminalSet.isNotEmpty) {
          terminalSet.remove("-");
          res.addAll(terminalSet);
        }
        if (!have) break;
      }
    }
    if (i == n) res.add("-");
    // print("$string => ${res.toString()}");
    return res;
  }
}
