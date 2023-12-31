import 'package:flutter/material.dart';
import 'package:todo_list_app/database/database_helper.dart';
import 'package:todo_list_app/models/user_task.dart';
import 'package:todo_list_app/screens/task_details_screen.dart';
import 'package:todo_list_app/widgets/task_item.dart';

class TaskDetailsScreen extends StatefulWidget {
  final UserTask task;

  TaskDetailsScreen({required this.task});

  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  bool _isEditing = false;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() async {
    final updatedTask = UserTask(
      id: widget.task.id,
      title: _titleController.text,
      description: _descriptionController.text,
      isDone: widget.task.isDone,
    );

    await DatabaseHelper.instance.updateUserTask(updatedTask);

    setState(() {
      widget.task.title = _titleController.text;
      widget.task.description = _descriptionController.text;
      _isEditing = false;
    });
  }

  void _deleteTask() async {
    final taskId = widget.task.id ?? 0; // Use 0 as the default value if widget.task.id is null
    await DatabaseHelper.instance.deleteUserTask(taskId);
    Navigator.pop(context); // Navigate back to the previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        actions: [
          IconButton(
            onPressed: _deleteTask,
            icon: Icon(Icons.delete),
          ),
          IconButton(
            onPressed: _isEditing ? _saveChanges : _toggleEdit,
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Title',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20, 
              ),
            ),
            SizedBox(height: 8),
            _isEditing
                ? TextField(controller: _titleController)
                : Text(
              widget.task.title,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Description',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 8),
            _isEditing
                ? TextField(controller: _descriptionController)
                : Text(
              widget.task.description,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
