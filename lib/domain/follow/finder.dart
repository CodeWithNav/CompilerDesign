import 'package:compiler_design/domain/first/finder.dart';

class FollowFinder {
  late Map<String, List<String>> cfgMap;
  final Set<String> allNonTerminals = {};
  FollowFinder({required this.cfgMap}) {
    for (String key in cfgMap.keys) {
      allNonTerminals.add(key);
    }
  }
  Map<String, Set<String>> findFollow() {
    final Map<String, Set<String>> res = {};

    Set<String> follow({required String terminal}) {
      final Set<String> follows = {};

      for (String startingSymbol in allNonTerminals) {
        for (String equ in cfgMap[startingSymbol]!) {
          for (int i = 0; i < equ.length; i++) {
            if (equ[i] == terminal) {
              final firsts = FirstFinder(cfgMap: cfgMap)
                  .firstFromString(string: equ.substring(i + 1));
              if (firsts == null || firsts.contains("-")) {
                // find follow of starting symbol
                if (startingSymbol != terminal) {
                  final startingSymbolFollows =
                      follow(terminal: startingSymbol);
                  follows.addAll(startingSymbolFollows);
                } else {
                  follows.add("\$");
                }
              }
              if (firsts != null) {
                firsts.remove("-");
                follows.addAll(firsts);
              }
            }
          }
        }
      }

      return follows;
    }

    for (String nonTerminal in allNonTerminals) {
      final follows = follow(terminal: nonTerminal);
      if (follows.isEmpty) {
        res[nonTerminal] = {"\$"};
      } else {
        res[nonTerminal] = follows;
      }
    }
    return res;
  }
}
