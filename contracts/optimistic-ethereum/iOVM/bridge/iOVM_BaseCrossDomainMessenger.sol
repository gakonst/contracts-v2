// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

/**
 * @title iOVM_BaseCrossDomainMessenger
 */
interface iOVM_BaseCrossDomainMessenger {

    /********************
     * Public Functions *
     ********************/

    /**
     * Sets the target messenger address.
     * @param _targetMessengerAddress New messenger address.
     */
    function setTargetMessengerAddress(
        address _targetMessengerAddress
    ) external;

    /**
     * Sends a cross domain message to the target messenger.
     * @param _target Target contract address.
     * @param _message Message to send to the target.
     * @param _gasLimit Gas limit for the provided message.
     */
    function sendMessage(
        address _target,
        bytes memory _message,
        uint256 _gasLimit
    ) external;
}
