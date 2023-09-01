import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:isolates_demo/riverpod/iso_state.dart';
import 'package:riverpod/riverpod.dart';

final countProvider = StateNotifierProvider<CountNotifier, IsoStatess>(
  (ref) {
    return CountNotifier();
  },
);

class CountNotifier extends StateNotifier<IsoStatess> {
  CountNotifier() : super(IsoInitialss());

  // We initialize the list of todos to an empty list

  void IsocountEvents() async {
    final ReceivePort receivePort = ReceivePort();
    state = IsoLoadingss();
    try {
      await Isolate.spawn(
        runHeavyTaskIWithIsolate,
        [receivePort.sendPort, 4000000000],
      );
    } on Object {
      debugPrint('Isolate Failed');
      receivePort.close();
      state = IsoErrorss();
      //emit(IsoErrors());
    }
    final response = await receivePort.first;

    //emit(IsoLoadeds(value: response));
    state = IsoLoadedss(value: response);
    print('Result: $response');
  }

  @override
  IsoStatess build() {
    // TODO: implement build
    throw IsoInitialss();
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
