import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/data/data.dart';
import 'package:to_do_list/data/repo/repository.dart';
import 'package:to_do_list/main.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskEntity task;
  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.task.name);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeData.colorScheme.surface,
        foregroundColor: themeData.colorScheme.onSurface,
        title: const Text('Edit Task'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          widget.task.name = _controller.text;
          widget.task.priority = widget.task.priority;
        final repository =Provider.of<Repository<TaskEntity>>(context,listen: false);
        repository.createOrUpdate(widget.task);
          Navigator.of(context).pop();
        },
        label: const Row(
          children: [
            Text('Save changes'),
            SizedBox(
              width: 5,
            ),
            Icon(
              CupertinoIcons.check_mark,
              size: 16,
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                  flex: 1,
                  child: PriorityCheckBox(
                    lable: 'Low',
                    color: lowPriority,
                    isSelected: widget.task.priority == Priority.low,
                    onTap: () {
                      setState(() {
                        widget.task.priority = Priority.low;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                  flex: 1,
                  child: PriorityCheckBox(
                    lable: 'Normal',
                    color: normalPriority,
                    isSelected: widget.task.priority == Priority.normal,
                    onTap: () {
                      setState(() {
                        widget.task.priority = Priority.normal;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                  flex: 1,
                  child: PriorityCheckBox(
                    lable: 'High',
                    color: highPriority,
                    isSelected: widget.task.priority == Priority.high,
                    onTap: () {
                      setState(
                        () {
                          widget.task.priority = Priority.high;
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                label: Text('Add Task for today ...',
                    style: themeData.textTheme.bodyText1!
                        .apply(fontSizeFactor: 1.2)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PriorityCheckBox extends StatelessWidget {
  final String lable;
  final Color color;
  final bool isSelected;
  final GestureTapCallback onTap;

  const PriorityCheckBox(
      {super.key,
      required this.lable,
      required this.color,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 2,
            color: themeData.colorScheme.primary.withOpacity(0.3),
          ),
          color: secondaryTextColor.withOpacity(0.2),
        ),
        child: Stack(children: [
          Center(
            child: Text(lable),
          ),
          Positioned(
            top: 0,
            right: 8,
            bottom: 0,
            child: Center(
              child: _CheckBoxShape(
                value: isSelected,
                color: color,
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class _CheckBoxShape extends StatelessWidget {
  final bool value;
  final Color color;
  const _CheckBoxShape({required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      child: value
          ? Icon(
              CupertinoIcons.check_mark,
              color: themeData.colorScheme.onPrimary,
              size: 12,
            )
          : null,
    );
  }
}
