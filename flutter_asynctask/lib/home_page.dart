import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'package:async_task/async_task.dart';
import 'package:async_task/async_task_extension.dart';
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

Future<int> runHeavyTaskIWithasynctask(List<int> args) async {
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

List<AsyncTask> _taskTypeRegister() => [PrimeChecker(0)];

List<AsyncTask> _taskTypeRegisters() =>
    [PrimeCheckers(0, SharedData<List<int>, List<int>>([]))];

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
  int values_iso_manager4 = 0;
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
              Text(values_iso_manager4.toString()),
              const SizedBox(height: 50),
              ElevatedButton(
                  child: const Text(
                      'Run Heavy Task - with worker manager without extension '),
                  onPressed: () async {
                    var knownPrimes =
                        SharedData<List<int>, List<int>>([2, 3, 5]);

                    // The tasks to execute:
                    var tasks = [
                      PrimeCheckers(0, knownPrimes), // Not Prime
                      PrimeCheckers(1, knownPrimes), // Not Prime
                      PrimeCheckers(2, knownPrimes),
                      PrimeCheckers(5, knownPrimes),
                      PrimeCheckers(7, knownPrimes),
                      PrimeCheckers(11, knownPrimes),
                      PrimeCheckers(21, knownPrimes), // Not Prime
                      PrimeCheckers(31, knownPrimes),
                      PrimeCheckers(41, knownPrimes),
                      PrimeCheckers(51, knownPrimes), // Not Prime
                      PrimeCheckers(61, knownPrimes),
                      PrimeCheckers(71, knownPrimes),
                      PrimeCheckers(81, knownPrimes), // Not Prime
                      PrimeCheckers(8779, knownPrimes),
                      PrimeCheckers(1046527, knownPrimes),
                      PrimeCheckers(3139581, knownPrimes), // Not Prime
                      PrimeCheckers(4000000000, knownPrimes),
                    ];

                    var asyncExecutor = AsyncExecutor(
                      sequential: false, // Non-sequential tasks.
                      parallelism: 2, // Concurrency with 2 threads.
                      taskTypeRegister:
                          _taskTypeRegister, // The top-level function to register the tasks types.
                    );

                    // Enable logging output:
                    asyncExecutor.logger.enabled = true;
                    // Enable logging output with execution information:
                    asyncExecutor.logger.enabledExecution = true;

                    // Execute all tasks:
                    var executions = asyncExecutor.executeAll(tasks);

                    // Wait tasks executions:
                    await Future.wait(executions);

                    for (var task in tasks) {
                      var n = task.n; // Number to check for prime.
                      var prime = task.result; // Task result: true if is prime.
                      print('$n\t-> $prime \t $task');
                    }

                    // Close the executor.
                    await asyncExecutor.close();
                  }),
              Text(values_iso_manager3.toString()),
              const SizedBox(height: 50),
              ElevatedButton(
                child: const Text(
                    'Run Heavy Task - with async task with extension'),
                onPressed: () async {
                  var tasks = [
                    PrimeChecker(4000000000),
                    PrimeChecker(4000000000),
                    PrimeChecker(4000000000), // Not Prime
                    PrimeChecker(4000000000),
                  ];
                  var asyncExecutor = AsyncExecutor(
                    sequential: false, // Non-sequential tasks.
                    parallelism: 2, // Concurrency with 2 threads.
                    taskTypeRegister:
                        _taskTypeRegister, // The top-level function to register the tasks types.
                  );
                  asyncExecutor.logger.enabled = true;
                  asyncExecutor.logger.enabledExecution = true;

                  // Execute and wait tasks results:
                  await tasks.executeAndWaitTasks(asyncExecutor);

                  // List of tasks with errors:
                  var errorTasks = tasks.errorTasks;

                  for (var task in errorTasks) {
                    print('ERROR> $task');
                  }

                  // List of finished tasks
                  var finishedTasks = tasks.finishedTasks;

                  for (var task in finishedTasks) {
                    var n = task.n;
                    var prime = task.result;
                    print('$n\t-> $prime \t $task');
                  }

                  // Close the executor.
                  await asyncExecutor.close();
                },
              ),
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

class PrimeChecker extends AsyncTask<int, int> {
  // The number to check if is prime.
  final int n;

  PrimeChecker(this.n);

  // Instantiates a `PrimeChecker` task with `parameters`.
  @override
  AsyncTask<int, int> instantiate(int parameters,
      [Map<String, SharedData>? sharedData]) {
    return PrimeChecker(parameters);
  }

  // The parameters of this task:
  @override
  int parameters() {
    return n;
  }

  // Runs the task code:
  @override
  FutureOr<int> run() {
    return isPrime(n);
  }

  // A simple prime check function:
  // int isPrime(int n) {
  //   if (n < 2) return false;

  //   // It's sufficient to search for prime factors in the range [1,sqrt(N)]:
  //   var limit = (sqrt(n) + 1).toInt();

  //   for (var p = 2; p < limit; ++p) {
  //     if (n % p == 0) return false;
  //   }

  //   return true;
  // }

  int isPrime(int args) {
    int value = 0;
    for (var i = 0; i < args; i++) {
      value += i;
    }
    print('==============================');
    return value;
  }
}

class PrimeCheckers extends AsyncTask<int, int> {
  // The number to check if is prime.
  final int n;

  // A list of known primes, shared between tasks.
  final SharedData<List<int>, List<int>> knownPrimes;

  PrimeCheckers(this.n, this.knownPrimes);

  // Instantiates a `PrimeChecker` task with `parameters` and `sharedData`.
  @override
  PrimeCheckers instantiate(int parameters,
      [Map<String, SharedData>? sharedData]) {
    return PrimeCheckers(
      parameters,
      sharedData!['knownPrimes'] as SharedData<List<int>, List<int>>,
    );
  }

  // The `SharedData` of this task.
  @override
  Map<String, SharedData> sharedData() => {'knownPrimes': knownPrimes};

  // Loads the `SharedData` from `serial` for each key.
  @override
  SharedData<List<int>, List<int>> loadSharedData(String key, dynamic serial) {
    switch (key) {
      case 'knownPrimes':
        return SharedData<List<int>, List<int>>(serial);
      default:
        throw StateError('Unknown key: $key');
    }
  }

  // The parameters of this task:
  @override
  int parameters() {
    return n;
  }

  // Runs the task code:
  @override
  FutureOr<int> run() {
    return isPrime(n);
  }

  // A simple prime check function:
  int isPrime(int args) {
    int value = 0;
    for (var i = 0; i < args; i++) {
      value += i;
    }
    print('==============================');
    return value;
  }
  // int isPrime(int n) {
  //   if (n < 2) return false;

  //   // The pre-computed primes, optimizing this checking algorithm:
  //   if (knownPrimes.data.contains(n)) {
  //     return true;
  //   }

  //   // If a number N has a prime factor larger than `sqrt(N)`,
  //   // then it surely has a prime factor smaller `sqrt(N)`.
  //   // So it's sufficient to search for prime factors in the range [1,sqrt(N)]:
  //   var limit = (sqrt(n) + 1).toInt();

  //   for (var p = 2; p < limit; ++p) {
  //     if (n % p == 0) return false;
  //   }

  //   return true;
  // }
}
