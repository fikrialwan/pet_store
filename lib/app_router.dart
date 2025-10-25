import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'features/pet/presentation/bloc/pet_bloc.dart';
import 'features/pet/presentation/screens/pet_list_screen.dart';
import 'features/pet/presentation/screens/pet_detail_screen.dart';
import 'injection_container.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<PetBloc>(),
        child: const PetListScreen(),
      ),
    ),
    GoRoute(
      path: '/pet/:petId',
      builder: (context, state) {
        final petId = state.pathParameters['petId']!;
        return BlocProvider(
          create: (context) => getIt<PetBloc>(),
          child: PetDetailScreen(petId: petId),
        );
      },
    ),

  ],
);