import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../bloc/pet_bloc.dart';
import '../bloc/pet_event.dart';
import '../bloc/pet_state.dart';
import '../widgets/pet_card.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/pet.dart';

class PetListScreen extends StatefulWidget {
  const PetListScreen({super.key});

  @override
  State<PetListScreen> createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  String selectedStatus = 'available';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PetBloc>().add(LoadPets(status: [selectedStatus]));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Store'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () {
              getIt<AuthBloc>().add(LogoutRequested());
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildStatusFilter(),
          Expanded(
            child: BlocBuilder<PetBloc, PetState>(
              builder: (context, state) {
                if (state is PetLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PetLoaded) {
                  // Filter pets by selected status when showing tag search results
                  final filteredPets = _filterPetsByStatus(state.pets);
                  
                  if (filteredPets.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            searchQuery.isNotEmpty 
                                ? 'No pets found with tags "$searchQuery" and status "$selectedStatus"'
                                : 'No $selectedStatus pets found',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredPets.length,
                    itemBuilder: (context, index) {
                      final pet = filteredPets[index];
                      return PetCard(
                        pet: pet,
                        onTap: () {
                          context.push('/pet/${pet.id}');
                        },
                      );
                    },
                  );
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
                              LoadPets(status: [selectedStatus]),
                            );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(child: Text('Welcome to Pet Store'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by tags (e.g., friendly, cute, small)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            searchQuery = '';
                          });
                          _performSearch();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
                // Debounce search
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (searchQuery == value) {
                    _performSearch();
                  }
                });
              },
            ),
          ),
          if (searchQuery.isNotEmpty) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  searchQuery = '';
                });
                context.read<PetBloc>().add(LoadPets(status: [selectedStatus]));
              },
              child: const Text('Clear'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text('Filter by status: '),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButton<String>(
              value: selectedStatus,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'available', child: Text('Available')),
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                DropdownMenuItem(value: 'sold', child: Text('Sold')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedStatus = value;
                  });
                  _performSearch();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _performSearch() {
    if (searchQuery.isNotEmpty) {
      // Always search by tags when there's a search query
      final tags = searchQuery.split(',').map((tag) => tag.trim()).where((tag) => tag.isNotEmpty).toList();
      if (tags.isNotEmpty) {
        context.read<PetBloc>().add(LoadPetsByTags(tags: tags));
      }
    } else {
      // Default status-based search when no search query
      context.read<PetBloc>().add(LoadPets(status: [selectedStatus]));
    }
  }

  List<Pet> _filterPetsByStatus(List<Pet> pets) {
    // When searching by tags, we still want to filter by the selected status
    if (searchQuery.isNotEmpty) {
      return pets.where((pet) {
        switch (selectedStatus) {
          case 'available':
            return pet.status == PetStatus.available;
          case 'pending':
            return pet.status == PetStatus.pending;
          case 'sold':
            return pet.status == PetStatus.sold;
          default:
            return true;
        }
      }).toList();
    }
    // When not searching, return all pets (they're already filtered by status from the API)
    return pets;
  }
}