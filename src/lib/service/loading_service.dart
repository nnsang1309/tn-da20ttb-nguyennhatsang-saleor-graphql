import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class LoadingService {
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final Map<int, Timer> _taskTimers = {};
  int _loadingCounter = 0;
  int _taskIdCounter = 0;

  ValueNotifier<bool> get isLoading => _isLoading;

  int showLoading({int timeoutSeconds = 30}) {
    _loadingCounter++;
    _isLoading.value = true;

    // Tạo ID duy nhất cho mỗi tác vụ
    final int taskId = _taskIdCounter++;

    // Tạo một timer để tự động tắt loading cho tác vụ sau một khoảng thời gian (timeout)
    _taskTimers[taskId] = Timer(Duration(seconds: timeoutSeconds), () {
      _forceHideLoading(taskId);
    });

    return taskId;
  }

  void hideLoading(int taskId) {
    if (_taskTimers.containsKey(taskId)) {
      // Hủy timer khi tác vụ hoàn thành trước thời gian timeout
      _taskTimers[taskId]?.cancel();
      _taskTimers.remove(taskId);
    }

    if (_loadingCounter > 0) {
      _loadingCounter--;
    }

    if (_loadingCounter == 0) {
      _isLoading.value = false;
    }
  }

  void _forceHideLoading(int taskId) {
    if (_taskTimers.containsKey(taskId)) {
      _taskTimers[taskId]?.cancel();
      _taskTimers.remove(taskId);
    }

    if (_loadingCounter > 0) {
      _loadingCounter--;
    }

    if (_loadingCounter == 0) {
      _isLoading.value = false;
    }
  }
}
