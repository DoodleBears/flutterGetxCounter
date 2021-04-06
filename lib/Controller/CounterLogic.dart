import 'package:flutter_counter_stream/State/CounterState.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

class CounterLogic extends GetxController {
  var _count = 0;
  int get getCounter {
    return _count;
  }

  void increase() {
    ++_count;
  }

  void decrease() {
    --_count;
  }
}

class CounterLogicObx extends GetxController {
  // 使用 .obs 则代表使用【观察者模式】观察这个 Stream
  var count = 1.obs;

  void increase() => ++count;
}

class CounterLogicSeperatedState extends GetxController {
  // 我们将 counter 的 state 进行分离，让logic层专注于逻辑，忽略数据
  // 这里表现为，我们不会看到 count 的初始化的实际code，这些由 State 完成
  final CounterState counterState = CounterState();

  void increase() => ++counterState.count;
}
