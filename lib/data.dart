import 'package:hive/hive.dart';

part 'data.g.dart';




@HiveType(typeId: 1)
class Task extends HiveObject{
  @HiveField(0)
  String name = '';
  @HiveField(1)
  bool isComplited = false;
  @HiveField(2)
  Priority priority = Priority.low;
}


@HiveType(typeId: 2)
enum Priority {
  @HiveField(0)
  low,
  @HiveField(1)
  normal,
  @HiveField(2)
  high
}