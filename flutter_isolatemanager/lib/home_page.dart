import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:isolate_manager/isolate_manager.dart';
import 'package:isolated_worker/isolated_worker.dart';
import 'package:isolated_worker/js_isolated_worker.dart';
import 'package:isolated_worker/worker_delegator.dart';
import 'package:worker_manager/worker_manager.dart';

import '';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isolates_demo/cubit/iso_cubit.dart';
import 'dart:async';
import 'bloc/iso_bloc.dart';
import 'riverpod/iso_riverpod.dart';
import 'riverpod/iso_state.dart';
import 'dart:core';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

Future<int> runHeavyTaskIWithoutIsolaterun(int args) async {
  int value = 0;
  for (var i = 0; i < args; i++) {
    value += i;
  }

  return value;
}

init() {
  final isolateManager1 = IsolateManager.create(
    isDebug: true,
    runHeavyTaskIWithtIsolatemanager,
    workerName: 'fibonacci',
    concurrent: 2,
  );
}

@pragma('vm:entry-point')
Future<int> runHeavyTaskIWithtIsolatemanager(dynamic args) async {
  int value = 0;
  // final channel = IsolateManagerController(args);
  // channel.onIsolateMessage.listen((event) {});
  for (var i = 0; i < args[0]; i++) {
    value += i;
  }
  //print(value);
  return value;
}

@pragma('vm:entry-point')
void isolatefunction(dynamic params) {
  print('event:' + params.toString());
  final channel = IsolateManagerController(params);
  channel.onIsolateMessage.listen((event) async {
    print('event:' + event.toString());
    final result = await runHeavyTaskIWithtIsolatemanager(event);
    channel.sendResult(result);
  });
}

Future<int> runHeavyTaskIWithtIsolatemanagertest(dynamic args) async {
  int value = 0;
  // final channel = IsolateManagerController(args);
  // channel.onIsolateMessage.listen((event) {});
  for (var i = 0; i < args[0]; i++) {
    value += i;
  }
  //print(value);
  return value;
}

Future<int> runHeavyTaskIWithtworkermanager(List<dynamic> args) async {
  int value = 0;
  for (var i = 0; i < args[0]; i++) {
    value += i;
  }

  return value;
}

int runHeavyTaskIWithtIsolateworkers(List<int> args) {
  int value = 0;
  for (var i = 0; i < args[0]; i++) {
    value += i;
  }
  print('==============================');
  return value;
}

Future<int> runHeavyTaskIWithoutIsolatespawncommunication(
    List<dynamic> args) async {
  var mainToIsolateStream = ReceivePort();
  var isolateToMainStream = args[0];

  int value = 0;
  for (var i = 0; i < args[1]; i++) {
    value += i;
  }
  isolateToMainStream.send(mainToIsolateStream.sendPort);
  mainToIsolateStream.listen((data) {
    print('[mainToIsolateStream] $data');
    //exit(0);
  });
  isolateToMainStream.send('This is from myIsolate()');
  return value;
}

Future<dynamic> myMaininitIsolate() async {
  Completer completer = Completer<SendPort>();
  var isolateToMainStream = ReceivePort();

  isolateToMainStream.listen((data) {
    if (data is SendPort) {
      var mainToIsolateStream = data;
      completer.complete(mainToIsolateStream);
    } else {
      print('[isolateToMainStream] $data');
    }
  });
  // await Isolate.spawn(myIsolate, isolateToMainStream.sendPort);
  //await Isolate.spawn(myIsolate, isolateToMainStream.sendPort);
  return completer.future;
}

void myIsolate(SendPort isolateToMainStream) {
  var mainToIsolateStream = ReceivePort();
  runHeavyTaskIWithoutIsolaterun(4000000000);
  isolateToMainStream.send(mainToIsolateStream.sendPort);

  mainToIsolateStream.listen((data) {
    print('[mainToIsolateStream] $data');
    //exit(0);
  });

  isolateToMainStream.send('This is from myIsolate()');
}

Future<int> computeFactorial(int n) async {
  return await compute(runHeavyTaskIWithoutIsolates, 4000000000);
}

int runHeavyTaskIWithoutIsolates(int values) {
  int value = 0;
  for (var i = 0; i < values; i++) {
    value += i;
  }

  //values = value;
  return value;
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  int values = 0;
  int values1 = 0;
  int values2 = 0;
  int values_iso_manager = 0;
  int values_iso_manager2 = 0;
  int values_iso_manager3 = 0;
  int values_iso_worker = 0;
  int values_worker_manager = 0;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Isolates'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyWidget(),
                ),
              );
            },
            child: const Icon(Icons.abc),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const CircularProgressIndicator(),
              Text(values.toString()),
              const SizedBox(height: 50),
              ElevatedButton(
                child: const Text('Run Heavy Task - without Isolate'),
                onPressed: () {
                  runHeavyTaskIWithoutIsolate([4000000000]);
                  setState(() {});
                },
              ),
              Text(values_worker_manager.toString()),
              const SizedBox(height: 50),
              ElevatedButton(
                  child: const Text(
                      'Run Heavy Task - with worker manager not true '),
                  onPressed: () async {
                    Cancelable<dynamic> cancelable =
                        workerManager.executeWithPort<dynamic, String>(
                      (SendPort sendPort) async {
                        // Your CPU-intensive function here
                        await runHeavyTaskIWithtworkermanager([4000000000])
                            .then((value) {
                          setState(() {
                            values_worker_manager = value;
                          });
                        });
                        // Use sendPort.send(message) to communicate with the main isolate
                      },
                      onMessage: (String message) {
                        // Handle the received message in the main isolate
                      },
                    );
                  }),
              Text(values_iso_manager.toString()),
              const SizedBox(height: 50),
              ElevatedButton(
                child: const Text('Run Heavy Task - with isolate manager'),
                onPressed: () async {
                  final isolateManager = IsolateManager.create(
                      runHeavyTaskIWithtIsolatemanager,
                      workerName: 'runHeavyTaskIWithtIsolatemanager',
                      isDebug: true,
                      concurrent: 1);
                  final result =
                      await isolateManager.compute([4000000000]).then((value) {
                    setState(() {
                      values_iso_manager = value;
                    });
                  });
                },
              ),
              Text(values_iso_manager2.toString()),
              const SizedBox(height: 50),
              ElevatedButton(
                child: const Text(
                    'Run Heavy Task - with isolate manager with communication'),
                onPressed: () async {
                  final isolateManager2 = IsolateManager.createOwnIsolate(
                      isolatefunction,
                      isDebug: true,
                      concurrent: 1);
                  isolateManager2.start();

                  isolateManager2.sendMessage(
                    [4000000000],
                    callback: (value) {
                      setState(() {
                        values_iso_manager2 = value;
                      });
                      return true;
                    },
                  );
                },
              ),
              Text(values_iso_worker.toString()),
              const SizedBox(height: 50),
              ElevatedButton(
                child: const Text(
                    'Run Heavy Task - with isolate worker and jsisolate worker'),
                onPressed: () async {
                  if (kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
                    // argument/return from function
                    print('all platfrom');
                    DefaultDelegate<List<int>, int> fooDelegate =
                        DefaultDelegate(
                            callback: runHeavyTaskIWithtIsolateworkers);

                    JsDelegate fooJsDelegate = JsDelegate(
                        callback: 'runHeavyTaskIWithtIsolateworkers');

                    WorkerDelegate<List<int>, int> workerDelegate =
                        WorkerDelegate(
                      key: 'runHeavyTaskIWithtIsolateworkers',
                      defaultDelegate: fooDelegate,
                      jsDelegate: fooJsDelegate,
                    );

                    WorkerDelegator().addDelegate(workerDelegate);

                    await WorkerDelegator()
                        .importScripts(const <String>['function.js']);

                    print(await WorkerDelegator().run(
                        'runHeavyTaskIWithtIsolateworkers',
                        [4000000000, 100000000]));
                  } else if (kIsWeb) {
                    print('web');
                    JsIsolatedWorker().run(
                        functionName: ['runHeavyTaskIWithtIsolateworkers'],
                        arguments: [4000000000, 100000000]).then((value) {
                      print(value);
                      JsIsolatedWorker().close();
                      setState(() {
                        values_iso_worker = value;
                      });
                    });
                    // print('fdsfdsfdsf' + values_iso_worker.toString());
                  } else {
                    print('mobile');
                    await IsolatedWorker()
                        .run(runHeavyTaskIWithtIsolateworkers, ([4000000000]))
                        .then((value) {
                      print(value);
                      IsolatedWorker().close();

                      setState(() {
                        values_iso_worker = value;
                      });
                    });

                    //print(tsst.toString());
                  }
                },
              ),
              Text(values1.toString()),
              const SizedBox(height: 50),
              ElevatedButton(
                child: const Text('Run Heavy Task - with compute'),
                onPressed: () async {
                  //computeFactorial(4);
                  //compute จำเป็นต้อง อยู่นอก state เลย
                  final data =
                      await compute(runHeavyTaskIWithoutIsolates, 4000000000);
                  values1 = data;
                  print(data);
                  setState(() {});
                },
              ),
              Text(values2.toString()),
              const SizedBox(height: 50),
              ElevatedButton(
                child: const Text('Run Heavy Task - with isolate.run'),
                onPressed: () async {
                  //computeFactorial(4);
                  //compute จำเป็นต้อง อยู่นอก state เลย
                  try {
                    final data = await Isolate.run(() async {
                      return runHeavyTaskIWithoutIsolaterun(4000000000);
                      // int value = 0;
                      // for (var i = 0; i < 40000000; i++) {
                      //   value += i;
                      // }

                      // values = value;
                      // return value;
                    });
                    values2 = data;
                    setState(() {});
                    // runHeavyTaskIWithoutIsolates(40000000));
                    print(data);
                  } on StateError catch (e, s) {
                    print(e.message);
                  }

                  // final data = await Isolate.run(runHeavyTaskIWithoutIsolaterun);
                  // print(data);

                  //print(data);
                },
              ),
              Text(values2.toString()),
              const SizedBox(height: 50),
              ElevatedButton(
                child: const Text(
                    'Run Heavy Task - with isolate.spawn communication'),
                onPressed: () async {
                  var mainToIsolateStream = await myMaininitIsolate();
                  mainToIsolateStream.send('This is from main() start ');
                },
              ),
              BlocBuilder<IsoBloc, IsoState>(
                builder: (context, state) {
                  if (state is IsoLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is IsoLoaded) {
                    return Text('bloc example: ${state.value}');
                  } else {
                    return const Text('');
                  }
                },
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                child: const Text('Run Heavy Task - Bloc'),
                onPressed: () => context.read<IsoBloc>()..add(IsocountEvent()),
              ),
              const SizedBox(height: 20),
              BlocBuilder<IsoCubit, IsoStates>(
                builder: (context, state) {
                  if (state is IsoLoadings) {
                    return const CircularProgressIndicator();
                  } else if (state is IsoLoadeds) {
                    return Text('cubit example: ${state.value}');
                  } else {
                    return const Text('');
                  }
                },
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                child: const Text('Run Heavy Task - Cubit'),
                onPressed: () => context.read<IsoCubit>().IsocountEvent(),
              ),
              const SizedBox(height: 20),
              Consumer(
                builder: (context, ref, child) {
                  final state = ref.watch(countProvider);
                  if (state is IsoLoadingss) {
                    return const CircularProgressIndicator();
                  } else if (state is IsoLoadedss) {
                    return Text('cubit example: ${state.value}');
                  } else {
                    return const Text('');
                  }
                },
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                child: const Text('Run Heavy Task - Riverpods'),
                onPressed: () =>
                    ref.read(countProvider.notifier).IsocountEvents(),
              )
            ],
          ),
        ),
      ),
    );
  }

  void runHeavyTaskIWithoutIsolate(List<int> args) {
    // SendPort resultPort = args[0];
    // Emitter emitt = args[2];
    int value = 0;
    for (var i = 0; i < args[0]; i++) {
      value += i;
    }

    values = value;

    //Isolate.exit(resultPort, value);
  }
}
//stateless
// class MyHomePage extends ConsumerWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Isolates'),
//         actions: <Widget>[
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => MyWidget(),
//                 ),
//               );
//             },
//             child: const Icon(Icons.abc),
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             const CircularProgressIndicator(),
//             const SizedBox(height: 50),
//             ElevatedButton(
//               child: const Text('Run Heavy Task - without Isolate'),
//               onPressed: () => runHeavyTaskIWithoutIsolate([4000000000]),
//             ),
//             BlocBuilder<IsoBloc, IsoState>(
//               builder: (context, state) {
//                 if (state is IsoLoading) {
//                   return const CircularProgressIndicator();
//                 } else if (state is IsoLoaded) {
//                   return Text('bloc example: ${state.value}');
//                 } else {
//                   return const Text('');
//                 }
//               },
//             ),
//             const SizedBox(height: 50),
//             ElevatedButton(
//               child: const Text('Run Heavy Task - Bloc'),
//               onPressed: () => context.read<IsoBloc>()..add(IsocountEvent()),
//             ),
//             const SizedBox(height: 20),
//             BlocBuilder<IsoCubit, IsoStates>(
//               builder: (context, state) {
//                 if (state is IsoLoadings) {
//                   return const CircularProgressIndicator();
//                 } else if (state is IsoLoadeds) {
//                   return Text('cubit example: ${state.value}');
//                 } else {
//                   return const Text('');
//                 }
//               },
//             ),
//             const SizedBox(height: 50),
//             ElevatedButton(
//               child: const Text('Run Heavy Task - Cubit'),
//               onPressed: () => context.read<IsoCubit>().IsocountEvent(),
//             ),
//             const SizedBox(height: 20),
//             Consumer(
//               builder: (context, ref, child) {
//                 final state = ref.watch(countProvider);
//                 if (state is IsoLoadingss) {
//                   return const CircularProgressIndicator();
//                 } else if (state is IsoLoadedss) {
//                   return Text('cubit example: ${state.value}');
//                 } else {
//                   return const Text('');
//                 }
//               },
//             ),
//             const SizedBox(height: 50),
//             ElevatedButton(
//               child: const Text('Run Heavy Task - Riverpods'),
//               onPressed: () =>
//                   ref.read(countProvider.notifier).IsocountEvents(),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          CircularProgressIndicator(),
          ElevatedButton(
              onPressed: () async {
                final value =
                    await compute(runHeavyTaskIWithoutIsolates, 4000000000);
                print(value);
                // computeFactorial(4000000000).then((value) => print(value));
              },
              child: Text('dsffs')),
          ElevatedButton(
              onPressed: () async {
                final value =
                    await compute(runHeavyTaskIWithoutIsolates, 4000000000);
                print(value);
                // computeFactorial(4000000000).then((value) => print(value));
              },
              child: Text('dsffs')),
          ElevatedButton(
              onPressed: () async {
                final value =
                    await compute(runHeavyTaskIWithoutIsolates, 4000000000);
                print(value);
                // computeFactorial(4000000000).then((value) => print(value));
              },
              child: Text('dsffs')),
        ],
      ),
      // body: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Consumer(
      //       builder: (context, ref, child) {
      //         final state = ref.watch(countProvider);
      //         if (state is IsoLoadingss) {
      //           return const CircularProgressIndicator();
      //         } else if (state is IsoLoadedss) {
      //           return Text('cubit example: ${state.value}');
      //         }

      //         return ElevatedButton(
      //           child: const Text('Run Heavy Task - Riverpods'),
      //           onPressed: () =>
      //               ref.read(countProvider.notifier).IsocountEvents(),
      //         );
      //       },
      //     ),
      //   ],
      // ),
    );
  }

  Future<bool> isPrime(int value) {
    return compute(_calculate, value);
  }

  bool _calculate(int value) {
    if (value == 1) {
      return false;
    }
    for (int i = 2; i < value; ++i) {
      if (value % i == 0) {
        return false;
      }
    }
    return true;
  }

  Future<int> computeFactorial(int n) async {
    return await compute(runHeavyTaskIWithoutIsolates, 4000000000);
  }

  int runHeavyTaskIWithoutIsolates(int values) {
    int value = 0;
    for (var i = 0; i < values; i++) {
      value += i;
    }

    //values = value;
    return value;
  }
}
