import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/pet.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final VoidCallback onTap;

  const PetCard({
    super.key,
    required this.pet,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildPetImage(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    if (pet.category?.name != null)
                      Text(
                        'Category: ${pet.category!.name}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    const SizedBox(height: 4),
                    _buildStatusChip(),
                    const SizedBox(height: 8),
                    if (pet.tags != null && pet.tags!.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        children: pet.tags!
                            .take(3)
                            .map((tag) => Chip(
                                  label: Text(
                                    tag.name ?? '',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ))
                            .toList(),
                      ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetImage() {
    if (pet.photoUrls.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: pet.photoUrls.first,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: 80,
            height: 80,
            color: Colors.grey[300],
            child: const Icon(Icons.pets, size: 40),
          ),
          errorWidget: (context, url, error) => Container(
            width: 80,
            height: 80,
            color: Colors.grey[300],
            child: const Icon(Icons.pets, size: 40),
          ),
        ),
      );
    }
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.pets, size: 40),
    );
  }

  Widget _buildStatusChip() {
    Color chipColor;
    switch (pet.status) {
      case PetStatus.available:
        chipColor = Colors.green;
        break;
      case PetStatus.pending:
        chipColor = Colors.orange;
        break;
      case PetStatus.sold:
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor),
      ),
      child: Text(
        pet.status?.name.toUpperCase() ?? 'UNKNOWN',
        style: TextStyle(
          color: chipColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}