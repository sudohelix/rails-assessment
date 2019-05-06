export default function StorageService(backend = window.localStorage) {
  const _backend = backend;

  return {
    get(key) {
      return _backend.getItem(key)
    },
    set(key, value) {
      _backend.setItem(key, value);
    },
    remove(key) {
      _backend.removeItem(key);
    }
  };
}
