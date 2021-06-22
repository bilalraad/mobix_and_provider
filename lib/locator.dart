import 'package:get_it/get_it.dart';

import './data/user_repository.dart';
import './data/daily_work_repository.dart';
import 'state/daily_work_store.dart';
import 'state/user_store.dart';

GetIt getIt = GetIt.instance;

///A set of singletos for all the app controllers
void setupLocator() {
  getIt.registerSingleton<DailyWorkStore>(
      DailyWorkStore(FakeDailyWorkRepository()));
  getIt.registerSingleton<UserStore>(UserStore(FakeUserRepository()));
}
