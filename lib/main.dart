// 导入 MaterialApp 和其他组件，我们可以使用它们来快速创建 Material 应用程序
import 'package:flutter/material.dart';

void main() => runApp(new TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(title: 'Todo List', home: new TodoList());
  }
}

class TodoList extends StatefulWidget {
  @override
  createState() => new TodoListState();
}

class TodoListState extends State<TodoList> {
  List<String> _todoItems = [];

  // 每按一次 + 按钮，都会调用这个方法
  void _addTodoItem(String task) {
    // 仅在用户实际输入内容时添加任务
    if (task.length > 0) {
      setState(() => _todoItems.add(task));
    }
  }

  // 与 _addTodoItem 非常类似，它会修改待办事项的字符串数组，
// 并通过使用 setState 通知应用程序状态已更改
  void _removeTodoItem(int index) {
    setState(() => _todoItems.removeAt(index));
  }

// 显示警告对话框，询问用户任务是否已完成
  void _promptRemoveTodoItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Text('Mark "${_todoItems[index]}" as done?'),
              actions: <Widget>[
                new FlatButton(
                    child: new Text('CANCEL'),
                    onPressed: () => Navigator.of(context).pop()),
                new FlatButton(
                    child: new Text('MARK AS DONE'),
                    onPressed: () {
                      _removeTodoItem(index);
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  // 构建一个待办事项
  Widget _buildTodoItem(String todoText, int index) {
    return new ListTile(
        title: new Text(todoText), onTap: () => _promptRemoveTodoItem(index));
  }

  // 构建整个待办事项列表
  Widget _buildTodoList() {
    return new ListView.builder(
      itemBuilder: (context, index) {
        // itemBuilder 将被自动调用，因为列表需要多次填充其可用空间
        // 而这很可能超过我们拥有的待办事项数量。
        // 所以，我们需要检查索引是否正确。
        if (index < _todoItems.length) {
          return _buildTodoItem(_todoItems[index], index);
        }
      },
    );
  }

  void _pushAddTodoScreen() {
    // 将此页面推入任务栈
    Navigator.of(context).push(
        // MaterialPageRoute 会自动为屏幕条目设置动画
        // 并添加后退按钮以关闭它
        new MaterialPageRoute(builder: (context) {
      return new Scaffold(
          appBar: new AppBar(title: new Text('Add a new task')),
          body: new TextField(
            autofocus: true,
            onSubmitted: (val) {
              _addTodoItem(val);
              Navigator.pop(context); // Close the add todo screen
            },
            decoration: new InputDecoration(
                hintText: 'Enter something to do...',
                contentPadding: const EdgeInsets.all(16.0)),
          ));
    }));
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Todo List')),
      body: _buildTodoList(),
      floatingActionButton: new FloatingActionButton(
          onPressed: _pushAddTodoScreen,
          // pressing this button now opens the new screen
          tooltip: 'Add task',
          child: new Icon(Icons.add)),
    );
  }
}
