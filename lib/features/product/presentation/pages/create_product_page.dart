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

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    context.read<ProductBloc>().add(
          CreateProductEvent({
            'name': _nameController.text.trim(),
            'description': _descriptionController.text.trim(),
            'price': double.parse(_priceController.text.trim()),
            'stock': int.parse(_stockController.text.trim()),
            'category': _categoryController.text.trim(),
            'image_url': _imageUrlController.text.trim(),
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductActionSuccess) {
          setState(() => _isSubmitting = false);

          context.read<ProductBloc>().add(const LoadProductsEvent());

          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Product created successfully"),
              backgroundColor: AppTheme.successColor,
            ),
          );
        }

        if (state is ProductError) {
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
        appBar: AppBar(title: const Text("Create Product")),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(controller: _nameController),
              TextFormField(controller: _descriptionController),
              TextFormField(controller: _priceController),
              TextFormField(controller: _stockController),
              TextFormField(controller: _categoryController),
              TextFormField(controller: _imageUrlController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _handleSubmit,
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}