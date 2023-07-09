// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'todo_dao.dart';
import '../entity/todo.dart';

part 'database.g.dart';

@Database(version: 1, entities: [Todo])
abstract class AppDatabase extends FloorDatabase {
  TodoDao get todoDao;
}