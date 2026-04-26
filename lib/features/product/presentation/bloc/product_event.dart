/**
 * Product Events
 */
part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadProductsEvent extends ProductEvent {
  const LoadProductsEvent();

  @override
  List<Object> get props => [];
}
