import 'package:flutter/material.dart'; 


class Dish {
  final int? id;
  final String name;
  final String description;
  final double price;

  Dish({
    this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
    };
  }
factory Dish.fromMap(Map<String, dynamic> map) {
  return Dish(
    id: map['id'],
    name: map['name'] ?? '',
    description: map['description'] ?? '',
    price: map['price'] != null ? map['price'].toDouble() : 0.0,
  );
}

  Dish copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
  }) {
    return Dish(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
    );
  }
}
