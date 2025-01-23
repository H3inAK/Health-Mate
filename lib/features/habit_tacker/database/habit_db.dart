import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/habit_model.dart';

class HabitDatabase {
  static final HabitDatabase instance = HabitDatabase._init();

  static Database? _database;

  HabitDatabase._init();

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDB('habits.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'INTEGER NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
          CREATE TABLE habits (
            id $idType,
            title $textType,
            description $textType,
            completed $boolType,
            priority $textType,
            icon $textType,
            repeat $textType,
            created_at $intType,
            updated_at $intType
          )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db
          .execute('ALTER TABLE habits ADD COLUMN completed INTEGER DEFAULT 0');
    }
  }

  Future<Habit> create(Habit habit) async {
    final db = await instance.database;
    final id = await db!.insert('habits', habit.toMap());
    print("create habit => ${habit.copyWith(id: id)}");
    return habit.copyWith(id: id);
  }

  Future<Habit> readHabit(int id) async {
    final db = await instance.database;
    final maps = await db!.query('habits', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Habit.fromMap(maps.first);
    } else {
      throw Exception("ID $id not found");
    }
  }

  Future<List<Habit>> readAllHabits({DateTime? selectedDate}) async {
    final db = await instance.database;

    // Use current date as default if selectedDate is not provided
    selectedDate ??= DateTime.now();

    // Get today's date for comparison
    final today = DateTime.now();
    final isToday = selectedDate.year == today.year &&
        selectedDate.month == today.month &&
        selectedDate.day == today.day;

    if (isToday) {
      // Fetch all habits if the selected date is today
      final result = await db!.query(
        'habits',
        orderBy: 'created_at DESC',
      );
      return result.map((json) => Habit.fromMap(json)).toList();
    } else {
      // Otherwise, fetch habits for the specific selected date
      final startOfDay =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      final endOfDay = DateTime(
          selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);

      final result = await db!.query(
        'habits',
        where: 'created_at BETWEEN ? AND ?',
        whereArgs: [
          startOfDay.millisecondsSinceEpoch,
          endOfDay.millisecondsSinceEpoch,
        ],
        orderBy: 'created_at DESC',
      );
      return result.map((json) => Habit.fromMap(json)).toList();
    }
  }

  Future<int> updateCompletedStatus(int id, bool completed) async {
    final db = await instance.database;

    return db!.update(
      'habits',
      {
        'completed': completed ? 1 : 0,
        'updated_at': DateTime.now().millisecondsSinceEpoch
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(Habit habit) async {
    final db = await instance.database;

    return db!.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return db!.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db!.close();
  }
}
