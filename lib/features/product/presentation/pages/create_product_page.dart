/**
 * Create Product Page
 */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopai_fe/core/theme/app_theme.dart';
import 'package:shopai_fe/features/product/presentation/bloc/product_bloc.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});

  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _categoryController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _categoryController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    final data = {
      'name': _nameController.text.trim(),
      'description': _descriptionController.text.trim(),
      'price': double.parse(_priceController.text.trim()),
      'stock': int.parse(_stockController.text.trim()),
      'category': _categoryController.text.trim().isNotEmpty ? _categoryController.text.trim() : null,
      'image_url': _imageUrlController.text.trim().isNotEmpty ? _imageUrlController.text.trim() : null,
    };
    BlocProvider.of<ProductBloc>(context, listen: false).add(CreateProductEvent(data));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductCreated) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Product created successfully"),
              backgroundColor: AppTheme.successColor,
            ),
          );
        } else if (state is ProductError) {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          elevation: 0,
          leading: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
          title: const Text('Create Product', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: _isSubmitting
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                  : ElevatedButton(onPressed: _isSubmitting ? null : _handleSubmit, style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, padding: const EdgeInsets.symmetric(horizontal: 20)), child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(color: AppTheme.skyBlueLight.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    Container(width: 60, height: 60, decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.add_box, color: AppTheme.primaryColor)),
                    const SizedBox(width: 16),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Create New Product', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.skyBlueDark, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text('Fill in the details below', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.skyBlueDark.withOpacity(0.7)))]))
                  ],
                ),
              ),
              Text('Product Name *', style: TextStyle(color: AppTheme.textColor, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter product name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.skyBlue.withOpacity(0.3))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.skyBlue.withOpacity(0.3))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2)),
                  filled: true, fillColor: AppTheme.skyBlueLight.withOpacity(0.05),
                  prefixIcon: Icon(Icons.label, color: AppTheme.skyBlueDark),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a product name' : null,
              ),
              const SizedBox(height: 20),
              Text('Description', style: TextStyle(color: AppTheme.textColor, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Describe your product...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.skyBlue.withOpacity(0.3))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.skyBlue.withOpacity(0.3))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2)),
                  filled: true, fillColor: AppTheme.skyBlueLight.withOpacity(0.05),
                ),
              ),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Price *', style: TextStyle(color: AppTheme.textColor, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: '0.00', prefixText: '\$',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.skyBlue.withOpacity(0.3))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.skyBlue.withOpacity(0.3))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2)),
                      filled: true, fillColor: AppTheme.skyBlueLight.withOpacity(0.05),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Required' : double.tryParse(value) == null ? 'Invalid price' : null,
                  ),
                ])),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Stock *', style: TextStyle(color: AppTheme.textColor, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _stockController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '0',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.skyBlue.withOpacity(0.3))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.skyBlue.withOpacity(0.3))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2)),
                      filled: true, fillColor: AppTheme.skyBlueLight.withOpacity(0.05),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Required' : int.tryParse(value) == null ? 'Invalid stock' : null,
                  ),
                ])),
              ]),
              const SizedBox(height: 20),
              Text('Category', style: TextStyle(color: AppTheme.textColor, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  hintText: 'e.g., Electronics, Clothing...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.skyBlue.withOpacity(0.3))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.skyBlue.withOpacity(0.3))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2)),
                  filled: true, fillColor: AppTheme.skyBlueLight.withOpacity(0.05),
                  prefixIcon: Icon(Icons.category, color: AppTheme.skyBlueDark),
                ),
              ),
              const SizedBox(height: 20),
              Text('Image URL', style: TextStyle(color: AppTheme.textColor, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  hintText: 'https://example.com/image.jpg',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.skyBlue.withOpacity(0.3))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.skyBlue.withOpacity(0.3))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2)),
                  filled: true, fillColor: AppTheme.skyBlueLight.withOpacity(0.05),
                  prefixIcon: Icon(Icons.image, color: AppTheme.skyBlueDark),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}