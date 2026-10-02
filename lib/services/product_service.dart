import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product.dart';

class ProductService {
  ProductService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _products =>
      _firestore.collection('products');

  Stream<List<Product>> watchProducts() {
    return _products.snapshots().map((snapshot) {
      final products = snapshot.docs
          .map(
            (doc) => Product.fromFirestore(
              doc.id,
              doc.data(),
            ),
          )
          .toList();

      products.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );

      return products;
    });
  }

  Future<void> addProduct(Product product) async {
    final document = _products.doc();

    await document.set({
      ...product.toFirestore(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateProduct(Product product) async {
    if (product.id.isEmpty) {
      throw ArgumentError('Product ID is required for update.');
    }

    await _products.doc(product.id).update({
      ...product.toFirestore(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteProduct(String productId) async {
    if (productId.isEmpty) {
      throw ArgumentError('Product ID is required for deletion.');
    }

    await _products.doc(productId).delete();
  }

  Future<Product?> findByBarcode(String barcode) async {
    final normalizedBarcode = barcode.trim();

    if (normalizedBarcode.isEmpty) {
      return null;
    }

    final result = await _products
        .where('barcode', isEqualTo: normalizedBarcode)
        .limit(1)
        .get();

    if (result.docs.isEmpty) {
      return null;
    }

    final document = result.docs.first;

    return Product.fromFirestore(
      document.id,
      document.data(),
    );
  }
}