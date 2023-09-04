import 'dart:async';

import 'package:squadron/squadron_annotations.dart';
import 'package:squadron/squadron.dart';

import 'fib_service.activator.g.dart';

part 'fib_service.worker.g.dart';

// @SquadronService(baseUrl: '/workers')
//@SquadronService(web: true)
// abstract class FibService {
//   @SquadronMethod()
//   FutureOr<dynamic> fibonacci(dynamic i);
// }
@SquadronService(baseUrl: '/workers')
class FibService extends WorkerService {
  @SquadronMethod()
  @override
  Future<dynamic> fibonacci(dynamic i) async => _fib(i);

  // naive & inefficient implementation of the Fibonacci sequence
  static int _fib(int i) => (i < 2) ? i : (_fib(i - 2) + _fib(i - 1));

  // command IDs
  static const getfibonacci = 1;
  @override
  // TODO: implement operations
  Map<int, CommandHandler> get operations => {
        getfibonacci: (WorkerRequest r) => fibonacci(r.args[0]),
      };
}
