import 'package:equatable/equatable.dart';

class Tag extends Equatable {
  final int? id;
  final String? name;

  const Tag({
    this.id,
    this.name,
  });

  @override
  List<Object?> get props => [id, name];

  Tag copyWith({
    int? id,
    String? name,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}