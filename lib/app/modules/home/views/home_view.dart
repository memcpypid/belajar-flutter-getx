import 'package:belajar_flutter_get/app/data/models/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildStatsRow(),
            _buildFilterBar(),
            Expanded(child: _buildTodoList()),
          ],
        ),
      ),
      floatingActionButton: _buildFab(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Tasks',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Obx(
                () => Text(
                  '${controller.activeTodos} tugas tersisa',
                  style: const TextStyle(
                    color: Color(0xFF8B8FA8),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF48C6EF)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Obx(() {
      final total = controller.totalTodos;
      final completed = controller.completedTodos;
      final progress = total == 0 ? 0.0 : completed / total;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF48C6EF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildStatChip('Total', total.toString()),
                const SizedBox(width: 12),
                _buildStatChip('Selesai', completed.toString()),
                const SizedBox(width: 12),
                _buildStatChip('Aktif', controller.activeTodos.toString()),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              '${(progress * 100).toInt()}% Selesai',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 8,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(
              () => Row(
                children: [
                  _buildFilterChip(
                    'Semua',
                    'all',
                    controller.filterStatus.value,
                    controller.setFilter,
                  ),
                  _buildFilterChip(
                    'Aktif',
                    'active',
                    controller.filterStatus.value,
                    controller.setFilter,
                  ),
                  _buildFilterChip(
                    'Selesai',
                    'completed',
                    controller.filterStatus.value,
                    controller.setFilter,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Priority filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(
              () => Row(
                children: [
                  _buildPriorityFilterChip(
                    'Semua',
                    'all',
                    controller.filterPriority.value,
                  ),
                  _buildPriorityFilterChip(
                    'Tinggi',
                    'high',
                    controller.filterPriority.value,
                  ),
                  _buildPriorityFilterChip(
                    'Sedang',
                    'medium',
                    controller.filterPriority.value,
                  ),
                  _buildPriorityFilterChip(
                    'Rendah',
                    'low',
                    controller.filterPriority.value,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String value,
    String current,
    Function(String) onTap,
  ) {
    final isSelected = current == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C63FF) : const Color(0xFF1E1E30),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6C63FF)
                : const Color(0xFF2E2E45),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF8B8FA8),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityFilterChip(String label, String value, String current) {
    final isSelected = current == value;
    Color priorityColor = _getPriorityColor(value);
    return GestureDetector(
      onTap: () => controller.setPriorityFilter(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? priorityColor.withValues(alpha: 0.2)
              : const Color(0xFF1E1E30),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? priorityColor : const Color(0xFF2E2E45),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (value != 'all') ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: priorityColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? priorityColor : const Color(0xFF8B8FA8),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodoList() {
    return Obx(() {
      final items = controller.filteredTodos;
      if (items.isEmpty) {
        return _buildEmptyState();
      }
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _buildTodoCard(items[index]);
        },
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt_rounded,
            size: 80,
            color: const Color(0xFF2E2E45),
          ),
          const SizedBox(height: 16),
          const Text(
            'Tidak ada tugas',
            style: TextStyle(
              color: Color(0xFF8B8FA8),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tekan + untuk menambahkan tugas baru',
            style: TextStyle(color: Color(0xFF5A5A7A), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildTodoCard(TodoModel todo) {
    final priorityColor = _getPriorityColor(todo.priority);
    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade800,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete_rounded, color: Colors.white, size: 28),
      ),
      onDismissed: (_) => controller.deleteTodo(todo.id),
      child: GestureDetector(
        onTap: () => _showEditDialog(todo),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: todo.isCompleted
                  ? const Color(0xFF2E2E45)
                  : priorityColor.withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => controller.toggleTodo(todo.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: todo.isCompleted
                          ? const Color(0xFF6C63FF)
                          : Colors.transparent,
                      border: Border.all(
                        color: todo.isCompleted
                            ? const Color(0xFF6C63FF)
                            : const Color(0xFF3E3E5E),
                        width: 2,
                      ),
                    ),
                    child: todo.isCompleted
                        ? const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 16,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.title,
                        style: TextStyle(
                          color: todo.isCompleted
                              ? const Color(0xFF5A5A7A)
                              : Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          decorationColor: const Color(0xFF5A5A7A),
                        ),
                      ),
                      if (todo.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          todo.description,
                          style: TextStyle(
                            color: todo.isCompleted
                                ? const Color(0xFF3E3E5E)
                                : const Color(0xFF8B8FA8),
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: priorityColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: priorityColor.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Text(
                              _getPriorityLabel(todo.priority),
                              style: TextStyle(
                                color: priorityColor,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.access_time_rounded,
                            color: const Color(0xFF5A5A7A),
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(todo.createdAt),
                            style: const TextStyle(
                              color: Color(0xFF5A5A7A),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _showEditDialog(todo),
                  child: const Icon(
                    Icons.edit_rounded,
                    color: Color(0xFF3E3E5E),
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton.extended(
      onPressed: () => _showAddDialog(),
      backgroundColor: const Color(0xFF6C63FF),
      elevation: 8,
      icon: const Icon(Icons.add_rounded, color: Colors.white),
      label: const Text(
        'Tambah Tugas',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  void _showAddDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final RxString priority = 'medium'.obs;

    Get.bottomSheet(
      _buildFormSheet(
        title: 'Tambah Tugas Baru',
        titleController: titleController,
        descController: descController,
        priority: priority,
        onSubmit: () {
          controller.addTodo(
            title: titleController.text,
            description: descController.text,
            priority: priority.value,
          );
          Get.back();
        },
        submitLabel: 'Tambah',
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _showEditDialog(TodoModel todo) {
    final titleController = TextEditingController(text: todo.title);
    final descController = TextEditingController(text: todo.description);
    final RxString priority = todo.priority.obs;

    Get.bottomSheet(
      _buildFormSheet(
        title: 'Edit Tugas',
        titleController: titleController,
        descController: descController,
        priority: priority,
        onSubmit: () {
          controller.updateTodo(
            id: todo.id,
            title: titleController.text,
            description: descController.text,
            priority: priority.value,
          );
          Get.back();
        },
        submitLabel: 'Simpan',
        onDelete: () {
          Get.back();
          controller.deleteTodo(todo.id);
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildFormSheet({
    required String title,
    required TextEditingController titleController,
    required TextEditingController descController,
    required RxString priority,
    required VoidCallback onSubmit,
    required String submitLabel,
    VoidCallback? onDelete,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF3E3E5E),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (onDelete != null)
                  GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.delete_rounded,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            // Title field
            _buildTextField(
              controller: titleController,
              label: 'Judul Tugas',
              hint: 'Apa yang ingin dikerjakan?',
              icon: Icons.title_rounded,
            ),
            const SizedBox(height: 14),
            // Description field
            _buildTextField(
              controller: descController,
              label: 'Deskripsi (opsional)',
              hint: 'Tambahkan deskripsi...',
              icon: Icons.notes_rounded,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            // Priority selector
            const Text(
              'Prioritas',
              style: TextStyle(
                color: Color(0xFF8B8FA8),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Obx(
              () => Row(
                children: [
                  _buildPriorityOption('high', 'Tinggi', priority),
                  const SizedBox(width: 10),
                  _buildPriorityOption('medium', 'Sedang', priority),
                  const SizedBox(width: 10),
                  _buildPriorityOption('low', 'Rendah', priority),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  submitLabel,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8B8FA8),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF5A5A7A)),
            prefixIcon: Icon(icon, color: const Color(0xFF6C63FF), size: 20),
            filled: true,
            fillColor: const Color(0xFF0F0F1A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFF6C63FF),
                width: 1.5,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 14 : 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityOption(String value, String label, RxString current) {
    final isSelected = current.value == value;
    final color = _getPriorityColor(value);
    return Expanded(
      child: GestureDetector(
        onTap: () => current.value = value,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.2)
                : const Color(0xFF0F0F1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : const Color(0xFF2E2E45),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? color : const Color(0xFF8B8FA8),
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return const Color(0xFFFF6B6B);
      case 'medium':
        return const Color(0xFFFFBE0B);
      case 'low':
        return const Color(0xFF4ECDC4);
      default:
        return const Color(0xFF8B8FA8);
    }
  }

  String _getPriorityLabel(String priority) {
    switch (priority) {
      case 'high':
        return 'Tinggi';
      case 'medium':
        return 'Sedang';
      case 'low':
        return 'Rendah';
      default:
        return priority;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Hari ini';
    if (diff.inDays == 1) return 'Kemarin';
    return '${diff.inDays} hari lalu';
  }
}
