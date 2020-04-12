// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PaginationStore<T> on _PaginationStore<T>, Store {
  Computed<bool> _$isFetchingDataComputed;

  @override
  bool get isFetchingData =>
      (_$isFetchingDataComputed ??= Computed<bool>(() => super.isFetchingData))
          .value;
  Computed<bool> _$hasNoDataComputed;

  @override
  bool get hasNoData =>
      (_$hasNoDataComputed ??= Computed<bool>(() => super.hasNoData)).value;

  final _$itemsAtom = Atom(name: '_PaginationStore.items');

  @override
  ObservableList<T> get items {
    _$itemsAtom.context.enforceReadPolicy(_$itemsAtom);
    _$itemsAtom.reportObserved();
    return super.items;
  }

  @override
  set items(ObservableList<T> value) {
    _$itemsAtom.context.conditionallyRunInAction(() {
      super.items = value;
      _$itemsAtom.reportChanged();
    }, _$itemsAtom, name: '${_$itemsAtom.name}_set');
  }

  final _$canLoadMoreAtom = Atom(name: '_PaginationStore.canLoadMore');

  @override
  bool get canLoadMore {
    _$canLoadMoreAtom.context.enforceReadPolicy(_$canLoadMoreAtom);
    _$canLoadMoreAtom.reportObserved();
    return super.canLoadMore;
  }

  @override
  set canLoadMore(bool value) {
    _$canLoadMoreAtom.context.conditionallyRunInAction(() {
      super.canLoadMore = value;
      _$canLoadMoreAtom.reportChanged();
    }, _$canLoadMoreAtom, name: '${_$canLoadMoreAtom.name}_set');
  }

  final _$isRefreshingAtom = Atom(name: '_PaginationStore.isRefreshing');

  @override
  bool get isRefreshing {
    _$isRefreshingAtom.context.enforceReadPolicy(_$isRefreshingAtom);
    _$isRefreshingAtom.reportObserved();
    return super.isRefreshing;
  }

  @override
  set isRefreshing(bool value) {
    _$isRefreshingAtom.context.conditionallyRunInAction(() {
      super.isRefreshing = value;
      _$isRefreshingAtom.reportChanged();
    }, _$isRefreshingAtom, name: '${_$isRefreshingAtom.name}_set');
  }

  final _$isLoadingMoreAtom = Atom(name: '_PaginationStore.isLoadingMore');

  @override
  bool get isLoadingMore {
    _$isLoadingMoreAtom.context.enforceReadPolicy(_$isLoadingMoreAtom);
    _$isLoadingMoreAtom.reportObserved();
    return super.isLoadingMore;
  }

  @override
  set isLoadingMore(bool value) {
    _$isLoadingMoreAtom.context.conditionallyRunInAction(() {
      super.isLoadingMore = value;
      _$isLoadingMoreAtom.reportChanged();
    }, _$isLoadingMoreAtom, name: '${_$isLoadingMoreAtom.name}_set');
  }

  final _$paginationErrorAtom = Atom(name: '_PaginationStore.paginationError');

  @override
  Error get paginationError {
    _$paginationErrorAtom.context.enforceReadPolicy(_$paginationErrorAtom);
    _$paginationErrorAtom.reportObserved();
    return super.paginationError;
  }

  @override
  set paginationError(Error value) {
    _$paginationErrorAtom.context.conditionallyRunInAction(() {
      super.paginationError = value;
      _$paginationErrorAtom.reportChanged();
    }, _$paginationErrorAtom, name: '${_$paginationErrorAtom.name}_set');
  }

  final _$refreshedAtAtom = Atom(name: '_PaginationStore.refreshedAt');

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

  final _$refreshAsyncAction = AsyncAction('refresh');

  @override
  Future<dynamic> refresh(
      {Duration refreshedAtBefore = null, bool forced = false}) {
    return _$refreshAsyncAction.run(() =>
        super.refresh(refreshedAtBefore: refreshedAtBefore, forced: forced));
  }

  final _$loadMoreAsyncAction = AsyncAction('loadMore');

  @override
  Future<dynamic> loadMore() {
    return _$loadMoreAsyncAction.run(() => super.loadMore());
  }

  final _$_PaginationStoreActionController =
      ActionController(name: '_PaginationStore');

  @override
  void clear() {
    final _$actionInfo = _$_PaginationStoreActionController.startAction();
    try {
      return super.clear();
    } finally {
      _$_PaginationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setStartRefreshing() {
    final _$actionInfo = _$_PaginationStoreActionController.startAction();
    try {
      return super.setStartRefreshing();
    } finally {
      _$_PaginationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setStartLoadingMore() {
    final _$actionInfo = _$_PaginationStoreActionController.startAction();
    try {
      return super.setStartLoadingMore();
    } finally {
      _$_PaginationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'items: ${items.toString()},canLoadMore: ${canLoadMore.toString()},isRefreshing: ${isRefreshing.toString()},isLoadingMore: ${isLoadingMore.toString()},paginationError: ${paginationError.toString()},refreshedAt: ${refreshedAt.toString()},isFetchingData: ${isFetchingData.toString()},hasNoData: ${hasNoData.toString()}';
    return '{$string}';
  }
}
