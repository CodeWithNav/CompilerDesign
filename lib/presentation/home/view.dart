import 'package:compiler_design/domain/first/finder.dart';
import 'package:compiler_design/domain/follow/finder.dart';
import 'package:compiler_design/domain/models/production.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // final FollowFinder _finder = FollowFinder(cfgMap: map);
  bool isShow = false;
  final List<Production> productions = [];
  String? firstRes;
  String? followRes;

  showInfoAlert(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Notice"),
            content: const Text(
              "It in an simple first and follow finding site where you easily find first and follow of given CFG (Context Free Grammar).\n"
              "But there is an small edge case is that it under development, so it not able to handle any invalid CFG example CFG contain left recursion or many other edge cases so please enter valid CFG in future we handle all edge cases.\n"
              "Feel free to ask and provide any issue on github repository(link provided in site).\n"
              "One more thing UI also not good so forget for now."
              "",
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Ok"))
            ],
          );
        });
  }

  void setFirst() {
    setState(() {
      firstRes = null;
    });
    if (productions.isNotEmpty) {
      Map<String, List<String>> cfg = {};
      for (Production p in productions) {
        cfg[p.startingSymbol] = p.productionToList();
      }
      final FirstFinder _firstFinder = FirstFinder(cfgMap: cfg);
      Map<String, Set<String>> firsts = _firstFinder.findFirst();

      String line = "";
      for (String nonTerminal in firsts.keys) {
        line = nonTerminal;
        String production = "{";
        for (String first in firsts[nonTerminal]!) {
          production = "$production $first,";
        }
        line = "$line -> $production }";
        firstRes = "${firstRes ?? ""}$line\n";
      }
    }
    setState(() {});
  }

  void setFollow() {
    setState(() {
      followRes = null;
    });
    if (productions.isNotEmpty) {
      Map<String, List<String>> cfg = {};
      for (Production p in productions) {
        cfg[p.startingSymbol] = p.productionToList();
      }
      final FollowFinder _followFinder = FollowFinder(cfgMap: cfg);
      Map<String, Set<String>> firsts = _followFinder.findFollow();

      String line = "";
      for (String nonTerminal in firsts.keys) {
        line = nonTerminal;
        String production = "{";
        for (String first in firsts[nonTerminal]!) {
          production = "$production $first,";
        }
        line = "$line -> $production }";
        followRes = "${followRes ?? ""}$line\n";
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("First & Follow finder"),
        actions: [
          IconButton(
            onPressed: () {
              showInfoAlert(context);
            },
            icon: const Icon(Icons.info),
          ),
          InkWell(
            onTap: () {
              launchUrl(
                  Uri.parse("https://github.com/CodeWithNav/CompilerDesing"));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png",
                  // width: 50,
                  // height: 30,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 50,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...[
                for (Production production in productions)
                  Row(
                    children: [
                      Expanded(child: ProductionField(production: production)),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              productions.remove(production);
                            });
                          },
                          icon: const Icon(Icons.clear)),
                    ],
                  )
              ],
              const SizedBox(
                height: 5,
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      productions.add(Production());
                    });
                  },
                  child: const Text("Add New Production")),
              const SizedBox(
                height: 5,
              ),
              ElevatedButton(
                onPressed: () {
                  setFirst();
                },
                child: const Text("Find First"),
              ),
              const SizedBox(
                height: 5,
              ),
              ElevatedButton(
                onPressed: () {
                  setFollow();
                },
                child: const Text("Find Follow"),
              ),
              const SizedBox(
                height: 5,
              ),
              ElevatedButton(
                onPressed: () {
                  setFirst();
                  setFollow();
                },
                child: const Text("Find First and Follow"),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (firstRes != null && firstRes!.isNotEmpty)
                    Card(
                      color: Colors.amber,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text(
                              "First",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              firstRes!,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  if (followRes != null && followRes!.isNotEmpty)
                    Card(
                      color: Colors.deepOrange,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text(
                              "Follow",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              followRes!,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProductionField extends StatelessWidget {
  const ProductionField({Key? key, required this.production}) : super(key: key);
  final Production production;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 1,
          child: TextFormField(
            initialValue: production.startingSymbol,
            onChanged: (String? value) {
              if (value != null) production.startingSymbol = value;
            },
            decoration: const InputDecoration(
                hintText: "S", label: Text("Starting Symbol")),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "->",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 8,
          child: TextFormField(
            initialValue: production.production,
            onChanged: (String? value) {
              if (value != null) production.production = value;
            },
            decoration: const InputDecoration(
                hintText: "Ab|bA", label: Text("Production Rule")),
          ),
        ),
      ],
    );
  }
}

// var map = {
//   "S": ["ABCDE"],
//   "A": ["a", "-"],
//   "B": ["b", "-"],
//   "C": ["c"],
//   "D": ["d", "-"],
//   "E": ["e", "-"]
// };
