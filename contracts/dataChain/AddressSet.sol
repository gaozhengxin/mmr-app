// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {MMR} from "../mmr/MMR.sol";

contract AddressSet {
    using MMR for MMR.Tree;

    MMR.Tree public mmr;

    address public admin;

    event TransferAdmin(address newAdmin);
    event Insert(address addr);
    event Insert(address[] addrs);

    modifier onlyAdmin() {
        require(msg.sender == admin);
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function transferAdmin(address newAdmin) public onlyAdmin {
        admin = newAdmin;
        emit TransferAdmin(admin);
    }

    mapping(address => uint256) public indexOf;

    /// @notice Inserts an address to mmr, only admin.
    function insert(address addr) external onlyAdmin {
        require(indexOf[addr] == 0, "already existed");
        mmr.append(abi.encode(addr));
        indexOf[addr] = MMR.getLeafIndex(mmr.width);
        emit Insert(addr);
    }

    /// @notice Inserts a list of address to mmr, only admin.
    function insert(address[] calldata addrs) external onlyAdmin {
        for (uint256 i = 0; i < addrs.length; i++) {
            require(indexOf[addrs[i]] == 0, "already existed");
            mmr.append(abi.encode(addrs[i]));
            indexOf[addrs[i]] = MMR.getLeafIndex(mmr.width);
        }
        emit Insert(addrs);
    }

    /// @notice returns MMR root.
    function getRoot() public view returns (bytes32) {
        return mmr.root;
    }

    /// @notice Get address inclusion proof.
    function getProof(address addr) public view returns (bytes memory proof) {
        (
            bytes32 root,
            uint256 width,
            bytes32[] memory peaks,
            bytes32[] memory siblings
        ) = mmr.getMerkleProof(indexOf[addr]);
        return
            abi.encode(
                root,
                width,
                indexOf[addr],
                abi.encode(addr),
                peaks,
                siblings
            );
    }

    /// @notice Verifies inclusion proof purely,
    /// omits root hash check.
    function verify(bytes memory proof) public view returns (bool) {
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
        return (getRoot() == root &&
            MMR.inclusionProof(root, width, index, value, peaks, siblings));
    }
}
