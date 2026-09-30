import '../models/product.dart';

const sampleProducts = <Product>[
  Product(
    id: 'p-001',
    name: 'Sparkling Water 500ml',
    sku: 'BEV-001',
    barcode: '9312345678901',
    category: 'Beverages',
    quantity: 24,
    lowStockThreshold: 8,
    price: 2.50,
  ),
  Product(
    id: 'p-002',
    name: 'Classic Potato Chips',
    sku: 'SNK-014',
    barcode: '9312345678902',
    category: 'Snacks',
    quantity: 6,
    lowStockThreshold: 10,
    price: 3.20,
  ),
  Product(
    id: 'p-003',
    name: 'Whole Milk 2L',
    sku: 'DRY-009',
    barcode: '9312345678903',
    category: 'Dairy',
    quantity: 12,
    lowStockThreshold: 5,
    price: 4.80,
  ),
  Product(
    id: 'p-004',
    name: 'Organic Bananas',
    sku: 'PRD-021',
    barcode: '9312345678904',
    category: 'Produce',
    quantity: 4,
    lowStockThreshold: 7,
    price: 5.10,
  ),
];
