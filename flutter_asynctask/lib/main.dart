import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isolated_worker/js_isolated_worker.dart';
import 'package:worker_manager/worker_manager.dart';

import 'bloc/iso_bloc.dart';
import 'cubit/iso_cubit.dart';
import 'home_page.dart';

void main() async {
  if (kIsWeb) {
    final bool loaded = await JsIsolatedWorker().importScripts(['function.js']);
    print(loaded);
  }

  WidgetsFlutterBinding.ensureInitialized();
  workerManager.log = true;
  await workerManager.init();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Isolate.spawn
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Isolates',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => IsoBloc()),
          BlocProvider(create: (_) => IsoCubit()),
        ],
        child: MyHomePage(),
      ),
    );
  }
}


//isolate flutter
// มี3 แบบ
// 1. compute ไม่ต้องจัดการอะไรเลยแค่ใส่ไว้จัดการที่ไม่ซับซ้อนไม่ติดต่อisoอื่นไปมาควรใช้ final data = await compute(function,arguementที่จะส่งในfunction);
// 2. isolate.run 
//   Isolate.run ใช้สำหรับเรียกใช้ฟังก์ชันใน isolate หลัก (main isolate) โดยจะรอให้ฟังก์ชันนั้นทำงานเสร็จก่อนที่จะดำเนินการต่อ
//   คุณสามารถใช้ await เพื่อรอรับผลลัพธ์จากฟังก์ชันใน isolate
//   ใช้สำหรับงานที่ไม่จำเป็นต้องทำงานพร้อมกันหลาย isolate และไม่ต้องการควบคุมการทำงานใน isolate อื่นๆ 
//   สรุป ใช้คล้ายๆcompute แต่ตัวนี้จะเริ่มทำงานหลังบ้านเมื่อการทำงานใน iso main เสร็จแล้วที่ทำอยู่ขณะเรียกน่ะถ้าไม่มีก็ทำเลย ณ เวลานั้น
// 3. isolate.spawn
//   Isolate.spawn ใช้สำหรับสร้าง isolate ใหม่และเริ่มการทำงานของฟังก์ชันใน isolate ใหม่โดยที่ไม่จำเป็นต้องรอให้ฟังก์ชันนั้นเสร็จสมบูรณ์
//   ใช้สำหรับงานที่ต้องการทำงานพร้อมกันหลาย isolate เพื่อประมวลผลข้อมูลที่ใหญ่หรือคำนวณที่ซับซ้อน
//   คุณสามารถใช้ SendPort ในการสื่อสารกับ isolate ที่ถูกสร้างด้วย Isolate.spawn
//   สรุป สั่งทำงานตอนนั้นได้ ณ เวลานั้นและทำการพร้อมกันได้ทั้งหมดและ สามารถพูดคุยกันระหว่าง isolate ได้ด้วย sendport and recieve port