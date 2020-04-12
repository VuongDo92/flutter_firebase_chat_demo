// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$EntityStore<T, K> on _EntityStore<T, K>, Store {
  final _$entityAtom = Atom(name: '_EntityStore.entity');

  @override
  T get entity {
    _$entityAtom.context.enforceReadPolicy(_$entityAtom);
    _$entityAtom.reportObserved();
    return super.entity;
  }

  @override
  set entity(T value) {
    _$entityAtom.context.conditionallyRunInAction(() {
      super.entity = value;
      _$entityAtom.reportChanged();
    }, _$entityAtom, name: '${_$entityAtom.name}_set');
  }

  final _$fetchErrorAtom = Atom(name: '_EntityStore.fetchError');

  @override
  Error get fetchError {
    _$fetchErrorAtom.context.enforceReadPolicy(_$fetchErrorAtom);
    _$fetchErrorAtom.reportObserved();
    return super.fetchError;
  }

  @override
  set fetchError(Error value) {
    _$fetchErrorAtom.context.conditionallyRunInAction(() {
      super.fetchError = value;
      _$fetchErrorAtom.reportChanged();
    }, _$fetchErrorAtom, name: '${_$fetchErrorAtom.name}_set');
  }

  final _$refreshedAtAtom = Atom(name: '_EntityStore.refreshedAt');

  @override
  DateTime get refreshedAt {
    _$refreshedAtAtom.context.enforceReadPolicy(_$refreshedAtAtom);
    _$refreshedAtAtom.reportObserved();
    return super.refreshedAt;
  }

  @override
  set refreshedAt(DateTime value) {
    _$refreshedAtAtom.context.conditionallyRunInAction(() {
      super.refreshedAt = value;
      _$refreshedAtAtom.reportChanged();
    }, _$refreshedAtAtom, name: '${_$refreshedAtAtom.name}_set');
  }

  final _$isFetchingDataAtom = Atom(name: '_EntityStore.isFetchingData');

  @override
  bool get isFetchingData {
    _$isFetchingDataAtom.context.enforceReadPolicy(_$isFetchingDataAtom);
    _$isFetchingDataAtom.reportObserved();
    return super.isFetchingData;
  }

  @override
  set isFetchingData(bool value) {
    _$isFetchingDataAtom.context.conditionallyRunInAction(() {
      super.isFetchingData = value;
      _$isFetchingDataAtom.reportChanged();
    }, _$isFetchingDataAtom, name: '${_$isFetchingDataAtom.name}_set');
  }

  final _$refreshAsyncAction = AsyncAction('refresh');

  @override
  Future<dynamic> refresh({Duration refreshedAtBefore = null}) {
    return _$refreshAsyncAction
        .run(() => super.refresh(refreshedAtBefore: refreshedAtBefore));
  }

  final _$_EntityStoreActionController = ActionController(name: '_EntityStore');

  @override
  void _startFetching() {
    final _$actionInfo = _$_EntityStoreActionController.startAction();
    try {
      return super._startFetching();
    } finally {
      _$_EntityStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo = _$_EntityStoreActionController.startAction();
    try {
      return super.clear();
    } finally {
      _$_EntityStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'entity: ${entity.toString()},fetchError: ${fetchError.toString()},refreshedAt: ${refreshedAt.toString()},isFetchingData: ${isFetchingData.toString()}';
    return '{$string}';
  }
}
