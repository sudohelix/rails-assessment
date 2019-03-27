import React from "react";
import _bindAll from "lodash.bindall";

import {
  rotateEncryptionKeys,
  rotationStatus
} from "../services/http/rotations";

const BASE_TIMEOUT = 2000;

export default class KeyRotationForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      rotationInProgress: false,
      statusText: ""
    };

    _bindAll(this, ["reEncryptStrings", "pollForStatus"]);
  }

  render() {
    const { rotationInProgress, statusText } = this.state;
    return (
      <span>
        <button onClick={this.reEncryptStrings} disabled={rotationInProgress}>
          Re-encrypt Strings
        </button>
        <RotationStatus
          inProgress={rotationInProgress}
          statusText={statusText}
        />
      </span>
    );
  }

  reEncryptStrings = async evt => {
    evt.preventDefault();
    try {
      const response = await rotateEncryptionKeys();
      this.setState(
        {
          rotationInProgress: true,
          statusText: response.data.message
        },
        () => void setTimeout(this.pollForStatus, BASE_TIMEOUT)
      );
    } catch (error) {
      console.log(error);
    }
  };

  pollForStatus = async evt => {
    try {
      const response = await rotationStatus();
      this.setState({
        rotationInProgress: false,
        statusText: response.data.message
      });
    } catch (error) {
      const { response } = error;

      this.setState({
        rotationInProgress: true,
        statusText: response.data.message
      }, () => void setTimeout(this.pollForStatus, BASE_TIMEOUT));
    }
  };
}

const RotationStatus = React.memo(({ inProgress, statusText }) => {
  if (!inProgress && statusText.length === 0) return null;
  return `Status: ${statusText}`;
});
