// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../verifier/AddressSetVerifier.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract ERC721Admitance is ERC721Enumerable, AddressSetVerifier {

    constructor () ERC721("Test NFT", "TEST") AddressSetVerifier(msg.sender) {}

    uint256 constant MaxSupply = 1000;

    function claim(uint256 tokenId, bytes memory proof) public {
        require(tokenId < MaxSupply, "invalid token id");
        require(verify(msg.sender, proof), "wrong admitance proof");
        _mint(msg.sender, tokenId);
    }
}