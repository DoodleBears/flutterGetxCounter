import 'package:flutter/material.dart';
import 'package:flutter_counter_stream/Controller/CounterLogic.dart';
import 'package:flutter_counter_stream/State/CounterState.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
    // 当你需要用到 GetX 的 Router，snackbar 等
    // 跟routes有关的功能的时候，才需要写 GetMaterialApp

    // return GetMaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: MyHomePage(),
    // );
  }
}

class MyHomePage extends StatelessWidget {
  // 使用 Get.put() 初始化我们定义的 GetxController
  final CounterLogic counterLogic = Get.put(CounterLogic());
  final CounterLogicObx counterLogicObx = Get.put(CounterLogicObx());
  final CounterLogicSeperatedState counterLogicSeperatedState =
      Get.put(CounterLogicSeperatedState());
  // 将 state 分离时，为了获得state我们需要多一个步骤
  final CounterState counterState =
      Get.find<CounterLogicSeperatedState>().counterState;

  @override
  Widget build(BuildContext context) {
    print('build All');
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter in GetX'),
      ),
      body: Column(
        // we render many rows in a column
        // Vertically Center the texts
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 和 StatefulWidget 类似，只是用Builder来包裹，实际相应用的update()
          // update() 对应的 StatefulWidget 的 setState()
          GetBuilder<CounterLogic>(
            builder: (counterLogic) {
              print('build counter_1');
              return Text(
                '采用GetBuilder: 点击了 ${counterLogic.getCounter} 次',
                style: TextStyle(fontSize: 30.0),
                textAlign: TextAlign.center,
              );
            },
          ),
          Divider(
            color: Colors.black,
            height: 3.0,
          ),
          // GetX 会监听一个流，如这里便是 controller.count.value
          // 一旦流里面的value有改变，便会rebuild
          GetX<CounterLogicObx>(
            builder: (controller) {
              print('build counter_2');
              return Text(
                '采用GetX: 点击了 ${controller.count} 次',
                style: TextStyle(fontSize: 30.0),
                textAlign: TextAlign.center,
              );
            },
          ),
          // 下面这种写法也可以，使用GetX在输入GetxController的Class的时候都会有提示

          // GetX(
          //   builder: (CounterLogicObx controller) => Text(
          //     '采用GetX: 点击了 ${controller.count.value} 次',
          //     style: TextStyle(fontSize: 30.0),
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          Divider(
            color: Colors.black,
            height: 3.0,
          ),
          // Obx(()=>{}) 和 GetX 很类似，只是更简单了，省略了写builder
          // 但实际在引用value的时候没有提示，如下面的 counterLogicObx
          Obx(
            () {
              print('build counter_2');
              return Text(
                '采用Obx: 点击了 ${counterLogicObx.count} 次',
                style: TextStyle(fontSize: 30.0),
                textAlign: TextAlign.center,
              );
            },
          ),
          Divider(
            color: Colors.black,
            height: 3.0,
          ),
          Obx(
            () {
              print('build counter_3');
              return Text(
                '采用Obx(Seperated State): 点击了 ${counterState.count} 次',
                style: TextStyle(
                  fontSize: 30.0,
                ),
                textAlign: TextAlign.center,
              );
            },
          ),
          TextButton.icon(
            label: Text('Add'),
            icon: Icon(Icons.add),
            onPressed: () {
              counterLogic.increase();
              counterLogic.update();
              counterLogicObx.increase();
              counterLogicSeperatedState.increase();
            },
          ),
          TextButton.icon(
            label: Text('Substract'),
            icon: Icon(Icons.remove),
            onPressed: () {
              counterLogic.decrease();
              counterLogic.update();
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          counterLogic.increase();
          counterLogicObx.increase();
          counterLogicSeperatedState.increase();
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
