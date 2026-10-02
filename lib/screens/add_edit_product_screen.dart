import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/product_service.dart';

class AddEditProductScreen extends StatefulWidget {
  const AddEditProductScreen({
    super.key,
    required this.productService,
    this.product,
  });

  final ProductService productService;
  final Product? product;

  @override
  State<AddEditProductScreen> createState() =>
      _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _categoryController = TextEditingController();
  final _quantityController = TextEditingController();
  final _thresholdController = TextEditingController();
  final _priceController = TextEditingController();

  bool _isSaving = false;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();

    final product = widget.product;

    if (product != null) {
      _nameController.text = product.name;
      _skuController.text = product.sku;
      _barcodeController.text = product.barcode;
      _categoryController.text = product.category;
      _quantityController.text = product.quantity.toString();
      _thresholdController.text = product.lowStockThreshold.toString();
      _priceController.text = product.price.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _barcodeController.dispose();
    _categoryController.dispose();
    _quantityController.dispose();
    _thresholdController.dispose();
    _priceController.dispose();

    super.dispose();
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    return null;
  }

  String? _wholeNumber(String? value) {
    final requiredError = _required(value);

    if (requiredError != null) {
      return requiredError;
    }

    final parsed = int.tryParse(value!.trim());

    if (parsed == null || parsed < 0) {
      return 'Enter a valid whole number';
    }

    return null;
  }

  String? _money(String? value) {
    final requiredError = _required(value);

    if (requiredError != null) {
      return requiredError;
    }

    final parsed = double.tryParse(value!.trim());

    if (parsed == null || parsed < 0) {
      return 'Enter a valid price';
    }

    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final product = Product(
      id: widget.product?.id ?? '',
      name: _nameController.text.trim(),
      sku: _skuController.text.trim(),
      barcode: _barcodeController.text.trim(),
      category: _categoryController.text.trim(),
      quantity: int.parse(_quantityController.text.trim()),
      lowStockThreshold: int.parse(_thresholdController.text.trim()),
      price: double.parse(_priceController.text.trim()),
    );

    try {
      if (_isEditing) {
        await widget.productService.updateProduct(product);
      } else {
        await widget.productService.addProduct(product);
      }

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Could not update product: $error'
                : 'Could not save product: $error',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit product' : 'Add product',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            Text(
              _isEditing ? 'Update product' : 'Product information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              _isEditing
                  ? 'Update the inventory information for this product.'
                  : 'Enter the information needed to create an inventory record.',
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 22),
            TextFormField(
              controller: _nameController,
              validator: _required,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Product name',
                prefixIcon: Icon(Icons.inventory_2_outlined),
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _skuController,
              validator: _required,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'SKU',
                prefixIcon: Icon(Icons.tag_rounded),
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _barcodeController,
              validator: _required,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Barcode / QR value',
                prefixIcon: Icon(Icons.qr_code_rounded),
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _categoryController,
              validator: _required,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category_outlined),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _quantityController,
                    validator: _wholeNumber,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _thresholdController,
                    validator: _wholeNumber,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Low-stock level',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _priceController,
              validator: _money,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Unit price',
                prefixText: '\$ ',
              ),
            ),
            const SizedBox(height: 26),
            FilledButton.icon(
              onPressed: _isSaving ? null : _save,
              icon: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : Icon(
                      _isEditing
                          ? Icons.update_rounded
                          : Icons.save_outlined,
                    ),
              label: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                child: Text(
                  _isSaving
                      ? (_isEditing ? 'Updating...' : 'Saving...')
                      : (_isEditing
                          ? 'Update product'
                          : 'Save product'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}