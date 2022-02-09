import 'package:code_heroes_test/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

final Color PRIMARY_COLOUR = Color(0xFFc7beff);
final Color ACCENT_COLOUR = Color(0xFF7363d7);
final Color CHECKBOX_COLOUR = Color(0xFF42ca99);
final Color BACKGROUND_COLOUR = Color(0xFFCDCDCD);

final isButtonEnabledProvider = StateProvider<bool>((_) => false);
final newProductProvider = StateProvider<String>((_) => '');

final productListProvider = StateNotifierProvider<ProductList, List<Product>>((ref) {
  return ProductList([
    Product(id: 'todo-0', item: 'item 2'),
    Product(id: 'todo-2', item: 'item 3'),
  ]);
});

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        unselectedWidgetColor: CHECKBOX_COLOUR,
      ),
      home: const Home(),
    );
  }
}

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Product> _shoppingList = ref.watch(productListProvider);
    print(_shoppingList);

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping list'),
        backgroundColor: PRIMARY_COLOUR,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: false,
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _shoppingList.length,
          itemBuilder: (context, index) {
            return ListItemCard(listItem: _shoppingList[index]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: CHECKBOX_COLOUR,
          size: 50.0,
        ),
        backgroundColor: Colors.white,
        onPressed: () {
          showAlertDialog(context, ref);
        },
      ),
    );
  }
  Future showAlertDialog(BuildContext context, WidgetRef ref) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add item'),
          content: TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder()
            ),
            onChanged: (val) {
              ref.read(newProductProvider.state).state = val;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: Text('Cancel', style: TextStyle(color: ACCENT_COLOUR),),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: ACCENT_COLOUR,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
              ),
              onPressed: () {
                ref.read(productListProvider.notifier).add(ref.read(newProductProvider.state).state);
                Navigator.pop(context);
              },
              child: Text('Confirm'),
            )
          ],
        );
      },
    );
  }
}

class ListItemCard extends ConsumerWidget {
  final Product listItem;

  const ListItemCard({Key? key, required this.listItem}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Checkbox(
                  checkColor: CHECKBOX_COLOUR,
                  value: listItem.isSelected,
                  onChanged: (val) {
                    ref.read(productListProvider.notifier).toggle(listItem.id);
                  }),
              Text(listItem.item, style: TextStyle(color: listItem.isSelected ? Colors.grey.shade300 : null),),
            ],
          ),
        ),
        Divider(color: Colors.black54),
      ],
    );
  }
}
