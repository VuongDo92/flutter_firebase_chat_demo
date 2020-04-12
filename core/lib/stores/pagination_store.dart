import 'package:core/repositories/providers/exception.dart';
import 'package:mobx/mobx.dart';

part 'pagination_store.g.dart';

/// Subclass and override [fetchData] function
class PaginationStore<T> = _PaginationStore<T> with _$PaginationStore<T>;

abstract class _PaginationStore<T> with Store {
  static const DEFAULT_PAGE_SIZE = 20;

  @observable
  ObservableList<T> items = ObservableList.of([]);

  @observable
  bool canLoadMore = true;

  @observable
  bool isRefreshing = false;

  @observable
  bool isLoadingMore = false;

  @observable
  Error paginationError = null;

  @observable
  DateTime refreshedAt = null;

  @computed
  bool get isFetchingData => isRefreshing || isLoadingMore;

  @computed
  bool get hasNoData => canLoadMore == false && items.isEmpty;

  int get pageSize => DEFAULT_PAGE_SIZE;

  Future<List<T>> fetchData({int offset = 0, limit}) {
    throw AssertionError('Need to override fetchData function');
  }

  @action
  Future refresh(
      {Duration refreshedAtBefore = null, bool forced = false}) async {
    if (isRefreshing && !forced) {
      return null;
    }
    if (forced == false && refreshedAtBefore != null && refreshedAt != null) {
      if (DateTime.now().subtract(refreshedAtBefore).isAfter(refreshedAt)) {
        return null;
      }
    }
    try {
      setStartRefreshing();
      List<T> items = await fetchData(limit: pageSize);
      updateWithItems(items, isRefresh: true);
      return items;
    } catch (e) {
      setPaginationError(e);
    }
  }

  @action
  Future loadMore() async {
    if (canLoadMore == false || isLoadingMore || isRefreshing) {
      return null;
    }

    try {
      setStartLoadingMore();
      List<T> newItems = await fetchData(offset: items.length, limit: pageSize);
      updateWithItems(newItems, isRefresh: false);
      return newItems;
    } catch (e) {
      setPaginationError(e);
    }
  }

  void updateWithItems(List<T> items, {bool isRefresh}) {
    canLoadMore = items.length == pageSize;
    if (isRefresh) {
      refreshedAt = DateTime.now();
      if (this.items.isNotEmpty) {
        this.items.clear();
      }
    }
    this.items.addAll(items);
    isRefreshing = false;
    isLoadingMore = false;
  }

  void setPaginationError(Error error) {
    if (error is CancelException) {
      paginationError = null;
    } else {
      isRefreshing = false;
      isLoadingMore = false;
      paginationError = error;
    }
  }

  @action
  void clear() {
    items.clear();
    canLoadMore = true;
    isRefreshing = false;
    isLoadingMore = false;
    paginationError = null;
    refreshedAt = null;
  }

  @action
  void setStartRefreshing() {
    isRefreshing = true;
    isLoadingMore = false;
    paginationError = null;
  }

  @action
  void setStartLoadingMore() {
    isRefreshing = false;
    isLoadingMore = true;
    paginationError = null;
  }

  void dispose() {}
}
