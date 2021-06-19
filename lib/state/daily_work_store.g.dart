// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_work_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DailyWorkStore on _DailyWorkStore, Store {
  Computed<StoreState>? _$stateComputed;

  @override
  StoreState get state =>
      (_$stateComputed ??= Computed<StoreState>(() => super.state,
              name: '_DailyWorkStore.state'))
          .value;

  final _$_dataFutureAtom = Atom(name: '_DailyWorkStore._dataFuture');

  @override
  ObservableFuture<List<DailyWork>>? get _dataFuture {
    _$_dataFutureAtom.reportRead();
    return super._dataFuture;
  }

  @override
  set _dataFuture(ObservableFuture<List<DailyWork>>? value) {
    _$_dataFutureAtom.reportWrite(value, super._dataFuture, () {
      super._dataFuture = value;
    });
  }

  final _$dailyworkAtom = Atom(name: '_DailyWorkStore.dailywork');

  @override
  List<DailyWork>? get dailywork {
    _$dailyworkAtom.reportRead();
    return super.dailywork;
  }

  @override
  set dailywork(List<DailyWork>? value) {
    _$dailyworkAtom.reportWrite(value, super.dailywork, () {
      super.dailywork = value;
    });
  }

  final _$errorMessageAtom = Atom(name: '_DailyWorkStore.errorMessage');

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  final _$getDataAsyncAction = AsyncAction('_DailyWorkStore.getData');

  @override
  Future<void> getData(int take) {
    return _$getDataAsyncAction.run(() => super.getData(take));
  }

  @override
  String toString() {
    return '''
dailywork: ${dailywork},
errorMessage: ${errorMessage},
state: ${state}
    ''';
  }
}
