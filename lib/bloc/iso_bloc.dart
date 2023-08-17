import 'dart:isolate';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../home_page.dart';

part 'iso_event.dart';
part 'iso_state.dart';

class IsoBloc extends Bloc<IsoEvent, IsoState> {
  IsoBloc() : super(IsoInitial()) {
    emit(IsoLoading());
    on<IsocountEvent>((event, emit) async {
      // TODO: implement event handler
      final ReceivePort receivePort = ReceivePort();

      try {
        await Isolate.spawn(
            runHeavyTaskIWithIsolate, [receivePort.sendPort, 4000000000]);
      } on Object {
        debugPrint('Isolate Failed');
        receivePort.close();
        emit(IsoError());
      }
      final response = await receivePort.first;

      emit(IsoLoaded(value: response));
      print('Result: $response');
    });
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
