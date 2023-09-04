import 'dart:async';
import 'dart:isolate';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'iso_event.dart';
part 'iso_state.dart';

class IsoBloc extends Bloc<IsoEvent, IsoState> {
  IsoBloc() : super(IsoInitial()) {
    on<IsocountEvent>((event, emit) async {
      // TODO: implement event handler
      final ReceivePort receivePort = ReceivePort();
      emit(IsoLoading());
      try {
        await Isolate.spawn(
            runHeavyTaskIWithIsolate, [receivePort.sendPort, 4000000000]);
      } on Object {
        debugPrint('Isolate Failed');
        receivePort.close();
        emit(IsoError());
      }

      // receivePort.listen((message) {
      //   if (message is SendPort) {
      //     message.send('Hello from the main isolate!');
      //   } else {
      //     //message.send('Hello from the main isolate!');
      //   }
      //   //Isolate.kill();
      // });

      // receivePort.listen((message) {
      //   if (message is SendPort) {
      //     message.send('Hello from the main isolate!');
      //   } else {
      //     print('Received message in main isolate: $message');
      //   }
      // });
      final response = await receivePort.first;

      emit(IsoLoaded(value: response));
      print('Result: $response');

      //response.send('Hello from the main isolate!');
    });
  }
}

Future<int> runHeavyTaskIWithIsolate(List<dynamic> args) async {
  SendPort resultPort = args[0];
  // Emitter emitt = args[2];
  int value = 0;
  for (var i = 0; i < args[1]; i++) {
    value += i;
  }
  ReceivePort receivePort = ReceivePort();
  // receivePort.listen((message) {
  //   print(message);
  // });
  //resultPort.send(receivePort.sendPort);
  receivePort.listen((message) {
    if (message is SendPort) {
      print('Received message in isolate: $message');
    } else if (message is String)
      print('Received message in isolate: $message');
    //resultPort.send('Hello from the isolate!');
  });

  //resultPort.send('Hello from the isolate!');
  // resultPort.send(receivePort.sendPort);
  // receivePort.listen((message) {
  //   if (message is SendPort) {
  //     message.send('Hello from the isolate!');
  //   } else {
  //     print('Received message in isolate: $message');
  //   }
  //   //print('Received message in isolate: $message');
  //   resultPort.send('Hello from the isolate!');
  // });

  // ส่งกลับ2แบบ
  // resultPort.send('Hello from the isolate!');
  Isolate.exit(resultPort, value);
}
