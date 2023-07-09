import 'package:floor/floor.dart';

@entity
class Todo {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String title;
  final String content;

  Todo(this.id, this.title, this.content);

}