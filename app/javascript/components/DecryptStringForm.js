import React from "react";
import _bindAll from "lodash.bindall";
import PropTypes from "prop-types";

import { decryptToken, destroyEncryptedString } from "../services/http/encrypted_strings";

export default class DecryptStringForm extends React.Component {
  constructor(props) {
    super(props);
    _bindAll(this, ["handleDecrypt"]);
  }

  render() {
    const { selectedToken } = this.props;
    const tokenIsSelected = selectedToken.length > 0;

    return (
      <form >
        <p>Selected Token: { tokenIsSelected ? selectedToken : "None"}</p>
        <button onClick={this.handleDecrypt} disabled={!tokenIsSelected}>Decrypt</button>
      </form>
    );
  }

  handleDecrypt = async (evt) => {
    evt.preventDefault();

    const { selectedToken } = this.props;

    try {
      const { data: { value } } = await decryptToken(selectedToken);
      alert(`Token decrypts to: ${value}`);
    } catch (error) {
      alert(error);
    }
  };
}

DecryptStringForm.propTypes = {
  selectedToken: PropTypes.string
};

DecryptStringForm.defaultProps = {
  selectedToken: ""
};