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

Future<int> runHeavyTaskIWithoutIsolaterun(int args) async {
  int value = 0;
  for (var i = 0; i < args; i++) {
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
                onPressed: () {
                  runHeavyTaskIWithoutIsolate([4000000000]);
                  setState(() {});
                },
              ),
              Text(values_iso_manager.toString()),
              const SizedBox(height: 50),
              ElevatedButton(
                child: const Text('Run Heavy Task - with squadron'),
                onPressed: () async {
                  final monitor = Monitor(const Duration(seconds: 1));
                  await monitor.start();

                  // compute 9 fibonnaci numbers (starting from 37)
                  int count = 9, start = 37;

                  print('''

Computing with FibService (single-threaded, main Isolate)
  The main Isolate is busy computing the numbers.
  The timer won't trigger.
''');
                  final service = FibService();
                  await computeWith(service, start, count);

                  print('''

Computing with FibServiceWorker (single-threaded, 1 dedicated Isolate)
  The main Isolate is available while the worker Isolate is computing numbers.
  The computation time should be roughly the same as with FibService.
  The timer triggers periodically.
''');
                  final worker = FibServiceWorker();
                  await worker.start();
                  await computeWith(worker, start, count);
                  print(
                      '  * Stats for worker ${worker.workerId}: ${worker.stats.dump()}');
                  worker.stop();

                  final maxWorkers = count ~/ 2;

                  print('''

Computing with FibServiceWorkerPool (multi-threaded, $maxWorkers dedicated Isolate)
  The main Isolate is available while worker pool Isolates are computing numbers.
  The computation time should be significantly less compared to FibService and FibServiceWorker.
  The timer triggers periodically.
''');
                  final concurrency = ConcurrencySettings(
                      minWorkers: 1, maxWorkers: maxWorkers, maxParallel: 1);
                  final pool =
                      FibServiceWorkerPool(concurrencySettings: concurrency);
                  await pool.start();
                  await computeWith(pool, start, count);
                  print(pool.fullStats
                      .map((s) =>
                          '  * Stats for pool worker ${s.id}: ${s.dump()}')
                      .join('\n'));
                  pool.stop();

                  print('');
                  await monitor.stop();
                },
              ),
              Text(values.toString()),
              const SizedBox(height: 50),
              ElevatedButton(
                child: const Text('Run Heavy Task - with squadron test '),
                onPressed: () async {
                  final w = FibServiceWorker();
                  await w.start();
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
