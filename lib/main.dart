import 'package:flutter/material.dart';
import 'database/dbHelper.dart';
import 'Models/dish.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite CRUD',
      home: DishPage(),
    );
  }
}

class DishPage extends StatefulWidget {
  @override
  _DishPageState createState() => _DishPageState();
}

class _DishPageState extends State<DishPage> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  List<Dish> dishes = [];
  Dish? selectedDish;

  void _refresh() async {
    final data = await DBHelper.instance.readAll();
    setState(() {
      dishes = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text('SQLite CRUD'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: 'Price',
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text('Create'),
                  onPressed: () async {
                    final name = nameController.text;
                    final description = descriptionController.text;
                    final price = double.tryParse(priceController.text) ?? 0;

                    if (name.isEmpty || description.isEmpty || price <= 0) return;

                    await DBHelper.instance.create(
                      Dish(name: name, description: description, price: price),
                    );
                    _refresh();
                    nameController.clear();
                    descriptionController.clear();
                    priceController.clear();
                    selectedDish = null;
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text('Read'),
                  onPressed: _refresh,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: Text('Update'),
                  onPressed: () async {
                    if (selectedDish == null) return;

                    final name = nameController.text;
                    final description = descriptionController.text;
                    final price = double.tryParse(priceController.text) ?? 0;

                    if (name.isEmpty || description.isEmpty || price <= 0) return;

                    await DBHelper.instance.update(
                      Dish(
                        id: selectedDish!.id,
                        name: name,
                        description: description,
                        price: price,
                      ),
                    );
                    _refresh();
                    selectedDish = null;
                    nameController.clear();
                    descriptionController.clear();
                    priceController.clear();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('Delete'),
                  onPressed: () async {
                    if (selectedDish == null) return;
                    await DBHelper.instance.delete(selectedDish!.id!);
                    _refresh();
                    selectedDish = null;
                    nameController.clear();
                    descriptionController.clear();
                    priceController.clear();
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: dishes.length,
                itemBuilder: (context, index) {
                  final dish = dishes[index];
                  return Card(
                    color: Colors.grey[850],
                    child: ListTile(
                      title: Text('Name: ${dish.name}', style: TextStyle(color: Colors.white)),
                      subtitle: Text(
                        'Description: ${dish.description}\nPrice: ${dish.price}',
                        style: TextStyle(color: Colors.white70),
                      ),
                      onTap: () {
                        setState(() {
                          selectedDish = dish;
                          nameController.text = dish.name;
                          descriptionController.text = dish.description;
                          priceController.text = dish.price.toString();
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
