import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<AppUser> signUp({
    required String email,
    required String password,
  }) async {
    final credential = await dataSource.signUp(
      email: email,
      password: password,
    );

    return AppUser(
      id: credential.user!.uid,
      email: credential.user!.email!,
    );
  }

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await dataSource.signIn(
      email: email,
      password: password,
    );

    return AppUser(
      id: credential.user!.uid,
      email: credential.user!.email!,
    );
  }

  @override
  Future<void> signOut() {
    return dataSource.signOut();
  }

  @override
  Stream<AppUser?> authStateChanges() {
    return dataSource.authStateChanges().map(
      (user) {
        if (user == null) return null;

        return AppUser(
          id: user.uid,
          email: user.email ?? '',
        );
      },
    );
  }
}