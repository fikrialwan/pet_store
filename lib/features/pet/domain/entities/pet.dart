import 'package:equatable/equatable.dart';
import 'category.dart';
import 'tag.dart';

enum PetStatus { available, pending, sold }

class Pet extends Equatable {
  final int? id;
  final String name;
  final Category? category;
  final List<String> photoUrls;
  final List<Tag>? tags;
  final PetStatus? status;

  const Pet({
    this.id,
    required this.name,
    this.category,
    required this.photoUrls,
    this.tags,
    this.status,
  });

  @override
  List<Object?> get props => [id, name, category, photoUrls, tags, status];

  Pet copyWith({
    int? id,
    String? name,
    Category? category,
    List<String>? photoUrls,
    List<Tag>? tags,
    PetStatus? status,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      photoUrls: photoUrls ?? this.photoUrls,
      tags: tags ?? this.tags,
      status: status ?? this.status,
    );
  }
}