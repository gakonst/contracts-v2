// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

/* Library Imports */
import { Lib_EthUtils } from "../../optimistic-ethereum/libraries/utils/Lib_EthUtils.sol";

/**
 * @title TestLib_EthUtils
 */
contract TestLib_EthUtils {

    function getCode(
        address _address,
        uint256 _offset,
        uint256 _length
    )
        public
        view
        returns (
            bytes memory _code
        )
    {
        return Lib_EthUtils.getCode(
            _address,
            _offset,
            _length
        );
    }

    function getCode(
        address _address
    )
        public
        view
        returns (
            bytes memory _code
        )
    {
        return Lib_EthUtils.getCode(
            _address
        );
    }

    function getCodeSize(
        address _address
    )
        public
        view
        returns (
            uint256 _codeSize
        )
    {
        return Lib_EthUtils.getCodeSize(
            _address
        );
    }

    function getCodeHash(
        address _address
    )
        public
        view
        returns (
            bytes32 _codeHash
        )
    {
        return Lib_EthUtils.getCodeHash(
            _address
        );
    }

    function createContract(
        bytes memory _code
    )
        public
        returns (
            address _created
        )
    {
        return Lib_EthUtils.createContract(
            _code
        );
    }

    function getAddressForCREATE(
        address _creator,
        uint256 _nonce
    )
        public
        view
        returns (
            address _address
        )
    {
        return Lib_EthUtils.getAddressForCREATE(
            _creator,
            _nonce
        );
    }

    function getAddressForCREATE2(
        address _creator,
        bytes memory _bytecode,
        bytes32 _salt
    )
        public
        view
        returns (address _address)
    {
        return Lib_EthUtils.getAddressForCREATE2(
            _creator,
            _bytecode,
            _salt
        );
    }
}
