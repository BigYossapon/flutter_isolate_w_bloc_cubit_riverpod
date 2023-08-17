import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isolates_demo/cubit/iso_cubit.dart';

import 'bloc/iso_bloc.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Isolates'),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MyWidget()), // Replace NewPage with your new page's class
                );
              },
              child: Icon(Icons.abc))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<IsoBloc, IsoState>(
              builder: (context, state) {
                if (state is IsoLoading) {
                  return const CircularProgressIndicator();
                } else if (state is IsoLoaded) {
                  return Text(state.value.toString());
                } else {
                  return Text('');
                }
              },
            ),
            const SizedBox(height: 50),
            ElevatedButton(
                child: const Text('Run Heavy Task'),
                onPressed: () => //useIsolate(),
                    //runHeavyTaskWithOutIsolate(4000000000),
                    context.read<IsoBloc>()..add(IsocountEvent())),
            BlocBuilder<IsoCubit, IsoStates>(
              builder: (context, state) {
                if (state is IsoLoadings) {
                  return const CircularProgressIndicator();
                } else if (state is IsoLoadeds) {
                  return Text(state.value.toString());
                } else {
                  return Text('');
                }
              },
            ),
            const SizedBox(height: 50),
            ElevatedButton(
                child: const Text('Run Heavy Task'),
                onPressed: () => //useIsolate(),
                    //runHeavyTaskWithOutIsolate(4000000000),
                    context.read<IsoCubit>().IsocountEvent())
            // context.read<IsoBloc>()..add(IsocountEvent())),
          ],
        ),
      ),
    );
  }
}

int runHeavyTaskWithOutIsolate(int count) {
  int value = 0;
  for (var i = 0; i < count; i++) {
    value += i;
  }
  print(value);
  return value;
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('data'),
      ),
    );
  }
}
