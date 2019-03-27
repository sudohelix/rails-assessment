import a from "axios"

const BASE_URL = "/data_encrypting_keys";

export function rotateEncryptionKeys() {
  return a.post(`${BASE_URL}/rotate`);
}

export function rotationStatus(options = {}) {
  return a.get(`${BASE_URL}/rotate/status`, options);
}
