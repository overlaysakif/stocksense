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
}
