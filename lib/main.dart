import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:todo_manager/db/todo_dao.dart';
import 'package:window_size/window_size.dart';

import 'db/database.dart';
import 'entity/todo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await $FloorAppDatabase
      .databaseBuilder('flutter_database.db')
      .build();
  final dao = database.todoDao;

  setupWindow();

  runApp(TodoManager(dao));
}

const double windowWidth = 480;
const double windowHeight = 854;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('todo Manager');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}


class TodoManager extends StatelessWidget {
  final TodoDao dao;

  const TodoManager(this.dao, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: TodoHome(dao),
    );
  }
}

class TodoHome extends StatelessWidget {
  final TodoDao dao;

  TodoHome(this.dao, {super.key});

  final titleController = TextEditingController();
  final contentController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
      ),
      body: TodoList(dao),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Add Todo'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                  ),
                  TextField(
                    controller: contentController,
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'Cancel');
                      titleController.clear();
                      contentController.clear();
                    },
                    child: const Text('Cancel'),
                ),
                TextButton(
                    onPressed: () {
                      final Todo newTodo = Todo(null, titleController.text, contentController.text);
                      dao.insertTodo(newTodo);
                      Navigator.pop(context, 'OK');
                      titleController.clear();
                      contentController.clear();
                    },
                    child: const Text('OK'),
                ),
              ],
            )
        ),
      ),
    );
  }
}

class TodoList extends StatelessWidget {
  final TodoDao dao;

  const TodoList(this.dao, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: dao.findAllTodoByStream(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) return Container();

          final todos = snapshot.requireData;

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (_, index) {
              return TodoItem(todos[index], dao);
            },
          );
        },
    );
  }
}

class TodoItem extends StatelessWidget {
  final TodoDao dao;
  final Todo todo;
  const TodoItem(this.todo, this.dao, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Text(todo.title),
          Text(todo.content),
          IconButton(
              onPressed: () => dao.deleteTodo(todo),
              icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}

