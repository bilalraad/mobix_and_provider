import '../data/daily_work_repository.dart';
import '../data/model/daily_work.dart';
import '../data/user_repository.dart';
import '../state/user_store.dart';
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

  @observable
  String? errorMessage;

  @computed
  StoreState get state {
    if (_dataFuture == null || _dataFuture!.status == FutureStatus.rejected) {
      return StoreState.initial;
    }
    return _dataFuture!.status == FutureStatus.pending
        ? StoreState.loading
        : StoreState.loaded;
  }

  @action
  Future<void> getData(int take) async {
    try {
      errorMessage = null;
      _dataFuture = ObservableFuture(_dailyWorkRepository.getData(take));
      dailywork = await _dataFuture!;
    } on NetworkError {
      print('NetworkError');
      errorMessage = "Couldn't login. Is the device online?";
    } on CredentialError {
      print('CredentialError');
      errorMessage = "Couldn't login. make sure the your data is correct";
    }
  }
}
