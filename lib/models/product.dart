import 'package:flutter/material.dart';

class Product {
  const Product(
    this.name,
    this.price,
    this.rating,
    this.reviews,
    this.image,
    this.category,
  );
  final String name;
  final int price;
  final String rating;
  final int reviews;
  final String image;
  final String category;
}

const storeProducts = <Product>[
  Product(
    'Sneakers Minimalis Nova One',
    899000,
    '4.9',
    128,
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=700&q=85',
    'Fashion',
  ),
  Product(
    'Ransel Urban Canvas Pack',
    649000,
    '4.8',
    95,
    'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=700&q=85',
    'Fashion',
  ),
  Product(
    'Jam Tangan Chrono Slate',
    1250000,
    '5.0',
    64,
    'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=700&q=85',
    'Aksesori',
  ),
  Product(
    'Kacamata Acetate Noir',
    429000,
    '4.7',
    82,
    'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=700&q=85',
    'Aksesori',
  ),
  Product(
    'Dompet Kulit Bifold Slim',
    320000,
    '4.9',
    210,
    'https://images.unsplash.com/photo-1627123424574-724758594e93?w=700&q=85',
    'Aksesori',
  ),
  Product(
    'Earphone Wireless Pod Pro',
    1150000,
    '4.8',
    140,
    'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?w=700&q=85',
    'Elektronik',
  ),
];

