import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var results = "results...";
  late OpenAI openAI;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    openAI = OpenAI.instance.build(
        token: "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",
        baseOption: HttpSetup(receiveTimeout: 16000),
        isLogger: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SingleChildScrollView(child: Text(results)),
            Row(
              children: [
                Expanded(child: TextField(controller: textEditingController)),
                ElevatedButton(
                  onPressed: () {
                    final request = CompleteText(
                        prompt: textEditingController.text,
                        model: kTranslateModelV3,
                        maxTokens: 200);

                    openAI
                        .onCompleteStream(request: request)
                        .listen((response) {
                      results = response!.choices.first.text;
                      setState(() {
                        results;
                      });
                    });
                    textEditingController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: const Color(0xf0304CEF),
                    padding: const EdgeInsets.all(20),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xf0304CEF),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: const Icon(
                      Icons.send_sharp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
