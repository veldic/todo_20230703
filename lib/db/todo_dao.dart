import 'package:floor/floor.dart';
import 'package:todo_manager/entity/todo.dart';

@dao
abstract class TodoDao {
  @Query('SELECT * FROM todo WHERE id = :id')
  Future<Todo?> findTodoById(int id);
  
  @Query('SELECT * FROM todo')
  Future<List<Todo>> findAllTodo();

  @Query('SELECT * FROM todo')
  Stream<List<Todo>> findAllTodoByStream();

  @insert
  Future<void> insertTodo(Todo todo);

  @insert
  Future<void> insertTodos(List<Todo> todos);

  @delete
  Future<void> deleteTodo(Todo todo);

  @Query('DELETE FROM todo WHERE id = :id')
  Future<void> deleteTodoById(int id);



  
}