import 'package:flutter/material.dart';
import 'package:todo_list_app/models/user_task.dart';

class TaskItem extends StatelessWidget {
  final UserTask task;
  final Function(bool?) onChanged;
  final VoidCallback onTap;

  const TaskItem({
    required this.task,
    required this.onChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = task.isDone
        ? Colors.white.withOpacity(0.5) // Set the opacity to 50%
        : Colors.white;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: cardColor,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title, // Title
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                fontSize: 18.0,
                decoration: task.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
            SizedBox(height: 4.0),
            if (task.description.isNotEmpty)
              Text(
                task.description, // Desc
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14.0,
                  color: Colors.grey.shade600,
                ),
              ),
          ],
        ),
        trailing: Checkbox(
          value: task.isDone,
          onChanged: onChanged,
        ),
        onTap: onTap,
      ),
    );
  }
}
