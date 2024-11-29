import 'package:get_it/get_it.dart';
import 'package:salla/shared/network/remote/dio_helper.dart';

final getIt = GetIt.instance;

Future<void> setup()async {
  getIt.registerLazySingleton<DioHelper>(() => DioHelper());
}