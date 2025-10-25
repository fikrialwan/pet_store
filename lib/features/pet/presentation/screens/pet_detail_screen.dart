import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../bloc/pet_bloc.dart';
import '../bloc/pet_event.dart';
import '../bloc/pet_state.dart';
import '../../domain/entities/pet.dart';
import '../../../store/domain/entities/order.dart' as entities;
import '../../../store/domain/usecases/place_order.dart';
import '../../../../injection_container.dart';

class PetDetailScreen extends StatefulWidget {
  final String petId;

  const PetDetailScreen({super.key, required this.petId});

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PetBloc>().add(LoadPetById(petId: int.parse(widget.petId)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<PetBloc, PetState>(
        builder: (context, state) {
          if (state is PetLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PetDetailLoaded) {
            return _buildPetDetails(state.pet);
          } else if (state is PetError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.message}',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PetBloc>().add(
                        LoadPetById(petId: int.parse(widget.petId)),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: BlocBuilder<PetBloc, PetState>(
        builder: (context, state) {
          if (state is PetDetailLoaded && state.pet.status == PetStatus.available) {
            return FloatingActionButton.extended(
              onPressed: () => _showCheckoutDialog(state.pet),
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Adopt Pet'),
              backgroundColor: Colors.green,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildPetDetails(Pet pet) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageGallery(pet.photoUrls),
          const SizedBox(height: 24),
          Text(
            pet.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoCard('Pet ID', pet.id?.toString() ?? 'N/A'),
          const SizedBox(height: 12),
          if (pet.category != null)
            _buildInfoCard('Category', pet.category!.name ?? 'N/A'),
          const SizedBox(height: 12),
          _buildStatusCard(pet.status),
          const SizedBox(height: 16),
          if (pet.tags != null && pet.tags!.isNotEmpty) ...[
            Text(
              'Tags',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: pet.tags!
                  .map((tag) => Chip(
                        label: Text(tag.name ?? ''),
                        backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImageGallery(List<String> photoUrls) {
    if (photoUrls.isEmpty) {
      return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets, size: 64, color: Colors.grey),
            SizedBox(height: 8),
            Text('No images available'),
          ],
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: photoUrls.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: photoUrls[index],
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, size: 48),
                      Text('Failed to load image'),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              '$label: ',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(PetStatus? status) {
    Color statusColor;
    String statusText;

    switch (status) {
      case PetStatus.available:
        statusColor = Colors.green;
        statusText = 'Available';
        break;
      case PetStatus.pending:
        statusColor = Colors.orange;
        statusText = 'Pending';
        break;
      case PetStatus.sold:
        statusColor = Colors.red;
        statusText = 'Sold';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Unknown';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              'Status: ',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: statusColor),
              ),
              child: Text(
                statusText.toUpperCase(),
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCheckoutDialog(Pet pet) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.pets, color: Colors.green),
            const SizedBox(width: 8),
            Text('Adopt ${pet.name}?'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You are about to adopt ${pet.name}.'),
            const SizedBox(height: 16),
            const Text(
              'Adoption Details:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 16),
                const SizedBox(width: 8),
                const Text('Health checkup included'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 16),
                const SizedBox(width: 8),
                const Text('Vaccination records provided'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 16),
                const SizedBox(width: 8),
                const Text('30-day support included'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _processAdoption(pet),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm Adoption'),
          ),
        ],
      ),
    );
  }

  Future<void> _processAdoption(Pet pet) async {
    Navigator.of(context).pop(); // Close dialog
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    try {
      // Create order for pet adoption
      final order = entities.Order(
        petId: pet.id,
        quantity: 1,
        shipDate: DateTime.now().add(const Duration(days: 3)), // 3 days for delivery
        status: entities.OrderStatus.pending,
        complete: false,
      );
      
      final placeOrder = getIt<PlaceOrder>();
      final result = await placeOrder(PlaceOrderParams(order: order));
      
      result.fold(
        (failure) {
          // Show error message
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Failed to place order. Please try again.',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
        (placedOrder) {
          // Show success message with order ID
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.celebration, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Order placed successfully! Order ID: ${placedOrder.id}\n${pet.name} will be delivered soon! 🎉',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(seconds: 6),
            ),
          );
          
          // Navigate back to pet list after a short delay
          final navigator = Navigator.of(context);
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              navigator.pop();
            }
          });
        },
      );
    } catch (e) {
      // Show generic error message
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'An error occurred. Please try again.',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }
}