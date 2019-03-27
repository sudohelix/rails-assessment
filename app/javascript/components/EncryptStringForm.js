import React from "react";
import PropTypes from "prop-types";
import _bindAll from "lodash.bindall";
import { createEncryptedString } from "../services/http/encrypted_strings";


export default class EncryptStringForm extends React.Component {
  state = {
    submitting: false,
    stringToEncrypt: ""
  };

  constructor(props) {
    super(props);

    _bindAll(this, ["handleInput", "handleSubmit"]);
  }

  render() {
    const { submitting, stringToEncrypt } = this.state;

    return (
      <form onSubmit={this.handleSubmit}>
        <input type="text" value={stringToEncrypt} onChange={this.handleInput}
               placeholder="Type String to Encrypt Here..."/>
        <input type="submit" value="Encrypt" disabled={stringToEncrypt.length === 0 || submitting}/>
      </form>
    );
  }

  handleInput = (event) => {
    this.setState({
      stringToEncrypt: event.target.value
    });
  };

  handleSubmit = async (evt) => {
    evt.preventDefault();

    const { stringToEncrypt } = this.state;

    this.setState({ submitting: true });
    try {
      const response = await createEncryptedString(stringToEncrypt);
      this.props.afterSubmit(response.data.token);
    } catch (error) {
      alert(error); // TODO: turn into some kind of banner or something
    } finally {
      this.setState({ submitting: false });
    }
  };
}

EncryptStringForm.propTypes = {
  afterSubmit: PropTypes.func.isRequired
};
