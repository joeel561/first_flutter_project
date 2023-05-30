import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class Todo {
  Todo({required this.name, required this.completed});
  String name;
  bool completed;
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Losttaskmanager',
      theme: ThemeData(
        primaryColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffb232128)),
        scaffoldBackgroundColor: Color(0xffb232128),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(),
          bodyMedium: TextStyle(),
        ).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const TodoList(title: 'Losttaskmanager'),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<Todo> _todos = <Todo>[];
  final TextEditingController _textFieldController = TextEditingController();

  void _addTodoItem(String name) {
    setState(() {
      _todos.add(Todo(name: name, completed: false));
    });

    _textFieldController.clear();
  }

  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.completed = !todo.completed;
    });
  }

  void _deleteTodo(Todo todo) {
    setState(() {
      _todos.removeWhere((element) => element.name == todo.name);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        foregroundColor: Color(0xffbe9eff5),
        shape: const Border(
          bottom: BorderSide(
            color: Color(0xffb2c2a33),
            width: 1,
          ),
        ),
        // Here we take the value from the TodoList object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title.toUpperCase(),
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: TextField(
                      controller: _textFieldController,
                      decoration: const InputDecoration(
                          hintText: 'Type your todo',
                          hintStyle: TextStyle(
                              color: Color(0xffbe9eff5),
                              fontWeight: FontWeight.w300),
                          fillColor: Color(0xffbe9eff5),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(0)),
                      autofocus: false,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.white)),
                ),
                SizedBox(
                  height: 26,
                  width: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffbe9eff5),
                      foregroundColor: Color(0xffb2c2a33),
                      elevation: 0,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(0),
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                    onPressed: () {
                      _addTodoItem(_textFieldController.text);
                    },
                    child: const Icon(Icons.add,
                        size: 15, color: Color(0xffb2c2a33)),
                  ),
                ),
              ],
            ),
            Expanded(
              child: _todos.isEmpty
                  ? const Center(child: Text('No todos yet.'))
                  : ListView(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      shrinkWrap: true,
                      children: _todos.map((Todo todo) {
                        return TodoItem(
                          todo: todo,
                          onTodoChanged: _handleTodoChange,
                          onTodoDeleted: _deleteTodo,
                        );
                      }).toList(),
                    ),
            )
          ],
        ),
      ),
    );
  }
}

class TodoItem extends StatelessWidget {
  TodoItem(
      {required this.todo,
      required this.onTodoChanged,
      required this.onTodoDeleted})
      : super(key: ObjectKey(todo));

  final Todo todo;
  final void Function(Todo todo) onTodoChanged;
  final void Function(Todo todo) onTodoDeleted;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) {
      return const TextStyle(fontSize: 13, fontWeight: FontWeight.w400);
    }

    return const TextStyle(
        color: Color(0xffb7c7c85),
        decoration: TextDecoration.lineThrough,
        decorationColor: Color(0xffb7c7c85),
        fontWeight: FontWeight.w400,
        fontSize: 13);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      dense: true,
      minVerticalPadding: 0,
      onTap: () {
        onTodoChanged(todo);
      },
      contentPadding: EdgeInsets.all(0),
      leading: SizedBox(
        width: 23,
        child: Checkbox(
          checkColor: Color(0xffb2c2a33),
          activeColor: Color(0xffbe9eff5),
          value: todo.completed,
          side: MaterialStateBorderSide.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const BorderSide(
                color: Color(0xffbe9eff5),
                width: 1.2,
              );
            } else {
              return const BorderSide(
                color: Color(0xffb2c2a33),
                width: 1.2,
              );
            }
          }),
          onChanged: (value) {
            onTodoChanged(todo);
          },
        ),
      ),
      title: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              todo.name,
              style: _getTextStyle(todo.completed),
            ),
          ),
        ),
        SizedBox(
          height: 30,
          child: IconButton(
            iconSize: 18,
            icon: const Icon(
              Icons.close,
              color: Color(0xffb7c7c85),
            ),
            alignment: Alignment.centerRight,
            onPressed: () {
              onTodoDeleted(todo);
            },
          ),
        ),
      ]),
    );
  }
}
