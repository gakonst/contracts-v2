// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

/* Library Imports */
import { Lib_AddressResolver } from "../../libraries/resolver/Lib_AddressResolver.sol";

/* Interface Imports */
import { iOVM_L2CrossDomainMessenger } from "../../iOVM/bridge/iOVM_L2CrossDomainMessenger.sol";
import { iOVM_L1MessageSender } from "../../iOVM/precompiles/iOVM_L1MessageSender.sol";
import { iOVM_L2ToL1MessagePasser } from "../../iOVM/precompiles/iOVM_L2ToL1MessagePasser.sol";

/* Contract Imports */
import { OVM_BaseCrossDomainMessenger } from "./OVM_BaseCrossDomainMessenger.sol";

/**
 * @title OVM_L2CrossDomainMessenger
 */
contract OVM_L2CrossDomainMessenger is iOVM_L2CrossDomainMessenger, OVM_BaseCrossDomainMessenger, Lib_AddressResolver {

    /*******************************************
     * Contract Variables: Contract References *
     *******************************************/

    iOVM_L1MessageSender internal ovmL1MessageSender;
    iOVM_L2ToL1MessagePasser internal ovmL2ToL1MessagePasser;


    /***************
     * Constructor *
     ***************/
    
    /**
     * @param _libAddressManager Address of the Address Manager.
     */
    constructor(
        address _libAddressManager
    )
        Lib_AddressResolver(_libAddressManager)
    {
        ovmL1MessageSender = iOVM_L1MessageSender(resolve("OVM_L1MessageSender"));
        ovmL2ToL1MessagePasser = iOVM_L2ToL1MessagePasser(resolve("OVM_L2ToL1MessagePasser"));
    }


    /********************
     * Public Functions *
     ********************/

    /**
     * Relays a cross domain message to a contract.
     * @inheritdoc iOVM_L2CrossDomainMessenger
     */
    function relayMessage(
        address _target,
        address _sender,
        bytes memory _message,
        uint256 _messageNonce
    )
        override
        public
    {
        require(
            _verifyXDomainMessage() == true,
            "Provided message could not be verified."
        );

        bytes memory xDomainCalldata = _getXDomainCalldata(
            _target,
            _sender,
            _message,
            _messageNonce
        );

        require(
            receivedMessages[keccak256(xDomainCalldata)] == false,
            "Provided message has already been received."
        );

        xDomainMessageSender = _sender;
        _target.call(_message);

        // Messages are considered successfully executed if they complete
        // without running out of gas (revert or not). As a result, we can
        // ignore the result of the call and always mark the message as
        // successfully executed because we won't get here unless we have
        // enough gas left over.
        receivedMessages[keccak256(xDomainCalldata)] = true;
    }


    /**********************
     * Internal Functions *
     **********************/

    /**
     * Verifies that a received cross domain message is valid.
     * @return _valid Whether or not the message is valid.
     */
    function _verifyXDomainMessage()
        internal
        returns (
            bool _valid
        )
    {
        return (
            ovmL1MessageSender.getL1MessageSender() == targetMessengerAddress
        );
    }

    /**
     * Sends a cross domain message.
     * @param _message Message to send.
     * @param _gasLimit Gas limit for the provided message.
     */
    function _sendXDomainMessage(
        bytes memory _message,
        uint256 _gasLimit
    )
        override
        internal
    {
        ovmL2ToL1MessagePasser.passMessageToL1(_message);
    }
}
