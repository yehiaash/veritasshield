import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/vault/data/repositories/vault_repository.dart';
import '../../features/vault/presentation/cubit/vault_cubit.dart';
import '../../features/analysis/data/repositories/analysis_repository.dart';
import '../../features/analysis/presentation/cubit/analysis_cubit.dart';
import '../../features/profile/data/repositories/profile_repository.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(sl()));
  sl.registerLazySingleton<VaultRepository>(() => VaultRepository(sl()));
  sl.registerLazySingleton<AnalysisRepository>(() => AnalysisRepository(sl()));
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepository(sl()));

  // Cubits
  sl.registerFactory(() => AuthCubit(sl()));
  sl.registerFactory(() => VaultCubit(sl()));
  sl.registerFactory(() => AnalysisCubit(sl()));
  sl.registerFactory(() => ProfileCubit(sl()));
}
