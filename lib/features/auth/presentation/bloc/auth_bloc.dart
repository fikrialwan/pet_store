import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/logout_user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final LogoutUser logoutUser;
  final GetCurrentUser getCurrentUser;

  AuthBloc({
    required this.loginUser,
    required this.logoutUser,
    required this.getCurrentUser,
  }) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthStatusRequested>(_onAuthStatusRequested);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    final result = await getCurrentUser(const NoParams());
    
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (user) {
        if (user != null && !user.isExpired) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      // Proceed directly with login
      final loginResult = await loginUser(event.credentials);
      
      loginResult.fold(
        (failure) {
          emit(AuthError(message: _getErrorMessage(failure)));
        },
        (user) {
          emit(AuthAuthenticated(user: user));
        },
      );
    } catch (e) {
      // Handle any unexpected errors
      emit(AuthError(message: '⚠️ Login failed!\nAn unexpected error occurred. Please try again.'));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await logoutUser(const NoParams());
    
    result.fold(
      (failure) => emit(AuthError(message: _getErrorMessage(failure))),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onAuthStatusRequested(
    AuthStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await getCurrentUser(const NoParams());
    
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (user) {
        if (user != null && !user.isExpired) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  String _getErrorMessage(failure) {
    final message = failure.toString();
    
    // Check for user not found errors (from validation step)
    if (message.contains('does not exist') || 
        message.contains('not found') ||
        message.contains('User "') && message.contains('" not found')) {
      return '❌ User not found!\nPlease check your username and try again.';
    } 
    // Check for authentication errors (wrong password)
    else if (message.contains('Invalid username or password') ||
             message.contains('401') ||
             message.contains('Unauthorized')) {
      return '🔒 Invalid credentials!\nPlease check your username and password.';
    }
    // Check for validation errors (network issues during user check)
    else if (message.contains('Failed to validate user') ||
             message.contains('Unable to connect') ||
             message.contains('Connection timeout')) {
      return '🌐 Connection error!\nUnable to verify user. Please check your internet connection.';
    }
    // Check for general network errors
    else if (message.contains('Network') || 
             message.contains('connection') ||
             message.contains('timeout')) {
      return '📡 Network error!\nPlease check your internet connection and try again.';
    }
    // Check for server errors
    else if (message.contains('500') || message.contains('Server error')) {
      return '🔧 Server error!\nThe server is currently unavailable. Please try again later.';
    }
    // Default error message
    else {
      return '⚠️ Login failed!\nSomething went wrong. Please try again.';
    }
  }
}