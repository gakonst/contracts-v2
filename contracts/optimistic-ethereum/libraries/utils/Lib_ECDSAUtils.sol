// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

/**
 * @title Lib_ECDSAUtils
 */
library Lib_ECDSAUtils {

    /**************************************
     * Internal Functions: ECDSA Recovery *
     **************************************/

    /**
     * Recovers a signed address given a message and signature.
     * @param _message Message that was originally signed.
     * @param _isEthSignedMessage Whether or not the user used the `Ethereum Signed Message` prefix.
     * @param _v Signature `v` parameter.
     * @param _r Signature `r` parameter.
     * @param _s Signature `s` parameter.
     * @param _chainId Chain ID parameter.
     * @return _sender Signer address.
     */
    function recover(
        bytes memory _message,
        bool _isEthSignedMessage,
        uint8 _v,
        bytes32 _r,
        bytes32 _s,
        uint256 _chainId
    )
        internal
        pure
        returns (
            address _sender
        )
    {
        bytes32 messageHash;
        uint8 v;
        if (_isEthSignedMessage) {
            messageHash = getEthSignedMessageHash(_message);
            v = _v;
        } else {
            messageHash = getNativeMessageHash(_message);
            v = (_v - uint8(_chainId) * 2) - 8;
        }

        return ecrecover(
            messageHash,
            v,
            _r,
            _s
        );
    }


    /*************************************
     * Private Functions: ECDSA Recovery *
     *************************************/

    /**
     * Gets the native message hash (simple keccak256) for a message.
     * @param _message Message to hash.
     * @return _messageHash Native message hash.
     */
    function getNativeMessageHash(
        bytes memory _message
    )
        private
        pure
        returns (
            bytes32 _messageHash
        )
    {
        return keccak256(_message);
    }

    /**
     * Gets the hash of a message with the `Ethereum Signed Message` prefix.
     * @param _message Message to hash.
     * @return _messageHash Prefixed message hash.
     */
    function getEthSignedMessageHash(
        bytes memory _message
    )
        private
        pure
        returns (
            bytes32 _messageHash
        )
    {
        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        bytes32 messageHash = keccak256(_message);
        return keccak256(abi.encodePacked(prefix, messageHash));
    }
}