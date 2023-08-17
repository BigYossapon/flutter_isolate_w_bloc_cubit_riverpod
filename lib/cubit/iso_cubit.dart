import 'dart:isolate';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'iso_state.dart';

class IsoCubit extends Cubit<IsoStates> {
  IsoCubit() : super(IsoInitials());

  void IsocountEvent() async {
    final ReceivePort receivePort = ReceivePort();

    try {
      await Isolate.spawn(
          runHeavyTaskIWithIsolate, [receivePort.sendPort, 4000000000]);
    } on Object {
      debugPrint('Isolate Failed');
      receivePort.close();
      emit(IsoErrors());
    }
    final response = await receivePort.first;

    emit(IsoLoadeds(value: response));
    print('Result: $response');
  }
}

int runHeavyTaskIWithIsolate(List<dynamic> args) {
  SendPort resultPort = args[0];
  // Emitter emitt = args[2];
  int value = 0;
  for (var i = 0; i < args[1]; i++) {
    value += i;
  }

  Isolate.exit(resultPort, value);
}
