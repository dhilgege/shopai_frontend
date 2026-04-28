/**
 * Product BLoC
 */
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopai_fe/core/usecases/usecase.dart';
import 'package:shopai_fe/features/product/domain/entities/product.dart';
import 'package:shopai_fe/features/product/domain/usecases/get_products.dart';
import 'package:shopai_fe/features/product/domain/usecases/create_product.dart';
import 'package:shopai_fe/features/product/domain/usecases/update_product.dart';
import 'package:shopai_fe/features/product/domain/usecases/delete_product.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;
  final CreateProduct createProduct;
  final UpdateProduct updateProduct;
  final DeleteProduct deleteProduct;

  ProductBloc({
    required this.getProducts,
    required this.createProduct,
    required this.updateProduct,
    required this.deleteProduct,
  }) : super(ProductInitial()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<CreateProductEvent>(_onCreateProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    final result = await getProducts(NoParams());
    result.fold(
      (failure) => emit(ProductError(failure.toString())),
      (products) => emit(ProductsLoaded(products)),
    );
  }

  Future<void> _onCreateProduct(
    CreateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    final result = await createProduct(event.data);
    result.fold(
      (failure) => emit(ProductError(failure.toString())),
      (product) {
        emit(ProductCreated(product));
        add(LoadProductsEvent());
      },
    );
  }

  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    final result = await updateProduct(event.id, event.data);
    result.fold(
      (failure) => emit(ProductError(failure.toString())),
      (product) {
        emit(ProductUpdated(product));
        add(LoadProductsEvent());
      },
    );
  }

  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    final result = await deleteProduct(event.id);
    result.fold(
      (failure) => emit(ProductError(failure.toString())),
      (_) {
        emit(ProductDeleted(event.id));
        add(LoadProductsEvent());
      },
    );
  }
}

