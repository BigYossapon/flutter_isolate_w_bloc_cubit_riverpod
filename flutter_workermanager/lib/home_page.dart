import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:isolate_manager/isolate_manager.dart';
import 'package:isolated_worker/isolated_worker.dart';
import 'package:isolated_worker/js_isolated_worker.dart';
import 'package:isolated_worker/worker_delegator.dart';

import 'package:squadron/squadron.dart';
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
import 'fibonacci/fib_service.dart';
import 'riverpod/iso_riverpod.dart';
import 'riverpod/iso_state.dart';
import 'dart:core';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

Future<int> runHeavyTaskIWithtworkermanager(List<dynamic> args) async {
  int value = 0;
  for (var i = 0; i < args[0]; i++) {
    value += i;
  }

  return value;
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
                onPressed: () async {
                  await runHeavyTaskIWithoutIsolate([4000000000])
                      .then((value) => setState(() {
                            values = value;
                          }));
                },
              ),
              Text(values_worker_manager.toString()),
              const SizedBox(height: 50),
              ElevatedButton(
                  child: const Text(
                      'Run Heavy Task - with worker manager not true '),
                  onPressed: () async {
                    workerManager.execute(() =>
                        runHeavyTaskIWithtworkermanager([4000000000])
                            .then((value) => setState(() {
                                  values_worker_manager = value;
                                })));
                    // Cancelable<dynamic> cancelable =
                    //     workerManager.executeWithPort<dynamic, String>(
                    //   (SendPort sendPort) async {
                    //     // Your CPU-intensive function here
                    //     await runHeavyTaskIWithtworkermanager([4000000000])
                    //         .then((value) {
                    //       setState(() {
                    //         values_worker_manager = value;
                    //       });
                    //     });
                    //     // Use sendPort.send(message) to communicate with the main isolate
                    //   },
                    //   onMessage: (String message) {
                    //     // Handle the received message in the main isolate
                    //   },
                    // );
                  }),
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

  Future<int> runHeavyTaskIWithoutIsolate(List<int> args) async {
    // SendPort resultPort = args[0];
    // Emitter emitt = args[2];
    int value = 0;
    for (var i = 0; i < args[0]; i++) {
      value += i;
    }

    return value;
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

Future computeWith(FibService service, int start, int count) async {
  final sw = Stopwatch()..start();
  // start all computations
  final computations = Iterable<int>.generate(count)
      .map((i) => service.fibonacci(start + i))
      .toList();
  // wait for results
  final results = await Future.wait(computations);
  // display results
  print('  * Results = $results');
  print('  * Total elapsed time: ${sw.elapsed}');
}

class Monitor {
  Monitor(this.duration);

  final Duration duration;
  int _lastTick = 0;
  Timer? _timer;

  void _tick(Timer t) {
    final d = t.tick - _lastTick;
    print((d > 1)
        ? '  tick #${t.tick} - skipped $d ticks!'
        : '  tick #${t.tick}...');
    _lastTick = t.tick;
  }

  Future<void> start() async {
    _timer = Timer.periodic(duration, _tick);
    await Future.delayed(duration);
    print('Timer started');
  }

  Future<void> stop() async {
    await Future.delayed(duration);
    _timer?.cancel();
    _timer = null;
    print('Timer stopped');
  }
}

extension DebugStats on WorkerStat {
  String dump() =>
      'totalWorkload=$totalWorkload (max $maxWorkload) - upTime=$upTime - idleTime=$idleTime - status=$status';
}

class Mynew extends StatefulWidget {
  const Mynew({super.key});

  @override
  State<Mynew> createState() => _MynewState();
}

class _MynewState extends State<Mynew> {
  final computeResults = [];
  final executorResults = [];
  var computeTaskRun = 0;
  var executorTaskRun = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Fibonacci calculation of 43 "),
            const CircularProgressIndicator(),
            Row(
              children: [
                Text(computeTaskRun.toString()),
                Spacer(),
                Text(executorTaskRun.toString()),
              ],
            ),
            const SizedBox(
              height: 200,
            ),
            Text('Results'),
            Row(
              children: [
                Text(computeResults.length.toString()),
                Spacer(),
                Text(executorResults.length.toString()),
              ],
            ),
            Row(
              children: [
                TextButton(
                  child: Text('run compute'),
                  onPressed: () {
                    for (var i = 0; i < 100; i++) {
                      compute(runHeavyTaskIWithoutIsolates, 4000000000)
                          .then((value) {
                        setState(() {
                          computeResults.add(value);
                        });
                      });
                    }
                  },
                ),
                Spacer(),
                TextButton(
                  child: Text('run executor'),
                  onPressed: () {
                    for (var i = 0; i < 100; i++) {
                      workerManager
                          .execute(
                              () => runHeavyTaskIWithoutIsolates(4000000000))
                          .then((value) {
                        setState(() {
                          executorResults.add(value);
                        });
                      });
                    }
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

int fib(int n) {
  if (n < 2) {
    return n;
  }
  return fib(n - 2) + fib(n - 1);
}

int fibCompute(int n) {
  if (n < 2) {
    return n;
  }
  return fibCompute(n - 2) + fibCompute(n - 1);
}
