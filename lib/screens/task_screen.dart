import 'package:flutter/material.dart';
import 'package:todo_list_app/database/database_helper.dart';
import 'package:todo_list_app/models/user_task.dart';
import 'package:todo_list_app/screens/task_details_screen.dart';
import 'package:todo_list_app/widgets/task_item.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<UserTask> _taskList = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await DatabaseHelper.instance.getUserTasks();
    setState(() {
      _taskList = tasks;
    });
  }

  Future<void> _toggleTaskDone(UserTask task) async {
    final updatedTask = UserTask(
      id: task.id,
      userId: task.userId,
      title: task.title,
      description: task.description,
      isDone: !task.isDone,
    );

    await DatabaseHelper.instance.updateUserTask(updatedTask);
    await _loadTasks();
  }

  void _navigateToTaskDetailsScreen(UserTask task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailsScreen(task: task)),
    ).then((_) => _loadTasks());
  }

  Widget _buildTaskList(List<UserTask> tasks) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskItem(
          task: task,
          onChanged: (value) {
            _toggleTaskDone(task);
          },
          onTap: () => _navigateToTaskDetailsScreen(task),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: _buildTaskList(_taskList),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the add task screen
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
