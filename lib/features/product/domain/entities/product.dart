/**
 * Product Entity - Domain Model
 */
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String? imageUrl;
  final String? category;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    this.imageUrl,
    this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  Product copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    int? stock,
    String? imageUrl,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get displayPrice => 'Rp ${price.toStringAsFixed(0)}';

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  String get safeCategory => category ?? 'Uncategorized';

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        stock,
        imageUrl,
        category,
        createdAt,
        updatedAt,
      ];
}