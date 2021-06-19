import '../data/model/logIn.dart';
import '../data/model/user.dart';
import '../data/user_repository.dart';
import 'package:mobx/mobx.dart';

part 'user_store.g.dart';

class UserStore extends _UserStore with _$UserStore {
  UserStore(UserRepository userRepository) : super(userRepository);
}

enum StoreState { initial, loading, loaded }

abstract class _UserStore with Store {
  late UserRepository _userRepository;

  _UserStore(this._userRepository);

  @observable
  ObservableFuture<User>? _userFuture;
  @observable
  User? user;

  @observable
  String? errorMessage;

  @computed
  StoreState get state {
    if (_userFuture == null || _userFuture!.status == FutureStatus.rejected) {
      return StoreState.initial;
    }
    return _userFuture!.status == FutureStatus.pending
        ? StoreState.loading
        : StoreState.loaded;
  }

  @action
  Future login(Login credentials) async {
    try {
      errorMessage = null;
      _userFuture = ObservableFuture(_userRepository.login(credentials));
      user = await _userFuture!;
    } on NetworkError {
      print('NetworkError');
      errorMessage = "Couldn't login. Is the device online?";
    } on CredentialError {
      print('CredentialError');
      errorMessage = "Couldn't login. make sure the your data is correct";
    }
  }
}
