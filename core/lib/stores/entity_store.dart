import 'package:mobx/mobx.dart';

part 'entity_store.g.dart';

/// Subclass and override [fetchData] function
class EntityStore<T, K> = _EntityStore<T, K> with _$EntityStore<T, K>;

abstract class _EntityStore<T, K> with Store {
  K get entityId => null; // ID of the entity

  @observable
  T entity;

  @observable
  Error fetchError;

  @observable
  DateTime refreshedAt = null;

  @observable
  bool isFetchingData = false;

  @action
  Future refresh({Duration refreshedAtBefore = null}) async {
    if (isFetchingData) {
      return null;
    }
    if (refreshedAtBefore != null && refreshedAt != null) {
      if (DateTime.now().subtract(refreshedAtBefore).isAfter(refreshedAt)) {
        return null;
      }
    }
    _startFetching();
    try {
      entity = await fetchData();
      return entity;
    } catch (e) {
      fetchError = e;
      return null;
    } finally {
      isFetchingData = false;
    }
  }

  @action
  void _startFetching() {
    isFetchingData = true;
    fetchError = null;
  }

  // Override this
  Future<T> fetchData() {
    throw AssertionError('Need to override fetchData function');
  }

  @action
  void clear() {
    entity = null;
    refreshedAt = null;
    isFetchingData = false;
  }

  void dispose() {}

  @override
  bool operator ==(Object other) {
    if (other is _EntityStore<T, K>) {
      return other.entityId == entityId && entity == other.entity;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => entity?.hashCode ?? runtimeType.hashCode;
}
