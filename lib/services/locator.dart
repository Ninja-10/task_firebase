import 'package:get_it/get_it.dart';
import 'package:task_offline/repositories/form_repository.dart';
import 'package:task_offline/services/connectivity_services.dart';
import 'package:task_offline/services/firebase_auth_services.dart';
import 'package:task_offline/services/navigation_services.dart';
import 'package:task_offline/utils/appform_validation.dart';
import 'package:task_offline/services/preference_manager.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AppFormValidator());
  locator.registerLazySingleton(() => ConnectivityService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerFactory(() => FirebaseFormDataRepository());
  locator.registerFactory(() => PreferenceManager());
}
