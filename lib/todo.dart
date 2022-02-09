import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Product {
  String id;
  String item;
  bool isSelected;

  Product({required this.item, this.isSelected = false, required this.id});

  @override
  String toString() {
    return 'Product(item: $item, completed: $isSelected, id: $id)';
  }
}

class ProductList extends StateNotifier<List<Product>> {
  ProductList([List<Product>? initialProducts]) : super(initialProducts ?? []);

  void add(String item) {
    state = [...state,
      Product(
        item: item,
        id: DateTime.now().millisecondsSinceEpoch.toString()
      ),
    ];
  }

  void toggle(String id) {
    state = [
      for (final prod in state)
        if (prod.id == id)
          Product(
            id: prod.id,
            isSelected: !prod.isSelected,
            item: prod.item,
          )
        else
          prod,
    ];
  }
}

class ProductListT extends StateNotifier<List<Product>> {
  ProductListT([List<Product>? initialProds]) : super(initialProds ?? []);

  void add(String item) {
    [...state, Product(item: item, id: DateTime.now().millisecondsSinceEpoch.toString())];
  }

  void toggle(String id) {
    state = [
      for (final prod in state)
        if (prod.id == id)
          Product(id: prod.id, isSelected: !prod.isSelected, item: prod.item)
        else
          prod,
    ];
  }
}