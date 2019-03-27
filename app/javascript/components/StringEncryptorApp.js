import React from "react";
import PropTypes from "prop-types";
import _bindAll from "lodash.bindall";

import DecryptStringForm from "./DecryptStringForm";
import EncryptStringForm from "./EncryptStringForm";
import KeyRotationForm from "./KeyRotationForm";
import SimpleList from "./SimpleList";
import StorageService from "../services/storage_service";
import { ShowIf } from "../helpers/component_helpers";
import { destroyEncryptedString } from "../services/http/encrypted_strings";

export default class StringEncryptorApp extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      selectedToken: "",
      tokens: this.storedTokens
    };
    _bindAll(this, [
      "storeToken",
      "selectToken",
      "deleteEncryptedString"
    ]);
  }

  render() {
    const {
      selectedToken,
      tokens,
      tokens: { length: haveTokens }
    } = this.state;

    return (
      <div id="app">
        <EncryptStringForm afterSubmit={this.storeToken} />
        <SimpleList
          title="My Tokens"
          tokens={tokens}
          action={this.listAction()}
        />
        <ShowIf condition={haveTokens}>
          <KeyRotationForm />
          <DecryptStringForm selectedToken={selectedToken} />
          <button
            onClick={this.deleteEncryptedString}
            disabled={selectedToken.length === 0}
          >
            Delete Selected Token
          </button>
        </ShowIf>
      </div>
    );
  }

  get storageService() {
    return this.props.storageService;
  }

  get storedTokens() {
    const storedTokens = this.storageService.get("tokens");
    return !!storedTokens ? storedTokens.split(",") : [];
  }

  listAction() {
    return {
      name: "select",
      func: this.selectToken
    };
  }

  selectToken = token => {
    return evt => {
      evt.preventDefault();
      this.setState({
        selectedToken: token
      });
    };
  };

  storeToken = token => {
    const newTokens = this.state.tokens.concat(token);

    this.setState(
      {
        tokens: newTokens
      },
      () => {
        this.storageService.set("tokens", newTokens);
      }
    );
  };

  deleteEncryptedString = async evt => {
    evt.preventDefault();
    const { selectedToken } = this.state;

    try {
      const response = await destroyEncryptedString(selectedToken);
    } catch (error) {
      alert(error);
    } finally {
      const remainingTokens = [...this.state.tokens];
      remainingTokens.splice(
        this.state.tokens.findIndex(i => i === selectedToken),
        1
      );

      this.setState({ selectedToken: "", tokens: remainingTokens }, () => {
        this.storageService.set("tokens", remainingTokens);
      });
    }
  };
}

StringEncryptorApp.propTypes = {
  storageService: PropTypes.object
};

StringEncryptorApp.defaultProps = {
  storageService: new StorageService()
};
