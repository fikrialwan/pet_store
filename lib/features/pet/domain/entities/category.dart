import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int? id;
  final String? name;

  const Category({
    this.id,
    this.name,
  });

  @override
  List<Object?> get props => [id, name];

  Category copyWith({
    int? id,
    String? name,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}