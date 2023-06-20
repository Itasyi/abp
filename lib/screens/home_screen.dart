import 'package:flutter/material.dart';
import 'package:todo_list_app/database/database_helper.dart';
import 'package:todo_list_app/models/user_task.dart';
import 'package:todo_list_app/screens/task_details_screen.dart';
import 'package:todo_list_app/widgets/task_item.dart';
import 'package:todo_list_app/screens/add_task_screen.dart';
import 'package:todo_list_app/models/user.dart';

class HomeScreen extends StatefulWidget {
  final User? user;

  HomeScreen({this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserTask> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await DatabaseHelper.instance.getUserTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  void _navigateToTaskDetailsScreen(UserTask task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailsScreen(task: task)),
    ).then((_) => _loadTasks());
  }

  void _toggleTaskDone(UserTask task) async {
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

  Widget _buildTaskList(List<UserTask> tasks) {
    tasks.sort((a, b) => a.isDone ? 1 : -1); // Sort tasks with completed tasks at the bottom

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), // Add left and right padding
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return TaskItem(
            task: task,
            onChanged: (value) => _toggleTaskDone(task),
            onTap: () => _navigateToTaskDetailsScreen(task),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: _buildTaskList(_tasks),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white, // Set background color to white
        foregroundColor: Colors.teal, // Set content color
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
          _loadTasks(); // Load tasks after returning from AddTaskScreen
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // Center the floating action button
    );
  }
}
