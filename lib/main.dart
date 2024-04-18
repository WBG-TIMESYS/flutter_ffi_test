import 'package:flutter/material.dart';
import 'dart:ffi';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: MyPage(),
      ),
    );
  }
}

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  late final DynamicLibrary myLib;
  late final int Function() aioLoadDevice;
  late final void Function() aioUnloadDevice;

  String? result;

  @override
  void initState() {
    super.initState();

    myLib = DynamicLibrary.open("assets/lib/tmcDApiAed_x64.dll");

    aioLoadDevice = myLib
        .lookup<NativeFunction<Int32 Function()>>("AIO_LoadDevice")
        .asFunction();

    aioUnloadDevice = myLib
        .lookup<NativeFunction<Void Function()>>("AIO_UnloadDevice")
        .asFunction();

    setState(() {
      result = "AIO_LoadDevice: ${aioLoadDevice()}";
    });
  }


  @override
  void deactivate() {
    super.deactivate();
    aioUnloadDevice();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(result ?? "---"),
    );
  }
}

