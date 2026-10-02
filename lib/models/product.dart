class Product {
  const Product({
    required this.id,
    required this.name,
    required this.sku,
    required this.barcode,
    required this.category,
    required this.quantity,
    required this.lowStockThreshold,
    required this.price,
  });

  final String id;
  final String name;
  final String sku;
  final String barcode;
  final String category;
  final int quantity;
  final int lowStockThreshold;
  final double price;

  bool get isLowStock => quantity <= lowStockThreshold;

  factory Product.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    return Product(
      id: id,
      name: data['name']?.toString() ?? '',
      sku: data['sku']?.toString() ?? '',
      barcode: data['barcode']?.toString() ?? '',
      category: data['category']?.toString() ?? '',
      quantity: _toInt(data['quantity']),
      lowStockThreshold: _toInt(data['minStock']),
      price: _toDouble(data['price']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name.trim(),
      'sku': sku.trim(),
      'barcode': barcode.trim(),
      'category': category.trim(),
      'quantity': quantity,
      'minStock': lowStockThreshold,
      'price': price,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? sku,
    String? barcode,
    String? category,
    int? quantity,
    int? lowStockThreshold,
    double? price,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      price: price ?? this.price,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();

    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}