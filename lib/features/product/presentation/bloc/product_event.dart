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

class CreateProductEvent extends ProductEvent {
  final Map<String, dynamic> data;

  const CreateProductEvent(this.data);

  @override
  List<Object> get props => [data];
}

class UpdateProductEvent extends ProductEvent {
  final String id;
  final Map<String, dynamic> data;

  const UpdateProductEvent(this.id, this.data);

  @override
  List<Object> get props => [id, data];
}

class DeleteProductEvent extends ProductEvent {
  final String id;

  const DeleteProductEvent(this.id);

  @override
  List<Object> get props => [id];
}

