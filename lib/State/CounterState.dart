import 'package:get/state_manager.dart';

class CounterState {
  RxInt count;

  CounterState() {
    count = 2.obs;
  }
}
