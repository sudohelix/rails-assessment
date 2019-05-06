import a from "axios";

const BASE_URL = "/encrypted_strings";

export function createEncryptedString(stringToEncrypt, options = {}) {
  return a.post(`${BASE_URL}`, {
    encrypted_string: {
      value: stringToEncrypt
    }
  }, options);
}

export function decryptToken(token, options = {}) {
  return a.get(`${BASE_URL}/${token}`, options);
}

export function destroyEncryptedString(token, options = {}) {
  return a.delete(`${BASE_URL}/${token}`, options)
}
