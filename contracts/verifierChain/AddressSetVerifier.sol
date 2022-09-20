// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {MMR} from "../mmr/MMR.sol";

contract AddressSetVerifier {
    bytes32 public currentRoot;

    address public admin;
    address public guardian;

    event TransferAdmin(address newAdmin);
    event SetGuardian(address guardian);
    event CommitRoot(bytes32 root);

    modifier onlyAdmin() {
        require(msg.sender == admin);
        _;
    }

    /// @notice Only guardian can commit mmr root.
    /// Guardian must be trusted account / contract.
    modifier onlyGuardian() {
        require(msg.sender == guardian);
        _;
    }

    constructor(address _guardian) {
        admin = msg.sender;
        guardian = _guardian;
    }

    function transferAdmin(address newAdmin) public onlyAdmin {
        admin = newAdmin;
        emit TransferAdmin(newAdmin);
    }

    function setGuardian(address newGuardian) public onlyAdmin {
        guardian = newGuardian;
        emit SetGuardian(guardian);
    }

    /// @notice Commits root, only guardian.
    function commitRoot(bytes32 newRoot) public onlyGuardian {
        currentRoot = newRoot;
        emit CommitRoot(newRoot);
    }

    /// @notice Verifies inclusion proof.
    function verify(address addr, bytes memory proof)
        public
        view
        returns (bool)
    {
        (
            bytes32 root,
            uint256 width,
            uint256 index,
            bytes memory value,
            bytes32[] memory peaks,
            bytes32[] memory siblings
        ) = abi.decode(
                proof,
                (bytes32, uint256, uint256, bytes, bytes32[], bytes32[])
            );

        require(root == currentRoot);

        address proveaddr = abi.decode(value, (address));
        require(addr == proveaddr);

        return(
            MMR.inclusionProof(
                root,
                width,
                index,
                value,
                peaks,
                siblings
            )
        );
    }
}
