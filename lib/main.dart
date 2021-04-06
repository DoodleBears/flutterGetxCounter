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
    // 跟routes有关的功能的时候，才需要写 GetMaterialApp, 这里我们没用到，所以两个都行

    // return GetMaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: MyHomePage(),
    // );
  }
}

// 可以看到我们这边用的 StatelessWidget
class MyHomePage extends StatelessWidget {
  // 使用 Get.put() 初始化我们定义的 GetxController
  // Get.put() source code 实作的方式，其实最后仍是用 find() 去 return 我们的 controller
  // Get.put() 便是在 put 到 HashMap 后立马用 Get.find() 得到并return
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
        mainAxisAlignment: MainAxisAlignment.start,
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
          Divider(color: Colors.black, height: 3.0),
          // GetX 会监听一个流，如这里便是 controller.count.value
          // 一旦流里面的value有改变，便会rebuild
          GetX<CounterLogicObx>(
            builder: (controller) {
              print('build counter_2 in GetX');
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
              print('build counter_2 in Obx');
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
          _Button(
            text: 'Add all',
            onPressed: () {
              print('---------------------------Add all');
              counterLogic.increase();
              counterLogic.update();
              counterLogicObx.increase();
              counterLogicSeperatedState.increase();
            },
          ),
          _Button(
            text: 'Add GetBuilder',
            onPressed: () {
              print('---------------------------Add GetBuilder');
              counterLogic.increase();
              counterLogic.update();
            },
          ),
          _Button(
            text: 'Add GetX and Obx',
            onPressed: () {
              print('---------------------------Add GetX and Obx');
              counterLogicObx.increase();
            },
          ),
          _Button(
            text: 'Add Obx (Seperated State)',
            onPressed: () {
              print('---------------------------Add Obx (Seperated State)');
              counterLogicSeperatedState.increase();
            },
          ),
          // substract button
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            width: double.infinity,
            height: 60.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: OutlinedButton.icon(
                label: Text(
                  'Substract all',
                  style: TextStyle(fontSize: 20.0),
                ),
                icon: Icon(Icons.remove),
                onPressed: () {
                  print('---------------------------Substract all');
                  counterLogic.decrease();
                  counterLogic.update();
                  counterLogicObx.decrease();
                  counterLogicSeperatedState.decrease();
                },
                style: TextButton.styleFrom(
                  primary: Colors.red,
                  backgroundColor: Colors.red[50],
                  side: BorderSide(width: 1.0, color: Colors.red),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // floating button
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          print('---------------------------Add all');
          counterLogic.increase();
          counterLogic.update(); // what if we don't call update(), try it out
          counterLogicObx.increase();
          counterLogicSeperatedState.increase();
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({Key key, @required this.onPressed, @required this.text})
      : super(key: key);
  final Function onPressed; // used to define button press effect(function)
  final String text; // text show on button

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      width: double.infinity,
      height: 60.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: OutlinedButton.icon(
          label: Text(
            text, // take text get from outside
            style: TextStyle(fontSize: 20.0),
          ),
          icon: Icon(Icons.add),
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue[50],
            side: BorderSide(width: 1.0, color: Colors.blue),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
            ),
          ),
          // take function get from outside
          onPressed: onPressed,
        ),
      ),
    );
  }
}
