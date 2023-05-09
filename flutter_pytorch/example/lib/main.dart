import 'package:flutter/material.dart';
import 'package:flutter_pytorch_example/RunModelByCameraDemo.dart';

void main() => runApp(ChooseDemo());

class ChooseDemo extends StatefulWidget {
  const ChooseDemo({Key? key}) : super(key: key);

  @override
  State<ChooseDemo> createState() => _ChooseDemoState();
}

class _ChooseDemoState extends State<ChooseDemo> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pytorch Mobile Example'),
        ),
        body: Builder(
          builder: (context) {
            return Center(
              child: Column(
                children: [
                  TextButton(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RunModelByCameraDemo()),
                      )
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      "Run Model with Camera",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}

