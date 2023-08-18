import 'dart:convert';
import 'dart:isolate';
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
      body: Center(
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
