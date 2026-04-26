/**
 * Product BLoC
 */
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopai_fe/core/usecases/usecase.dart';
import 'package:shopai_fe/features/product/domain/entities/product.dart';
import 'package:shopai_fe/features/product/domain/usecases/get_products.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;

  ProductBloc({required this.getProducts}) : super(ProductInitial()) {
    on<LoadProductsEvent>(_onLoadProducts);
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
}
