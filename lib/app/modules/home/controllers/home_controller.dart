import 'package:belajar_flutter_get/app/core/theme/app_colors.dart';
import 'package:belajar_flutter_get/app/data/models/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxList<TodoModel> todos = <TodoModel>[].obs;
  final RxString filterStatus = 'all'.obs; // 'all', 'active', 'completed'
  final RxString filterPriority = 'all'.obs; // 'all', 'low', 'medium', 'high'

  // Theme
  final RxBool isDarkMode = true.obs;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;

    AppColors.setTheme(dark: isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  // Stats
  int get totalTodos => todos.length;
  int get completedTodos => todos.where((t) => t.isCompleted).length;
  int get activeTodos => todos.where((t) => !t.isCompleted).length;

  List<TodoModel> get filteredTodos {
    List<TodoModel> result = todos.toList();

    // Filter by status
    if (filterStatus.value == 'active') {
      result = result.where((t) => !t.isCompleted).toList();
    } else if (filterStatus.value == 'completed') {
      result = result.where((t) => t.isCompleted).toList();
    }

    // Filter by priority
    if (filterPriority.value != 'all') {
      result = result.where((t) => t.priority == filterPriority.value).toList();
    }

    return result;
  }

  @override
  void onInit() {
    super.onInit();
    // Add sample todos
    _addSampleTodos();
  }

  void _addSampleTodos() {
    todos.addAll([
      TodoModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Belajar Flutter GetX',
        description: 'Pelajari state management menggunakan GetX',
        isCompleted: true,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        priority: 'high',
      ),
      TodoModel(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        title: 'Membuat aplikasi Todo List',
        description: 'Buat aplikasi todo list dengan fitur CRUD lengkap',
        isCompleted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        priority: 'high',
      ),
      TodoModel(
        id: (DateTime.now().millisecondsSinceEpoch + 2).toString(),
        title: 'Belajar GetX Routing',
        description: 'Pahami cara navigasi antar halaman dengan GetX',
        isCompleted: false,
        createdAt: DateTime.now(),
        priority: 'medium',
      ),
      TodoModel(
        id: (DateTime.now().millisecondsSinceEpoch + 3).toString(),
        title: 'Baca dokumentasi GetX',
        description: '',
        isCompleted: false,
        createdAt: DateTime.now(),
        priority: 'low',
      ),
    ]);
  }

  void addTodo({
    required String title,
    String description = '',
    String priority = 'medium',
  }) {
    if (title.trim().isEmpty) return;
    final todo = TodoModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
      description: description.trim(),
      isCompleted: false,
      createdAt: DateTime.now(),
      priority: priority,
    );
    todos.insert(0, todo);
    Get.snackbar(
      'Berhasil!',
      'Todo "${todo.title}" telah ditambahkan',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void toggleTodo(String id) {
    final index = todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      final todo = todos[index];
      todos[index] = todo.copyWith(isCompleted: !todo.isCompleted);
      todos.refresh();
    }
  }

  void deleteTodo(String id) {
    final todo = todos.firstWhereOrNull((t) => t.id == id);
    if (todo != null) {
      todos.removeWhere((t) => t.id == id);
      Get.snackbar(
        'Dihapus!',
        '"${todo.title}" telah dihapus',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void updateTodo({
    required String id,
    required String title,
    String description = '',
    String priority = 'medium',
  }) {
    if (title.trim().isEmpty) return;
    final index = todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      todos[index] = todos[index].copyWith(
        title: title.trim(),
        description: description.trim(),
        priority: priority,
      );
      todos.refresh();
      Get.snackbar(
        'Diperbarui!',
        'Todo berhasil diperbarui',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void clearCompleted() {
    todos.removeWhere((t) => t.isCompleted);
  }

  void setFilter(String status) {
    filterStatus.value = status;
  }

  void setPriorityFilter(String priority) {
    filterPriority.value = priority;
  }
}
