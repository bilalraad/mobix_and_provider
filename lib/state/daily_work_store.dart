import '../data/daily_work_repository.dart';
import '../data/model/daily_work.dart';
import '../shared/store_state.dart';
import '../data/user_repository.dart';
import 'package:mobx/mobx.dart';

part 'daily_work_store.g.dart';

class DailyWorkStore extends _DailyWorkStore with _$DailyWorkStore {
  DailyWorkStore(DailyWorkRepository dailyWorkRepository)
      : super(dailyWorkRepository);
}

abstract class _DailyWorkStore with Store {
  late DailyWorkRepository _dailyWorkRepository;

  _DailyWorkStore(this._dailyWorkRepository);

  @observable
  ObservableFuture<List<DailyWork>>? _dataFuture;

  @observable
  List<DailyWork>? dailywork;

  @computed
  StoreState get state {
    if (_dataFuture == null) {
      return StoreState.initial;
    }
    if (_dataFuture!.status == FutureStatus.rejected) {
      return StoreState.error;
    }
    return _dataFuture!.status == FutureStatus.pending
        ? StoreState.loading
        : StoreState.loaded;
  }

  @action
  Future<void> getData([int page = 1]) async {
    try {
      //ideally this will return different items for each new page
      _dataFuture = ObservableFuture(_dailyWorkRepository.getData(page));
      dailywork = await _dataFuture!;
    } on NetworkError {
      throw "Couldn't load the data. Is the device online?";
    } catch (e) {
      throw "Unknown error happend please try agan later";
    }
  }
}
