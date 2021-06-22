import '../data/model/logIn.dart';
import '../shared/store_state.dart';
import '../data/model/user.dart';
import '../data/user_repository.dart';
import 'package:mobx/mobx.dart';

part 'user_store.g.dart';

class UserStore extends _UserStore with _$UserStore {
  UserStore(UserRepository userRepository) : super(userRepository);
}

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
    if (_userFuture == null) {
      return StoreState.initial;
    }
    if (_userFuture!.status == FutureStatus.rejected) {
      return StoreState.error;
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
      print(errorMessage);

      errorMessage = "Couldn't login. Is the device online?";
    } on CredentialError {
      print('CredentialError');
      print(errorMessage);
      errorMessage = "Couldn't login. make sure the your data is correct";
    } catch (e) {
      errorMessage = "Unknown error happend please try agan later";
    }
  }

  @action
  Future getCurrentUser() async {
    try {
      errorMessage = null;
      _userFuture = ObservableFuture(_userRepository.getCurrentUser());
      user = await _userFuture!;
    } on NetworkError {
      errorMessage = "Couldn't login. Is the device online?";
    } on CredentialError {
      errorMessage = "Couldn't login. make sure the your data is correct";
    } catch (e) {
      errorMessage = "Unkown error happend please try agan later";
    }
  }

  @action
  Future logout() async {
    _userRepository.logout();
    user = User.initial();
  }
}
