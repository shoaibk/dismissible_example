import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DismissibleListView(),
    );
  }
}

class DismissibleListView extends StatefulWidget {
  @override
  _DismissibleListViewState createState() => _DismissibleListViewState();
}

class _DismissibleListViewState extends State<DismissibleListView> {
  List<String> items = List.generate(10, (index) => 'Item ${index + 1}');
  String? recentlyDeletedItem;
  int? recentlyDeletedItemIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dismissible ListView with Undo'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return Card(
            color: Colors.grey,
            child: Dismissible(
              key: Key(item),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                // Save the deleted item and index
                recentlyDeletedItem = item;
                recentlyDeletedItemIndex = index;

                setState(() {
                  items.removeAt(index);
                });

                // Show SnackBar with Undo option
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$item dismissed'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        // Restore the deleted item
                        setState(() {
                          items.insert(
                              recentlyDeletedItemIndex!, recentlyDeletedItem!);
                        });
                      },
                    ),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
              background: Container(
                color: Colors.redAccent,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              child: ListTile(
                title: Text(item),
              ),
            ),
          );
        },
      ),
    );
  }
}
