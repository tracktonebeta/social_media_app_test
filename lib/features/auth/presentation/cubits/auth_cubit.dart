import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_test/features/auth/presentation/cubits/auth_states.dart';
import 'package:social_media_app_test/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app_test/features/auth/domain/repos/auth_repo.dart';

class AuthCubit extends Cubit<AuthStates> {
  final AuthRepo authRepo;
  AppUser? _currentUser;

  AuthCubit({required this.authRepo}) : super(AuthInitial());

  // check if user is authenticated
  void checkAuth() async {
    final AppUser? user = await authRepo.getCurrentUser();

    if (user != null) {
      _currentUser = user;
      emit(AuthAuthenticated(user: user));
    } else {
      emit(Unauthenticated());
    }
  }

  // get current user
  AppUser? get currentUser => _currentUser;

  // login with email and password
  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.loginWithEmailAndPassword(email, password);

      if (user != null) {
        _currentUser = user;
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthError(error: 'Failed to login'));
      }

    } catch (e) {
      emit(AuthError(error: e.toString()));
    }
  }


  // register with email and password
  Future<void> register(String name, String email, String password) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.registerWithEmailAndPassword(name, email, password);

      if (user != null) {
        _currentUser = user;
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthError(error: 'Failed to register'));
      }

    } catch (e) {
      emit(AuthError(error: e.toString()));
    }
  }


  // logout
  Future<void> logout() async {
    try {
      emit(AuthLoading());
      await authRepo.logout();
      _currentUser = null;
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(error: e.toString()));
    }
  }

}